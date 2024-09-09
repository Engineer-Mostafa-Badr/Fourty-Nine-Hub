import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  ContactsViewState createState() => ContactsViewState();
}

class ContactsViewState extends State<ContactsView> {
  bool _permissionDenied = false;
  List? _contacts;
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
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => ListTile(
            title: Text(_contacts![i].displayName),
            onTap: () async {
              final fullContact =
                  await FlutterContacts.getContact(_contacts![i].id);
            }));
  }
}
