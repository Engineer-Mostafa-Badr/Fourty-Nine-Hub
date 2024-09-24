import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';

class NavigateBar extends StatefulWidget {
  const NavigateBar({super.key});

  @override
  _NavigateBarState createState() => _NavigateBarState();
}

class _NavigateBarState extends State<NavigateBar> {
  Set<int> _selectedItems = {};
  final List<String> _items = [
    'Ride',
    'Loading',
    'Health',
    'Meal',
    'Find',
    'Chat',
    'Reel',
    'Tweet',
    'Spotlight',
    'Meet',
    'Live',
    'Snap',
  ];

  final List<String> _icons = [
    Assets.ride,
    Assets.shipping,
    Assets.health,
    Assets.food,
    Assets.social,
    Assets.message,
    Assets.reels,
    Assets.twitter,
    Assets.spotlightIcon,
    Assets.zoomMeeting,
    Assets.live,
    Assets.cameraIcon,
  ];

  Map<String, bool> _itemStatus = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate Bar'),
      ),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) =>
        serviceLocator()..fetchNavigateBar(),
        child: BlocBuilder<CustomPageCubit, CustomPageState>(
          builder: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              // Update item status outside the build method
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _itemStatus = {
                    'Ride': state.navigateBar?.ride ?? false,
                    'Loading': state.navigateBar?.loading ?? false,
                    'Health': state.navigateBar?.health ?? false,
                    'Meal': state.navigateBar?.meal ?? false,
                    'Find': state.navigateBar?.find ?? false,
                    'Chat': state.navigateBar?.chat ?? false,
                    'Reel': state.navigateBar?.reel ?? false,
                    'Tweet': state.navigateBar?.tweet ?? false,
                    'Spotlight': state.navigateBar?.spotlight ?? false,
                    'Meet': state.navigateBar?.meet ?? false,
                    'Live': state.navigateBar?.live ?? false,
                    'Snap': state.navigateBar?.snap ?? false,
                  };
                });
              });
            }

            return ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                String currentItem = _items[index];
                bool isSelected = _itemStatus[currentItem] ?? false;

                return ListTile(
                  leading: Checkbox(
                    value: _selectedItems.contains(index),
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    activeColor:
                    isSelected ? Colors.red : Colors.white, // Red if true, white if false
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (_selectedItems.length < 5) {
                            _selectedItems.add(index);
                          }
                        } else {
                          _selectedItems.remove(index);
                        }
                      });
                    },
                  ),
                  title: Text(
                    currentItem,
                    style: Styles.mediumText(
                        fontSize: 65.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor),
                  ),
                  trailing: SvgPicture.asset(_icons[index],height: 40.h,),
                  selected: _selectedItems.contains(index),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {},
          builder: (BuildContext context, Object? state) {
            return FloatingActionButton(
              onPressed: () {
                if (_selectedItems.length >= 3 && _selectedItems.length <= 5) {
                  // Proceed with the selected items
                  print('Selected Items: ${_selectedItems.toList()}');
                } else {
                  // Show a message if the selection is not valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Please select at least 3 and at most 5 items.'),
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






// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
// import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
//
// import '../../../../../res/style/styles.dart';
// import '../../../../../service_locator/service_locator.dart';
//
// class NavigateBar extends StatefulWidget {
//   const NavigateBar({super.key});
//
//   @override
//   _NavigateBarState createState() => _NavigateBarState();
// }
//
// class _NavigateBarState extends State<NavigateBar> {
//   // A set to keep track of selected items
//   Set<int> _selectedItems = {};
//
//   // List of 12 items
//   final List<String> _items = [
//     'Ride',
//     'Loading',
//     'Health',
//     'Meal',
//     'Find',
//     'Chat',
//     'Reel',
//     'Tweet',
//     'Spotlight',
//     'Meet',
//     'Live',
//     'Snap',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Navigate Bar'),
//       ),
//       body: BlocProvider<CustomPageCubit>(
//         create: (BuildContext context) => serviceLocator()..fetchNavigateBar(),
//         child: BlocBuilder<CustomPageCubit, CustomPageState>(
//           builder: (BuildContext context, state) {
//             return ListView.builder(
//               itemCount: _items.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: Checkbox(
//                     value: _selectedItems.contains(index),
//                     checkColor: Theme.of(context).scaffoldBackgroundColor,
//                     activeColor: Theme.of(context).primaryColor,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         if (value == true) {
//                           if (_selectedItems.length < 5) {
//                             _selectedItems.add(index);
//                           }
//                         } else {
//                           _selectedItems.remove(index);
//                         }
//                       });
//                     },
//                   ),
//                   title: Text(
//                     _items[index],
//                     style: Styles.mediumText(
//                         fontSize: 65.sp,
//                         fontWeight: FontWeight.w400,
//                         color: Theme.of(context).primaryColor),
//                   ),
//                   // trailing: Icon(
//                   //   Icons.arrow_forward_ios_outlined,
//                   //   size: 40.h,
//                   // ),
//                   selected:
//                       _selectedItems.contains(index), // Highlight selected item
//                   // selectedTileColor: Colors.blue.withOpacity(0.1), // Color for selected item
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: BlocProvider<CustomPageCubit>(
//         create: (BuildContext context) => serviceLocator(),
//         child: BlocConsumer<CustomPageCubit, CustomPageState>(
//           listener: (BuildContext context, state) {},
//           builder: (BuildContext context, Object? state) {
//             return FloatingActionButton(
//               onPressed: () {
//                 if (_selectedItems.length >= 3 && _selectedItems.length <= 5) {
//                   // Proceed with the selected items
//                   print('Selected Items: ${_selectedItems.toList()}');
//                 } else {
//                   // Show a message if the selection is not valid
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content:
//                           Text('Please select at least 3 and at most 5 items.'),
//                     ),
//                   );
//                 }
//               },
//               child: const Icon(Icons.check),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
