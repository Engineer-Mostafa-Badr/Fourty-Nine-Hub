import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/message_entity.dart';
import '../../domain/entities/message_shared_contacts_entity.dart';

class ContactsViewParams {
  final MessageEntity messageEntity;
  final ChatRoomCubit chatRoomCubit;
  ContactsViewParams(
      {required this.messageEntity, required this.chatRoomCubit});
}

class ContactsView extends StatefulWidget {
  const ContactsView({super.key, required this.contactsViewParams});
  final ContactsViewParams contactsViewParams;

  @override
  ContactsViewState createState() => ContactsViewState();
}

class ContactsViewState extends State<ContactsView> {
  bool _permissionDenied = false;
  List<Contact>? _contacts;

  @override
  initState() {
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
      value: widget.contactsViewParams.chatRoomCubit,
      child: Builder(builder: (context) {
        context
            .read<ChatRoomCubit>()
            .convertContactsToSharedContacts(contacts: _contacts);
        context.read<ChatRoomCubit>().checkRegirterdContacts(
              contacts: widget.contactsViewParams.messageEntity.sharedContacts,
            );
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.PRIMARY_COLOR, // Background color
            elevation: 0,
            leadingWidth: 26,
            leading: IconButton(
              onPressed: () => context.pop(),
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
              LocaleKeys.contacts.tr(),
              style: Styles.headerText(color: Colors.white),
            ),
          ),
          body: _body(),
        );
      }),
    );
  }

  Widget _body() {
    return ListView.separated(
      itemCount: widget.contactsViewParams.messageEntity.sharedContacts.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
      ),
      itemBuilder: (context, i) {
        return ContactCard(
            contact: widget.contactsViewParams.messageEntity.sharedContacts[i]);
      },
    );
  }
}

class ContactCard extends StatefulWidget {
  const ContactCard({super.key, required this.contact});
  final MessageSharedContactsEntity contact;

  @override
  ContactCardState createState() => ContactCardState();
}

class ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    bool isAdded = false;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: AppColors.BACKGROUND_COLOR,
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              UIConst.profilePlaceHolder,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.name,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.mediumText(fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.contact.phoneNumber,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.smallText(color: AppColors.LIGHT_GRAY_COLOR2),
                )
              ],
            ),
          ),
          const Spacer(),
          widget.contact.isRegistered
              ? Text(
                  'Registered',
                  style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
                )
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isAdded = true;
                    });
                    // Insert new contact
                    final newContact = Contact(
                      name: Name(first: widget.contact.name),
                      phones: [Phone(widget.contact.phoneNumber)],
                    );
                    widget.contact.isRegistered = true;
                    await newContact.insert();
                    setState(() {
                      isAdded = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                  ),
                  child: isAdded
                      ? const Center(
                          child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.BACKGROUND_COLOR,
                              )),
                        )
                      : Text(
                          'Add',
                          style: Styles.mediumText(
                              color: AppColors.BACKGROUND_COLOR),
                        ),
                ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
    );
  }
}
