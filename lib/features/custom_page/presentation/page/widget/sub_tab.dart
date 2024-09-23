import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../res/style/styles.dart';

class SubTab extends StatefulWidget {
  const SubTab({super.key});

  @override
  _SubTabState createState() => _SubTabState();
}

class _SubTabState extends State<SubTab> {
  // A set to keep track of selected items
  Set<int> _selectedItems = {};

  // List of 12 items
  final List<String> _items = [
    'Trip Join',
    'Carpool',
    'Auction',
    'Installment',
    'Chance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sub Tab'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Checkbox(
              value: _selectedItems.contains(index),
              checkColor: Theme.of(context).scaffoldBackgroundColor,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    if (_selectedItems.length < 2) {
                      _selectedItems.add(index);
                    }
                  } else {
                    _selectedItems.remove(index);
                  }
                });
              },
            ),
            title: Text(
              _items[index],
              style: Styles.mediumText(
                  fontSize: 65.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColor
              ),
            ),
            // trailing: Icon(
            //   Icons.arrow_forward_ios_outlined,
            //   size: 40.h,
            // ),
            selected: _selectedItems.contains(index), // Highlight selected item
            // selectedTileColor: Colors.blue.withOpacity(0.1), // Color for selected item
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedItems.length >= 2 && _selectedItems.length <= 2) {
            // Proceed with the selected items
            print('Selected Items: ${_selectedItems.toList()}');
          } else {
            // Show a message if the selection is not valid
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select at least 2 and at most 2 items.'),
              ),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
