import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';
import 'custom_pickup_container.dart';
class CustomDatePickerButton extends StatelessWidget {
  final String selectedDate;
  final Function(String) onDateSelected;

  const CustomDatePickerButton({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  // Future<void> _showCustomDatePicker(BuildContext context) async {
  //   DateTime pickedDate = DateTime.now();
  //
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         content: SizedBox(
  //           width: double.maxFinite,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Theme(
  //                 data: Theme.of(context).copyWith(
  //                   colorScheme: const ColorScheme.light(
  //                     primary: AppColors.PRIMARY_COLOR,
  //                     onPrimary: Colors.white,
  //                   ),
  //                   canvasColor: Colors.white,
  //                 ),
  //                 child: CalendarDatePicker(
  //                   initialDate: pickedDate,
  //                   firstDate: DateTime.now(),
  //                   lastDate: DateTime(2100),
  //                   onDateChanged: (date) {
  //                     pickedDate = date;
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: AppButton(
  //                       radius: 15,
  //                       height: 38,
  //                       backColor: AppColors.PRIMARY_COLOR,
  //                       onPressed: () {
  //                         final newDateStr =
  //                             "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
  //                         onDateSelected(newDateStr);
  //                         Navigator.pop(context);
  //                       },
  //                       label: LocaleKeys.confirm.localize,
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.w500,
  //                         fontSize: 18,
  //                         color: AppColors.LIGHT_COLOR,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Expanded(
  //                     child: AppButton(
  //                       radius: 15,
  //                       height: 38,
  //                       backColor: AppColors.LIGHT_COLOR,
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       label: LocaleKeys.cancel.localize,
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.w500,
  //                         fontSize: 18,
  //                         color: AppColors.PRIMARY_COLOR,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  Future<void> _showCustomDatePicker(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryTextColor = isDark ? Colors.white : Colors.black;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;

    DateTime pickedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.PRIMARY_COLOR,
                      onPrimary: Colors.white,
                      onSurface: primaryTextColor,
                    ),
                    textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: primaryTextColor,
                      displayColor: primaryTextColor,
                    ),
                    canvasColor: backgroundColor,
                  ),
                  child: CalendarDatePicker(
                    initialDate: pickedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    onDateChanged: (date) {
                      pickedDate = date;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        radius: 15,
                        height: 38,
                        backColor: AppColors.PRIMARY_COLOR,
                        onPressed: () {
                          final newDateStr =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          onDateSelected(newDateStr);
                          Navigator.pop(context);
                        },
                        label: LocaleKeys.confirm.localize,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white, // button text color
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton(
                        radius: 15,
                        height: 38,
                        backColor: AppColors.LIGHT_COLOR,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: LocaleKeys.cancel.localize,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String displayDate = selectedDate.isEmpty
        ? LocaleKeys.pickupDate.localize
        : selectedDate;

    return GestureDetector(
      onTap: () => _showCustomDatePicker(context),
      child: PickUpContainer(
        fontWeight: FontWeight.w500,
        title: displayDate,
      ),
    );
  }
}

// class CustomDatePickerButton extends StatefulWidget {
//   final String selectedDate;
//   final Function(String) onDateSelected;
//
//   CustomDatePickerButton({
//     required this.selectedDate,
//     required this.onDateSelected,
//   });
//
//   @override
//   State<CustomDatePickerButton> createState() => _CustomDatePickerButtonState();
// }
//
// class _CustomDatePickerButtonState extends State<CustomDatePickerButton> {
//   late String _selectedDate;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = widget.selectedDate;
//   }
//
//   Future<void> _showCustomDatePicker(BuildContext context) async {
//     DateTime pickedDate = DateTime.now();
//
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: SizedBox(
//             width: double.maxFinite,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Theme(
//                   data: Theme.of(context).copyWith(
//                     colorScheme: const ColorScheme.light(
//                       primary: AppColors.PRIMARY_COLOR,
//                       onPrimary: Colors.white,
//                     ),
//                     canvasColor: Colors.white,
//                   ),
//                   child: CalendarDatePicker(
//                     initialDate: pickedDate,
//                     // Use DateTime.now() to ensure the minimum date is today
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2100),
//                     onDateChanged: (date) {
//                       pickedDate = date;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: AppButton(
//                         radius: 15,
//                         height: 38,
//                         backColor: AppColors.PRIMARY_COLOR,
//                         onPressed: () {
//                           setState(() {
//                             _selectedDate =
//                             "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                           });
//                           widget.onDateSelected(_selectedDate);
//                           Navigator.pop(context);
//                         },
//                         label: LocaleKeys.confirm.localize,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18,
//                           color: AppColors.LIGHT_COLOR,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: AppButton(
//                         radius: 15,
//                         height: 38,
//                         backColor: AppColors.LIGHT_COLOR,
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         label: LocaleKeys.cancel.localize,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 18,
//                           color: AppColors.PRIMARY_COLOR,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showCustomDatePicker(context),
//       child: PickUpContainer(
//         fontWeight: FontWeight.w500,
//         title: _selectedDate,
//       ),
//     );
//   }
// }
