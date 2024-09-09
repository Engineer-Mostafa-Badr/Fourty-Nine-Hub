import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  ContactsViewState createState() => ContactsViewState();
}

class ContactsViewState extends State<ContactsView> {
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
          "Contacts",
          style: Styles.headerText(color: Colors.white),
        ),
      ),
      body: _body(),
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
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _contacts![i].displayName,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mediumText(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "A bird in the hand is better than two on the tree.",
                      overflow: TextOverflow.ellipsis,
                      style:
                          Styles.smallText(color: AppColors.LIGHT_GRAY_COLOR2),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
