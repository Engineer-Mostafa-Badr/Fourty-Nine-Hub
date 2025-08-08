import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../domain/entities/privacy_status_enum.dart';
import '../cubit/privacy_cubit.dart';
import '../pages/user_selection_screen.dart';

class PrivacyMultiSelectItem extends StatefulWidget {
  final String label;
  final String privacy;
  final Function(PrivacyStatus value, List<String>? selectedUsers) onChoose;
  final bool isFriendEnable;
  final String? name;

  const PrivacyMultiSelectItem(
      {super.key,
      required this.label,
      required this.privacy,
      required this.onChoose,
      this.isFriendEnable = true,
      this.name});

  @override
  State<PrivacyMultiSelectItem> createState() => _PrivacyMultiSelectItemState();
}

class _PrivacyMultiSelectItemState extends State<PrivacyMultiSelectItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () async {
      ManageVibration.vibrate();
          PrivacyStatus currentStatus = privacyToPrivacyStatus(widget.privacy);
          final res = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.all(8),
              backgroundColor: AppColors.getFindFillColor(context),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label(text: 'Here ${widget.privacy}'),
                      // Label(text: 'Here ${widget.name}'),
                      //
                      // Label(text: 'Who Can See My ${widget.label}'),
                      _buildPrivacyOption(context, setState,
                          title: LocaleKeys.public.localize,
                          value: PrivacyStatus.public,
                          icon: getPrivacyIcon(PrivacyStatus.public),
                          currentStatus: currentStatus),
                      _buildPrivacyOption(context, setState,
                          title: LocaleKeys.contacts.localize,
                          value: PrivacyStatus.contacts,
                          icon: getPrivacyIcon(PrivacyStatus.contacts),
                          currentStatus: currentStatus),
                      _buildPrivacyOption(context, setState,
                          title: LocaleKeys.friends.localize,
                          value: PrivacyStatus.friends,
                          icon: getPrivacyIcon(PrivacyStatus.friends),
                          currentStatus: currentStatus),
                      _buildPrivacyOption(context, setState,
                          title: LocaleKeys.followers.localize,
                          value: PrivacyStatus.followers,
                          icon: getPrivacyIcon(PrivacyStatus.followers),
                          currentStatus: currentStatus),
                      _buildPrivacyOption(context, setState,
                          title: LocaleKeys.friendsAndFollowers.localize,
                          value: PrivacyStatus.friendsAndFollowers,
                          icon:
                              getPrivacyIcon(PrivacyStatus.friendsAndFollowers),
                          currentStatus: currentStatus),
                      _buildPrivacyOption(context, setState,
                          title: LocaleKeys.onlyMe.localize,
                          value: PrivacyStatus.onlyMe,
                          icon: getPrivacyIcon(PrivacyStatus.onlyMe),
                          currentStatus: currentStatus),
                      _buildPrivacyOption(context, setState,
                          title: LocaleKeys.only_with.localize,
                          value: PrivacyStatus.onlyWith,
                          icon: getPrivacyIcon(PrivacyStatus.onlyWith),
                          currentStatus: currentStatus,
                          showUserDialog: true),
                      _buildPrivacyOption(context, setState,
                          title: context.isArabic
                              ? 'ما عدا...'
                              : LocaleKeys.except_from.localize,
                          value: PrivacyStatus.exceptFrom,
                          currentStatus: currentStatus,
                          icon: getPrivacyIcon(PrivacyStatus.exceptFrom),
                          showUserDialog: true),
                    ],
                  );
                },
              ),
            ),
          );

          if (res != null) {
            final selectedStatus = res as PrivacyStatus;
            List<String>? selectedUsers;

            if (selectedStatus == PrivacyStatus.onlyWith ||
                selectedStatus == PrivacyStatus.exceptFrom) {
              selectedUsers = await showSearchUserDialog(
                context,
                name: widget.name!,
                status: selectedStatus,
              );
              log("Selected Users for $selectedStatus: ${selectedUsers?.join(", ")}");
            }

            widget.onChoose(selectedStatus, selectedUsers);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Label(text: widget.label),
              ),
              Row(
                children: [
                  Label(
                      text: getPrivacyName(
                          privacyToPrivacyStatus(widget.privacy))),
                  const SizedBox(width: 10),
                  Icon(getPrivacyIcon(privacyToPrivacyStatus(widget.privacy)),
                      color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyOption(
    BuildContext context,
    StateSetter setState, {
    required String title,
    required IconData icon,
    required PrivacyStatus value,
    required PrivacyStatus currentStatus,
    bool showUserDialog = false,
  }) {
    return RadioListTile<PrivacyStatus>(
      value: value,
      groupValue: currentStatus,
      onChanged: (selectedValue) async {
        // Use a local variable for currentStatus to avoid mutation
        PrivacyStatus newStatus = selectedValue!;

        setState(() {
          // Update the local status in state
          currentStatus = newStatus;
        });

        List<String>? selectedUserIds;

        if (showUserDialog) {
          selectedUserIds = await showSearchUserDialog(
            context,
            name: widget.name ?? "",
            status: newStatus,
          );

          log("Users selected for $newStatus: $selectedUserIds");
        }

        widget.onChoose(newStatus, selectedUserIds);

        Navigator.pop(context);
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Label(text: title),
          Icon(icon, color: Colors.grey),
        ],
      ),
      activeColor: AppColors.getButtonPrimaryColor(context),
    );
  }

  Future<List<String>?> showSearchUserDialog(BuildContext context,
      {required String name, required PrivacyStatus status}) async {
    final selectedUserIds = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<PrivacyCubit>(),
          child: UserSelectionScreen(name: name, status: status),
        ),
      ),
    );

    return selectedUserIds;
  }

  PrivacyStatus privacyToPrivacyStatus(String privacy) {
    switch (privacy) {
      case 'only-me':
        return PrivacyStatus.onlyMe;
      case 'public':
        return PrivacyStatus.public;
      case 'friends':
        return PrivacyStatus.friends;
      case 'followers':
        return PrivacyStatus.followers;
      case 'friends-and-followers':
        return PrivacyStatus.friendsAndFollowers;
      case 'contacts':
        return PrivacyStatus.contacts;
      case 'only-with':
        return PrivacyStatus.onlyWith;
      case 'except-from':
        return PrivacyStatus.exceptFrom;
      default:
        return PrivacyStatus.public;
    }
  }

  String getPrivacyName(PrivacyStatus status) {
    switch (status) {
      case PrivacyStatus.onlyMe:
        return LocaleKeys.onlyMe.localize;
      case PrivacyStatus.exceptFrom:
        return LocaleKeys.except_from.localize;
      case PrivacyStatus.public:
        return LocaleKeys.public.localize;
      case PrivacyStatus.friends:
        return LocaleKeys.friends.localize;
      case PrivacyStatus.followers:
        return LocaleKeys.followers.localize;
      case PrivacyStatus.friendsAndFollowers:
        return '${LocaleKeys.friends.localize} / ${LocaleKeys.followers.localize}';
      case PrivacyStatus.onlyWith:
        return LocaleKeys.only_with.localize;
      case PrivacyStatus.contacts:
        return LocaleKeys.contacts.localize;
    }
  }

  IconData getPrivacyIcon(PrivacyStatus status) {
    switch (status) {
      case PrivacyStatus.onlyMe:
        return Icons.lock;
      case PrivacyStatus.public:
        return Icons.language;
      case PrivacyStatus.friends:
        return Icons.family_restroom;
      case PrivacyStatus.followers:
        return Icons.accessibility_sharp;
      case PrivacyStatus.friendsAndFollowers:
        return Icons.supervised_user_circle_outlined;
      case PrivacyStatus.exceptFrom:
        return Icons.supervised_user_circle_outlined;
      case PrivacyStatus.onlyWith:
        return Icons.supervised_user_circle_outlined;
      case PrivacyStatus.contacts:
        return Icons.supervised_user_circle_outlined;
    }
  }
}
