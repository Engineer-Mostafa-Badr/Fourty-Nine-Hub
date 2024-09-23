import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../res/style/styles.dart';

class FavouriteCategory extends StatefulWidget {
  const FavouriteCategory({super.key});

  @override
  _FavouriteCategoryState createState() => _FavouriteCategoryState();
}

class _FavouriteCategoryState extends State<FavouriteCategory> {
  // A set to keep track of selected items
  Set<int> _selectedItems = {};

  // List of 12 items

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Category'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Checkbox(
              value: _selectedItems.contains(index),
              checkColor: Theme.of(context).scaffoldBackgroundColor,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    if (_selectedItems.length < 8) {
                      _selectedItems.add(index);
                    }
                  } else {
                    _selectedItems.remove(index);
                  }
                });
              },
            ),
            title: Text(
              'Item',
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
          if (_selectedItems.length >= 3 && _selectedItems.length <= 8) {
            // Proceed with the selected items
            print('Selected Items: ${_selectedItems.toList()}');
          } else {
            // Show a message if the selection is not valid
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select at least 3 and at most 8 items.'),
              ),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
