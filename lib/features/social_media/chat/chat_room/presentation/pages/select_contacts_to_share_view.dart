import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/select_contacts_to_share_cart.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/widget/custom_scaffold.dart';

class SelectContactsToShareView extends StatefulWidget {
  const SelectContactsToShareView({super.key, required this.chatRoomCubit});
  final ChatRoomCubit chatRoomCubit;

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
      // Fetch contacts with phone numbers and other details
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.chatRoomCubit,
      child: Builder(builder: (context) {
        if (widget.chatRoomCubit.sharedContacts.isEmpty) {
          widget.chatRoomCubit
              .convertContactsToSharedContacts(contacts: _contacts);
        }
        return CustomScaffold(
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
            onPressed: () async {
              await widget.chatRoomCubit.sendMessage();
              context.pop();
              context.pop();
            },
            backgroundColor: AppColors.PRIMARY_COLOR,
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ),
        );
      }),
    );
  }

  Widget _body() {
    if (_permissionDenied) {
      return Center(child: Text(LocaleKeys.permissionDenied.tr()));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.separated(
      itemCount: widget.chatRoomCubit.sharedContacts.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
      ),
      itemBuilder: (context, i) {
        return SelectContactToShareCart(
            contact: widget.chatRoomCubit.sharedContacts[i]);
      },
    );
  }
}
