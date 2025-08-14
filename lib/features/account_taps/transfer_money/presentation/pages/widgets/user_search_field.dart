// email_search_field.dart
import 'package:flutter/material.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class UserSearchField extends StatelessWidget {
  // المتغيرات التي ستمرر من الخارج
  final TextEditingController controller;
  final List<String> suggestions;
  final Function(String) onEmailSelected;
  final Function(String) onSearchChanged;
  final String labelText;
  final String hintText;

  const UserSearchField({
    super.key,
    required this.controller,
    required this.suggestions,
    required this.onEmailSelected,
    required this.onSearchChanged,
    this.labelText = 'بحث عن بريد إلكتروني',
    this.hintText = 'أدخل البريد الإلكتروني',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: (value) => onSearchChanged(value),
        ),
        if (suggestions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(top: 5),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(suggestions[index]),
                  onTap: () {
                    ManageVibration.vibrate();
                    onEmailSelected(suggestions[index]);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
