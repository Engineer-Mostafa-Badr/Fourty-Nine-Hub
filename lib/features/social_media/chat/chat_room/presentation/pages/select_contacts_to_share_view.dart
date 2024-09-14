import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/select_contacts_to_share_cart.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class SelectContactsToShareView extends StatefulWidget {
  const SelectContactsToShareView({super.key});

  @override
  State<SelectContactsToShareView> createState() =>
      _SelectContactsToShareViewState();
}

class _SelectContactsToShareViewState extends State<SelectContactsToShareView> {
  bool _permissionDenied = false;
  List<Contact>? _contacts;
  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_COLOR,
        elevation: 0,
        leadingWidth: 26,
        leading: IconButton(
          onPressed: () {
            context.pop();
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
        title: Text(
          LocaleKeys.selectContact.tr(),
          style: Styles.headerText(color: Colors.white),
        ),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.push(Routes.CONTACTSVIEW);
        },
        backgroundColor: AppColors.PRIMARY_COLOR,
        child: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.separated(
      itemCount: _contacts!.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
      ),
      itemBuilder: (context, i) {
        return SelectContactToShareCart(contact: _contacts![i]);
      },
    );
  }
}
