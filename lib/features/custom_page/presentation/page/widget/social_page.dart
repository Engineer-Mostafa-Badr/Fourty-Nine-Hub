import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/custom_page/domain/use_case/update_social_page_use_case.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

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
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator()..fetchSocialPage(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {
            if (state.status ==CustomPageStates.success) {
              // Check the state of face to set the selected item
              setState(() {
                _selectedItem = state.social!.face == true ? 0 : 1;
              });
            }
          },
          builder: (BuildContext context, state) {
            if (state.status ==CustomPageStates.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status ==CustomPageStates.success) {
              return ListView.builder(
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
              );
            } else {
              return const Center(child: Text('Error loading social page'));
            }
          },
        ),
      ),
      floatingActionButton: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) =>serviceLocator(),
        child: BlocConsumer<CustomPageCubit,CustomPageState>(
          listener: (BuildContext context, state) {  },
          builder: (BuildContext context, Object? state) {
            return FloatingActionButton(
              onPressed: () {
                if (_selectedItem != null) {
                  // Map selectedItem index to a boolean for 'face'
                  bool face = _selectedItem == 0 ? true : false;

                  // Call the updateSocialPage method with the selected value
                  context.read<CustomPageCubit>().updateSocialPage(SocialPageParams(face: face));

                  print('Selected Item: ${_items[_selectedItem!]}');
                } else {
                  // Show a message if no item is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select at least one item.'),
                    ),
                  );
                }
              },
              child: const Icon(Icons.check),
            );
          },
        ),
      ),

    );
  }
}

