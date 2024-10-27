import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart'; // Import localization keys
import '../../../tinder/data/shared/shared.dart';
import '../../data/models/followers_model.dart';
import '../cubit/stories_cubit.dart';

class StatusPrivacyScreen extends StatefulWidget {
  const StatusPrivacyScreen({super.key});

  @override
  _StatusPrivacyScreenState createState() => _StatusPrivacyScreenState();
}

class _StatusPrivacyScreenState extends State<StatusPrivacyScreen> {
  String _selectedPrivacyOption =
      LocaleKeys.my_contacts.tr(); // Localized string
  final Set<String> _selectedContacts = {};

  final List<String> _privacyOptions = [
    LocaleKeys.my_contacts.tr(), // Localized string
    LocaleKeys.my_contacts_except.tr(), // Localized string
    LocaleKeys.only_share_with.tr(), // Localized string
  ];

  @override
  void initState() {
    super.initState();
    context.read<StoryCubit>().fetchFollowers();
  }

  String? getPrivacyOption(String option) {
    if (option == LocaleKeys.my_contacts.tr()) return 'followers';
    if (option == LocaleKeys.my_contacts_except.tr()) return 'except';
    if (option == LocaleKeys.only_share_with.tr()) return 'only-with';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.status_privacy.tr()), // Localized string
        backgroundColor: AppColors.PRIMARY_COLOR,
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.check,
              color: Colors.white,
            ),
            onPressed: _onSavePrivacySettings,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildPrivacyOptionsSection(),
              const SizedBox(height: 16.0),
              if (_selectedPrivacyOption != LocaleKeys.my_contacts.tr())
                Expanded(child: _buildContactSelector()),
              const SizedBox(height: 16.0),
              _buildFooterMessage(),
            ],
          ),
        ),
      ),
    );
  }

  void _onSavePrivacySettings() async {
    log(_selectedPrivacyOption);

    for (var contact in _selectedContacts) {
      log(contact);
    }

    log(getPrivacyOption(_selectedPrivacyOption)!);

    await context.read<StoryCubit>().updateStoryPrivacy(
          getPrivacyOption(_selectedPrivacyOption)!,
          users: _selectedContacts.toList(),
        );
    Navigator.pop(context);
  }

  Widget _buildPrivacyOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.who_can_see_status.tr(), // Localized string
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        ..._privacyOptions.map((option) => _buildPrivacyOption(option)),
      ],
    );
  }

  Widget _buildPrivacyOption(String title) {
    int exclusionCount =
        _selectedPrivacyOption == title ? _selectedContacts.length : 0;

    return RadioListTile<String>(
      title: Text(title),
      subtitle: (exclusionCount > 0 &&
              _selectedPrivacyOption != LocaleKeys.my_contacts.tr())
          ? Text(
              exclusionCount == 1
                  ? LocaleKeys.one_contact.tr()
                  : '$exclusionCount ${LocaleKeys.contacts.tr()}',
            )
          : null,
      value: title,
      groupValue: _selectedPrivacyOption,
      onChanged: (String? value) {
        setState(() {
          _selectedPrivacyOption = value!;
          if (_selectedPrivacyOption == LocaleKeys.my_contacts.tr()) {
            _selectedContacts.clear();
          }
        });
      },
    );
  }

  Widget _buildContactSelector() {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        if (state.isLoading??false) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.followers.isEmpty??false) {
          return Center(
              child: Text(
                  LocaleKeys.no_contacts_available.tr())); // Localized string
        } else {
          return ListView.builder(
            itemCount: state.followers.length??0,
            itemBuilder: (context, index) {
              return _buildContactListTile(state.followers[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildContactListTile(Follower contact) {
    bool isSelected =
        _selectedContacts.contains(contact.followerId.id.toString());
    return CheckboxListTile(
      title: Text(
        capitalizeAndSplit2Only(
            "${contact.followerId.firstName} ${contact.followerId.lastName}"),
      ),
      value: isSelected,
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _selectedContacts.add(contact.followerId.id.toString());
          } else {
            _selectedContacts.remove(contact.followerId.id.toString());
          }
        });
      },
    );
  }

  Widget _buildFooterMessage() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Text(
                LocaleKeys.privacy_settings_info.tr(), // Localized string
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Colors.grey,
              ),
              onPressed: _showHelpDialog,
            ),
          ],
        ),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.privacy_settings_help.tr()),
        // Localized string
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(LocaleKeys.choose_who_can_see_status.tr()),
              // Localized string
              const SizedBox(height: 8.0),
              Text(LocaleKeys.my_contacts_info.tr()),
              // Localized string
              Text(LocaleKeys.my_contacts_except_info.tr()),
              // Localized string
              Text(LocaleKeys.only_share_with_info.tr()),
              // Localized string
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(LocaleKeys.ok.tr()), // Localized string
          ),
        ],
      ),
    );
  }
}
