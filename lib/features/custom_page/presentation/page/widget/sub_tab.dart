import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/entity/sub_tab_entity.dart';
import '../../../domain/use_case/update_sub_tab_use_case.dart';
import '../../cubit/custom_page_cubit.dart';
import '../../cubit/custom_page_states.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class SubTab extends StatefulWidget {
  const SubTab({super.key});

  @override
  _SubTabState createState() => _SubTabState();
}

class _SubTabState extends State<SubTab> {
  Map<String, bool> _selectedItems = {};

  // Method to initialize categories based on UserPreferences
  Map<String, bool> _initFavouriteCategories(SubTabEntity preferences) {
    return {
      "TripJoin": preferences.tripJoin,
      "Carpool": preferences.carpool,
      "Auction": preferences.auction,
      "Installment": preferences.installment,
      "Booking": preferences.booking,
    };
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.subTab.localize),
      ),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator()..fetchSubTab(),
        child: BlocBuilder<CustomPageCubit, CustomPageState>(
          builder: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              // Load the saved state if available
              if (_selectedItems.isEmpty) {
                _selectedItems = _initFavouriteCategories(state.subTab!);
              }

              return ListView.builder(
                itemCount: _selectedItems.length,
                itemBuilder: (context, index) {
                  final categoryName = _selectedItems.keys.elementAt(index);
                  final isSelected = _selectedItems[categoryName]!;
                  return ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      checkColor: Theme.of(context).scaffoldBackgroundColor,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedItems[categoryName] = value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      categoryName,
                      style: Styles.mediumText(
                          fontSize: 65.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor),
                    ),
                    selected: isSelected,
                  );
                },
              );
            } else if (state.status == CustomPageStates.loading) {
              return const Center(child: CustomCircularProgressIndicator());
            } else {
              return Center(
                  child: Text(LocaleKeys.failedToLoadCategories.localize));
            }
          },
        ),
      ),
      floatingActionButton: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              showSuccessMessage(
                  context, LocaleKeys.updateSuccessfully.localize);
            }
          },
          builder: (BuildContext context, state) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                final selectedCategories = _selectedItems.entries
                    .where((entry) => entry.value == true)
                    .map((entry) => entry.key)
                    .toList();
                // Handle the save or update action
                if (selectedCategories.length == 2) {
                  context.read<CustomPageCubit>().updateSubTab(SubTabParams(
                        tripJoin: _selectedItems["TripJoin"] ?? false,
                        carpool: _selectedItems["Carpool"] ?? false,
                        auction: _selectedItems["Auction"] ?? false,
                        installment: _selectedItems["Installment"] ?? false,
                        booking: _selectedItems["Booking"] ?? false,
                      ));
                } else {
                  // Show a message if the selection is not valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.exactly2items.localize),
                    ),
                  );
                }
              },
              child: Icon(Icons.check,
                  color: Theme.of(context).scaffoldBackgroundColor),
            );
          },
        ),
      ),
    );
  }
}
