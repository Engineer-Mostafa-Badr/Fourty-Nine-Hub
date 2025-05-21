import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/functions/helper/lang_helper.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../health_feature/create_doctor/domain/entities/city.dart';
import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';
import '../../controllers/client_trips_cubit/client_trips_cubit.dart';
import '../pick_location.dart';
import 'bottom_sheet/custom_bottom_sheet.dart';
import 'dialog_widget/show_custom_dialog_trip.dart';
import 'font_manager.dart';
class PickUpLocationCard extends StatefulWidget {
  final Color? firstColor;
  final ClientTripsCubit cubit;
  final bool isStartLocation;

  const PickUpLocationCard({
    super.key,
    this.firstColor,
    required this.cubit,
    this.isStartLocation = true,
  });

  @override
  State<PickUpLocationCard> createState() => _PickUpLocationCardState();
}

class _PickUpLocationCardState extends State<PickUpLocationCard> {

  showDebtDialog(BuildContext context,) {
    showCustomDialogTrip(
        context,
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose location method',
              style: TextStyle(
                fontSize: 20,
                color: context.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.list, color: AppColors.PRIMARY_COLOR),
                  title: Text('Select from list',
                      style: TextStyle(
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      )),
                  onTap: () => Navigator.pop(context, 'list'),
                ),
                ListTile(
                  leading: Icon(Icons.map, color: AppColors.PRIMARY_COLOR),
                  title: Text('Select from map',
                      style: TextStyle(
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      )),
                  onTap: () => Navigator.pop(context, 'map'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  width: context.screenWidth / 3.4,
                  label: 'Cancel',
                  backColor: AppColors.SECONDARY_COLOR_DARK2,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showLocationMethodDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                 LocaleKeys.location.localize,
                  style: TextStyle(
                    fontSize: 20,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.list, color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
                      title: Text(LocaleKeys.selectFromList.localize,
                          style: TextStyle(
                            color: context.isDarkMode ? Colors.white : Colors.black,
                          )),
                      onTap: () => Navigator.pop(context, 'list'),
                    ),
                    ListTile(
                      leading: Icon(Icons.map, color:  context.isDarkMode ? Colors.white :AppColors.PRIMARY_COLOR),
                      title: Text(LocaleKeys.selectFromMap.localize,
                          style: TextStyle(
                            color: context.isDarkMode ? Colors.white : Colors.black,
                          )),
                      onTap: () => Navigator.pop(context, 'map'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      width: context.screenWidth / 3.4,
                      label: LocaleKeys.cancel.localize,
                      backColor: AppColors.SECONDARY_COLOR_DARK2,
                      onPressed: () => Navigator.pop(context),
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
  // Future<String?> _showLocationMethodDialog(BuildContext context) async {
  //   return await showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Choose location method'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               leading: const Icon(Icons.list),
  //               title: const Text('Select from list'),
  //               onTap: () => Navigator.pop(context, 'list'),
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.map),
  //               title: const Text('Select from map'),
  //               onTap: () => Navigator.pop(context, 'map'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> _handleLocationSelection() async {
    final method = await _showLocationMethodDialog(context);
   // final method = await showDebtDialog(context);
    if (method == 'list') {
      await _selectFromApiList();
    } else if (method == 'map') {
      await _selectFromMap();
    }
  }

  Future<void> _selectFromApiList() async {
    widget.cubit.getGovernorates();
    String resultGovernorate = '';
    String resultCity = '';

    final value = await customBottomSheet2(
      context,
      height: 750.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Wrap ListView with SizedBox to constrain height
          SizedBox(
            height: 650, // Constrain height inside bottom sheet
            child: BlocBuilder<ClientTripsCubit, ClientTripsState>(
              bloc: widget.cubit,
              builder: (context, state) {
                if (state.isLoadingCities || state.isLoadingGovernorates) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.isSuccess && (state.cities?.isNotEmpty ?? false)) {
                  // Show cities list if available
                  return ListView.builder(
                    itemCount: state.cities!.length,
                    itemBuilder: (context, index) {
                      final city = state.cities![index];
                      final cityName = (getLang() == "ar" ? city.nameAr : city.nameEn) ?? "";
                      return GestureDetector(
                        onTap: () {
                          resultCity = cityName;
                          final fullAddress = "$resultGovernorate, $resultCity, Egypt";
                          if (widget.isStartLocation) {
                            widget.cubit.makeNonTrackingTripParam.fromTitle = fullAddress;
                          } else {
                            widget.cubit.makeNonTrackingTripParam.toTitle = fullAddress;
                          }
                          Navigator.pop(context, fullAddress);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            cityName,
                            style: Styles.headerText(color: AppColors.PRIMARY_COLOR),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  // Show governorates list by default
                  return ListView.builder(
                    itemCount: state.governorates?.length ?? 0,
                    itemBuilder: (context, index) {
                      final governorate = state.governorates![index];
                      final governorateName = (getLang() == "ar" ? governorate.nameAr : governorate.nameEn) ?? "";
                      return GestureDetector(
                        onTap: () {
                          resultGovernorate = governorateName;
                          widget.cubit.getCities(governorate.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            governorateName,
                            style: Styles.headerText(color: AppColors.PRIMARY_COLOR),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      title: widget.isStartLocation
          ? (widget.cubit.makeNonTrackingTripParam.fromTitle ?? LocaleKeys.startPoint.localize)
          : (widget.cubit.makeNonTrackingTripParam.toTitle ?? LocaleKeys.destination.localize),
    );

    if (value != null) {
      setState(() {});
    }
  }

  Future<void> _selectFromMap() async {
    final selectedLocation = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Optional: allows custom styling
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9, // Starts at 70% of screen
          maxChildSize: 0.9, // Can expand to 90% of screen
          minChildSize: 0.5, // Can collapse to 50% of screen
          builder: (context, scrollController) {
            return AddressPickerWidget(
              onAddressSelected: (address) {
                Navigator.pop(context, address);
              },
            );
          },
        );
      },
    );

    if (selectedLocation != null) {
      final street = selectedLocation['street'] ?? '';
      final city = selectedLocation['city'] ?? '';
      final region = selectedLocation['region'] ?? '';
      final fullAddress = [street, city, region, 'Egypt']
          .where((e) => e.toString().isNotEmpty)
          .join(', ');

      setState(() {
        if (widget.isStartLocation) {
          widget.cubit.makeNonTrackingTripParam.fromTitle = fullAddress;
        } else {
          widget.cubit.makeNonTrackingTripParam.toTitle = fullAddress;
        }
      });
    }
  }

  // Future<void> _selectFromMap() async {
  //   final selectedLocation = await Navigator.push<Map<String, dynamic>>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AddressPickerWidget(
  //         onAddressSelected: (address) {
  //           Navigator.pop(context, address);
  //         },
  //       ),
  //     ),
  //   );
  //
  //   if (selectedLocation != null) {
  //     final street = selectedLocation['street'] ?? '';
  //     final city = selectedLocation['city'] ?? '';
  //     final region = selectedLocation['region'] ?? '';
  //     final fullAddress = [street, city, region, 'Egypt']
  //         .where((e) => e.toString().isNotEmpty)
  //         .join(', ');
  //
  //     setState(() {
  //       if (widget.isStartLocation) {
  //         widget.cubit.makeNonTrackingTripParam.fromTitle = fullAddress;
  //       } else {
  //         widget.cubit.makeNonTrackingTripParam.toTitle = fullAddress;
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientTripsCubit, ClientTripsState>(
      builder: (context, state) {
        String? title = widget.isStartLocation
            ? (widget.cubit.makeNonTrackingTripParam.fromTitle ?? LocaleKeys.startPoint.localize)
            : (widget.cubit.makeNonTrackingTripParam.toTitle ?? LocaleKeys.destination.localize);

        return GestureDetector(
          onTap: _handleLocationSelection,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: widget.firstColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// class _PickUpLocationCardState extends State<PickUpLocationCard> {
//   Future<String?> _showLocationMethodDialog(BuildContext context) async {
//     return await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Choose location method'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.list),
//                 title: const Text('Select from list'),
//                 onTap: () => Navigator.pop(context, 'list'),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.map),
//                 title: const Text('Select from map'),
//                 onTap: () => Navigator.pop(context, 'map'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _handleLocationSelection() async {
//     final method = await _showLocationMethodDialog(context);
//
//     if (method == 'list') {
//       await _selectFromApiList();
//     } else if (method == 'map') {
//       await _selectFromMap();
//     }
//   }
//
//   Future<void> _selectFromApiList() async {
//     String resultGovernorate = '';
//     String resultCity = '';
//
//     final value = await customBottomSheet2(
//       context,
//       height: 750.0,
//       child: BlocBuilder<ClientTripsCubit, ClientTripsState>(
//         bloc: widget.cubit,
//         builder: (context, state) {
//           if (state.isLoadingCities || state.isLoadingGovernorates) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state.isSuccess) {
//             return Expanded(
//               child: ListView.builder(
//                 itemCount: state.cities?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   CityEntity? city = state.cities?[index];
//                   return GestureDetector(
//                     onTap: () {
//                       resultCity = (getLang() == "ar" ? city?.nameAr : city?.nameEn) ?? "";
//                       final fullAddress = "$resultGovernorate, $resultCity, Egypt";
//                       if (widget.isStartLocation) {
//                         widget.cubit.makeNonTrackingTripParam.fromTitle = fullAddress;
//                       } else {
//                         widget.cubit.makeNonTrackingTripParam.toTitle = fullAddress;
//                       }
//                       Navigator.pop(context, fullAddress);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Text(
//                         (getLang() == "ar" ? city?.nameAr : city?.nameEn) ?? '',
//                         style: Styles.headerText(color: AppColors.PRIMARY_COLOR),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           } else {
//             return Expanded(
//               child: ListView.builder(
//                 itemCount: state.governorates?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   GovernorateEntity? governorate = state.governorates?[index];
//                   return GestureDetector(
//                     onTap: () {
//                       resultGovernorate = (getLang() == "ar" ? governorate?.nameAr : governorate?.nameEn) ?? "";
//                       widget.cubit.getCities(governorate!.id);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Text(
//                         (getLang() == "ar" ? governorate?.nameAr : governorate?.nameEn) ?? '',
//                         style: Styles.headerText(color: AppColors.PRIMARY_COLOR),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//         },
//       ),
//       title: widget.isStartLocation
//           ? (widget.cubit.makeNonTrackingTripParam.fromTitle ?? LocaleKeys.startPoint.localize)
//           : (widget.cubit.makeNonTrackingTripParam.toTitle ?? LocaleKeys.destination.localize),
//     );
//
//     if (value != null) {
//       setState(() {});
//     }
//   }
//   Future<void> _selectFromMap() async {
//     final selectedLocation = await Navigator.push<Map<String, dynamic>>(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddressPickerWidget(
//           onAddressSelected: (address) {
//             Navigator.pop(context, address);
//           },
//         ),
//       ),
//     );
//
//     if (selectedLocation != null) {
//       final street = selectedLocation['street'] ?? '';
//       final city = selectedLocation['city'] ?? '';
//       final region = selectedLocation['region'] ?? '';
//       final fullAddress = [street, city, region, 'Egypt']
//           .where((e) => e.toString().isNotEmpty)
//           .join(', ');
//
//       setState(() {
//         if (widget.isStartLocation) {
//           widget.cubit.makeNonTrackingTripParam.fromTitle = fullAddress;
//         } else {
//           widget.cubit.makeNonTrackingTripParam.toTitle = fullAddress;
//         }
//       });
//     }
//   }
//   // Future<void> _selectFromMap() async {
//   //   final selectedLocation = await showModalBottomSheet<Map<String, dynamic>>(
//   //     context: context,
//   //     isScrollControlled: true,
//   //     builder: (context) => Padding(
//   //       padding: EdgeInsets.only(
//   //         bottom: MediaQuery.of(context).viewInsets.bottom,
//   //       ),
//   //       child: AddressPickerWidget(
//   //         onAddressSelected: (address) => Navigator.pop(context, address),
//   //       ),
//   //     ),
//   //   );
//   //
//   //   if (selectedLocation != null) {
//   //     final street = selectedLocation['street'] ?? '';
//   //     final city = selectedLocation['city'] ?? '';
//   //     final region = selectedLocation['region'] ?? '';
//   //     final fullAddress = [street, city, region, 'Egypt']
//   //         .where((e) => e.toString().isNotEmpty)
//   //         .join(', ');
//   //
//   //     setState(() {
//   //       if (widget.isStartLocation) {
//   //         widget.cubit.makeNonTrackingTripParam.fromTitle = fullAddress;
//   //       } else {
//   //         widget.cubit.makeNonTrackingTripParam.toTitle = fullAddress;
//   //       }
//   //     });
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ClientTripsCubit, ClientTripsState>(
//       builder: (context, state) {
//         String? title = widget.isStartLocation
//             ? (widget.cubit.makeNonTrackingTripParam.fromTitle ?? LocaleKeys.startPoint.localize)
//             : (widget.cubit.makeNonTrackingTripParam.toTitle ?? LocaleKeys.destination.localize);
//
//         return GestureDetector(
//           onTap: _handleLocationSelection,
//           child: Container(
//             height: 48,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF5F5F5),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                   width: 16,
//                   height: 16,
//                   decoration: BoxDecoration(
//                     color: widget.firstColor,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Container(
//                       width: 8,
//                       height: 8,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     title!,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.PRIMARY_COLOR,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }



/*
class PickUpLocationCard extends StatefulWidget {
  final Color? firstColor;
  final ClientTripsCubit cubit;
  final bool isStartLocation;

  const PickUpLocationCard(
      {super.key,
      this.firstColor,
      required this.cubit,
      this.isStartLocation = true});

  @override
  State<PickUpLocationCard> createState() => _PickUpLocationCardState();
}

class _PickUpLocationCardState extends State<PickUpLocationCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientTripsCubit, ClientTripsState>(
      builder: (context, state) {
        String? title = widget.isStartLocation
            ? (widget.cubit.makeNonTrackingTripParam.fromTitle ??
                LocaleKeys.startPoint.localize)
            : (widget.cubit.makeNonTrackingTripParam.toTitle ??
                LocaleKeys.destination.localize);
        return GestureDetector(
          onTap: () {
            widget.cubit.getGovernorates();
            String resultGovernorate = '';
            String resultCity = '';
            customBottomSheet2(context,height: 750.0,
                    child: BlocBuilder<ClientTripsCubit, ClientTripsState>(
                      bloc: widget.cubit,
                      builder: (context, state) {
                        if (state.isLoadingCities ||
                            state.isLoadingGovernorates) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state.isSuccess) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: state.cities?.length,
                              itemBuilder: (context, index) {
                                CityEntity? city = state.cities?[index];
                                return GestureDetector(
                                  onTap: () {
                                    resultCity = (getLang() == "ar"
                                        ? city?.nameAr ?? ""
                                        : city?.nameEn ?? "");
                                    if (widget.isStartLocation) {
                                      widget.cubit.makeNonTrackingTripParam
                                              .fromTitle =
                                          '$resultGovernorate, $resultCity';
                                    } else {
                                      widget.cubit.makeNonTrackingTripParam
                                              .toTitle =
                                          '$resultGovernorate, $resultCity';
                                    }
                                    context
                                        .pop('$resultGovernorate, $resultCity');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      (getLang() == "ar"
                                              ? city?.nameAr
                                              : city?.nameEn) ??
                                          '',
                                      style: Styles.headerText(
                                        color:  AppColors.PRIMARY_COLOR
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Expanded(
                            child: ListView.builder(
                              // shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.governorates?.length,
                              itemBuilder: (context, index) {
                                GovernorateEntity? governorate =
                                    state.governorates?[index];
                                return GestureDetector(
                                  onTap: () {
                                    resultGovernorate = (getLang() == "ar"
                                        ? governorate?.nameAr ?? ""
                                        : governorate?.nameEn ?? "");
                                    widget.cubit.getCities(governorate!.id);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      (getLang() == "ar"
                                              ? governorate?.nameAr
                                              : governorate?.nameEn) ??
                                          '',
                                      style: Styles.headerText(
                                        color:  AppColors.PRIMARY_COLOR
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    title: title!)
                .then((value) {
              setState(() {
                title = value;
              });
            });
          },
          child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: widget.firstColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  // Text "PickUp Location"
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color:  AppColors.PRIMARY_COLOR
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
*/