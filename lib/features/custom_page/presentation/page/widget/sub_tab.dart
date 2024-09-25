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
    LocaleKeys.tripJoin.localize,
    LocaleKeys.carpool.localize,
    LocaleKeys.auction.localize,
    LocaleKeys.installments.localize,
    LocaleKeys.chance.localize,
  ];

  // Update selection based on the condition
  void updateSelection(bool condition, String localizedItem) {
    int itemIndex = _items.indexOf(localizedItem);
    if (condition) {
      _selectedItems.add(itemIndex); // Add if true
    } else {
      _selectedItems.remove(itemIndex); // Remove if false
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.subTab.localize),
      ),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator()..fetchSubTab(),
        child: BlocBuilder<CustomPageCubit, CustomPageState>(
          builder: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              // Set selected items based on the fetched state
              updateSelection(state.subTab!.tripJoin, LocaleKeys.tripJoin.localize);
              updateSelection(state.subTab!.carpool, LocaleKeys.carpool.localize);
              updateSelection(state.subTab!.auction, LocaleKeys.auction.localize);
              updateSelection(state.subTab!.installment, LocaleKeys.installments.localize);
              updateSelection(state.subTab!.chance, LocaleKeys.chance.localize);
            }

            return ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: _selectedItems.contains(index), // Reflect current selection
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true && _selectedItems.length < 5) {
                          _selectedItems.add(index);
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
        create: (BuildContext context) => serviceLocator(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              showSuccessMessage(context, LocaleKeys.updateSuccessfully.localize);
            }
          },
          builder: (BuildContext context, state) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                if (_selectedItems.length == 2) {
                  // Update the selected items using the Cubit
                  context.read<CustomPageCubit>().updateSubTab(SubTabParams(
                    tripJoin: _selectedItems.contains(_items.indexOf(LocaleKeys.tripJoin.localize)),
                    carpool: _selectedItems.contains(_items.indexOf(LocaleKeys.carpool.localize)),
                    auction: _selectedItems.contains(_items.indexOf(LocaleKeys.auction.localize)),
                    installment: _selectedItems.contains(_items.indexOf(LocaleKeys.installments.localize)),
                    chance: _selectedItems.contains(_items.indexOf(LocaleKeys.chance.localize)),
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
              child: Icon(Icons.check, color: Theme.of(context).scaffoldBackgroundColor),
            );
          },
        ),
      ),
    );
  }
}

