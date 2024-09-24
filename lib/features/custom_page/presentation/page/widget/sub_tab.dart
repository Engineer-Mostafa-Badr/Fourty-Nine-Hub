import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/use_case/update_sub_tab_use_case.dart';

class SubTab extends StatefulWidget {
  const SubTab({super.key});

  @override
  _SubTabState createState() => _SubTabState();
}

class _SubTabState extends State<SubTab> {
  // A set to keep track of selected items
  Set<int> _selectedItems = {};

  // List of items
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
        title:  Text(LocaleKeys.subTab.localize),
      ),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator()..fetchSubTab(),
        child: BlocBuilder<CustomPageCubit, CustomPageState>(
          builder: (BuildContext context, state) {
            return ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
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
                    ],
                  ),
                  title: Text(
                    _items[index],
                    style: Styles.mediumText(
                      fontSize: 65.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  selected: _selectedItems.contains(index), // Highlight selected item
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) =>serviceLocator(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {
            if(state.status ==CustomPageStates.success){
              showSuccessMessage(context, LocaleKeys.updateSuccessfully.localize);
            }
          },
          builder: (BuildContext context, state) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                if (_selectedItems.length == 2) {
                  context.read<CustomPageCubit>().updateSubTab(SubTabParams(
                    tripJoin: _selectedItems.contains(_items.indexOf('Trip Join')),
                    carpool: _selectedItems.contains(_items.indexOf('Carpool')),
                    auction: _selectedItems.contains(_items.indexOf('Auction')),
                    installment: _selectedItems.contains(_items.indexOf('Installment')),
                    chance: _selectedItems.contains(_items.indexOf('Chance')),
                  ));
                  // Proceed with the selected items
                  print('Selected Items: ${_selectedItems.toList()}');
                } else {
                  // Show a message if the selection is not valid
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text(LocaleKeys.exactly2items.localize),
                    ),
                  );
                }
              },
              child:  Icon(Icons.check,color: Theme.of(context).scaffoldBackgroundColor,),
            );
          },
        ),
      ),
    );
  }
}
