import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/entity/sub_tab_entity.dart';
import '../../../domain/use_case/update_sub_tab_use_case.dart';
import '../../cubit/custom_page_cubit.dart';
import '../../cubit/custom_page_states.dart';

class SubTab extends StatefulWidget {
  const SubTab({super.key});

  @override
  _SubTabState createState() => _SubTabState();
}

class _SubTabState extends State<SubTab> {
  Set<int> _selectedItems = {};
  final List<String> _items = [
    'Trip Join',
    'Carpool',
    'Auction',
    'Installments',
    'Chance',
  ];

  @override
  void initState() {
    super.initState();
  }

  void _loadSavedState(SubTabEntity subTabEntity) {
    setState(() {
     // _selectedItems.clear(); // Clear previous selections

      // Load the state based on the SubTabEntity values
      if (subTabEntity.tripJoin) {
        _selectedItems.add(_items.indexOf('Trip Join'));
      }
      if (subTabEntity.carpool) {
        _selectedItems.add(_items.indexOf('Carpool'));
      }
      if (subTabEntity.auction) {
        _selectedItems.add(_items.indexOf('Auction'));
      }
      if (subTabEntity.installment) {
        _selectedItems.add(_items.indexOf('Installments'));
      }
      if (subTabEntity.chance) {
        _selectedItems.add(_items.indexOf('Chance'));
      }
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      // Toggle the selection
      if (_selectedItems.contains(index)) {
        _selectedItems.remove(index); // Remove if already selected
      } else {
        _selectedItems.add(index); // Add if not selected
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SubTab Example'),
      ),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator()..fetchSubTab(),
        child: BlocBuilder<CustomPageCubit, CustomPageState>(
          builder: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              // Load the saved state if available
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (state.subTab != null) {
                  _loadSavedState(state.subTab!);
                }
              });

              return ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedItems.contains(index);
                  return ListTile(
                    leading: Checkbox(
                      value: isSelected, // Checkbox state
                      checkColor: Colors.white,
                      activeColor: Colors.blue,
                      onChanged: (bool? value) {
                        // Toggle the selection when checkbox is pressed
                        _toggleSelection(index);
                      },
                    ),
                    title: Text(
                      _items[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      isSelected ? 'True' : 'False', // Display based on state
                      style: TextStyle(
                        color: isSelected ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSelected,
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              showSuccessMessage(context, 'Updated successfully!');
            }
          },
          builder: (BuildContext context, state) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                // Handle the save or update action
                context.read<CustomPageCubit>().updateSubTab(SubTabParams(
                  tripJoin: _selectedItems.contains(_items.indexOf('Trip Join')),
                  carpool: _selectedItems.contains(_items.indexOf('Carpool')),
                  auction: _selectedItems.contains(_items.indexOf('Auction')),
                  installment: _selectedItems.contains(_items.indexOf('Installments')),
                  chance: _selectedItems.contains(_items.indexOf('Chance')),
                ));
              },
              child: Icon(Icons.check, color: Theme.of(context).scaffoldBackgroundColor),
            );
          },
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
//
// import '../../../../../core/localization/locale_keys.g.dart';
// import '../../../../../core/messages/messages.dart';
// import '../../../../../service_locator/service_locator.dart';
// import '../../../domain/use_case/update_sub_tab_use_case.dart';
// import '../../cubit/custom_page_cubit.dart';
// import '../../cubit/custom_page_states.dart';
//
// class SubTab extends StatefulWidget {
//   const SubTab({super.key});
//
//   @override
//   _SubTabState createState() => _SubTabState();
// }
//
// class _SubTabState extends State<SubTab> {
//   // A set to keep track of selected items (stores index of fully selected items)
//   Set<int> _selectedItems = {};
//
//   // Track intermediate states separately
//   Set<int> _intermediateItems = {};
//
//   // List of items
//   final List<String> _items = [
//     'Trip Join',
//     'Carpool',
//     'Auction',
//     'Installments',
//     'Chance',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     // Simulate fetching saved states (for demonstration, assuming items 1 and 3 were selected previously)
//     _loadSavedState();
//   }
//
//   // Simulate loading saved state from storage (this could be from an API or local storage)
//   void _loadSavedState() {
//     // Example: Items at index 1 and 3 were selected before
//     setState(() {
//       _selectedItems.add(1); // Carpool was selected
//       _selectedItems.add(3); // Installments was selected
//     });
//   }
//
//   // Helper to toggle between true, false, and intermediate
//   void toggleSelection(int index) {
//     setState(() {
//       if (_selectedItems.contains(index)) {
//         // Move to intermediate state
//         _selectedItems.remove(index);
//         _intermediateItems.add(index);
//       } else if (_intermediateItems.contains(index)) {
//         // Move to false state (uncheck)
//         _intermediateItems.remove(index);
//       } else {
//         // Move to true state (checked)
//         _selectedItems.add(index);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SubTab Example'),
//       ),
//       body: BlocProvider<CustomPageCubit>(
//         create: (BuildContext context) => serviceLocator()..fetchSubTab(),
//         child: BlocBuilder<CustomPageCubit, CustomPageState>(
//           builder: (BuildContext context, state) {
//             return ListView.builder(
//               itemCount: _items.length,
//               itemBuilder: (context, index) {
//                 bool isSelected = _selectedItems.contains(index);
//                 return ListTile(
//                   leading: Checkbox(
//                     value: isSelected
//                         ? true
//                         : false, // Tri-state logic
//                     checkColor: Colors.white,
//                     activeColor: Colors.blue,
//                     tristate: true, // Enable intermediate state
//                     onChanged: (bool? value) {
//                       toggleSelection(index);
//                     },
//                   ),
//                   title: Text(
//                     _items[index],
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                   trailing: Text(
//                     isSelected
//                         ? 'True'
//                         : 'False', // Display based on state
//                     style: TextStyle(
//                       color: isSelected
//                           ? Colors.green
//                           : Colors.red,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   selected: isSelected, // Highlight selected or intermediate
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: BlocProvider<CustomPageCubit>(
//         create: (BuildContext context) => serviceLocator(),
//         child: BlocConsumer<CustomPageCubit, CustomPageState>(
//           listener: (BuildContext context, state) {
//             if (state.status == CustomPageStates.success) {
//               showSuccessMessage(context, LocaleKeys.updateSuccessfully.localize);
//             }
//           },
//           builder: (BuildContext context, state) {
//             return FloatingActionButton(
//               backgroundColor: Theme.of(context).primaryColor,
//               onPressed: () {
//                 if (_selectedItems.length == 2) {
//                   // Update the selected items using the Cubit
//                   context.read<CustomPageCubit>().updateSubTab(SubTabParams(
//                     tripJoin: _selectedItems.contains(_items.indexOf(LocaleKeys.tripJoin.localize)),
//                     carpool: _selectedItems.contains(_items.indexOf(LocaleKeys.carpool.localize)),
//                     auction: _selectedItems.contains(_items.indexOf(LocaleKeys.auction.localize)),
//                     installment: _selectedItems.contains(_items.indexOf(LocaleKeys.installments.localize)),
//                     chance: _selectedItems.contains(_items.indexOf(LocaleKeys.chance.localize)),
//                   ));
//                   // Proceed with the selected items
//                   print('Selected Items: ${_selectedItems.toList()}');
//                 } else {
//                   // Show a message if the selection is not valid
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(LocaleKeys.exactly2items.localize),
//                     ),
//                   );
//                 }
//               },
//               child: Icon(Icons.check, color: Theme.of(context).scaffoldBackgroundColor),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }