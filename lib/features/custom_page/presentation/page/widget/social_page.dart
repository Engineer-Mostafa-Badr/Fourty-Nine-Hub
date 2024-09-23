import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../res/style/styles.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  // Variable to keep track of the selected item index
  int? _selectedItem;

  // List of 2 items
  final List<String> _items = [
    '49 Face',
    '49 Insta',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Page'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Radio<int>(
              value: index,
              groupValue: _selectedItem, // Currently selected item
              activeColor: Theme.of(context).primaryColor, // Color when selected
              onChanged: (int? value) {
                setState(() {
                  _selectedItem = value; // Update selected item
                });
              },
            ),
            title: Text(
              _items[index],
              style: Styles.mediumText(
                fontSize: 65.sp,
                fontWeight: FontWeight.w400,
                color: _selectedItem == index
                    ? Theme.of(context).primaryColor
                    : Colors.black, // Color changes if selected
              ),
            ),
            selected: _selectedItem == index, // Highlight selected item
            selectedTileColor: Colors.transparent, // Optional color change for selected item
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedItem != null) {
            // Proceed with the selected item
            print('Selected Item: ${_items[_selectedItem!]}');
          } else {
            // Show a message if no item is selected
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select at least 1 item.'),
              ),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
