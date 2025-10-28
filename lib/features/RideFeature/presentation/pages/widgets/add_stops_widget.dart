// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
// import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
// import 'package:fourtyninehub/features/RideFeature/presentation/pages/gmap_search_and_pick.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../../common/widgets/stateless/buttons/app_button.dart';
// import '../../../../../helpers/manage_vibration.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../service_locator/service_locator.dart';
// import 'package:fourtyninehub/helpers/manage_vibration.dart';
//
// class AddStopsWidget extends StatefulWidget {
//   const AddStopsWidget({super.key, required this.rideCubit});
//   final RideCubit rideCubit;
//
//   @override
//   State<AddStopsWidget> createState() => _AddStopsWidgetState();
// }
//
// class _AddStopsWidgetState extends State<AddStopsWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: widget.rideCubit,
//       child: BlocBuilder<RideCubit, RideState>(
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               children: [
//                 _customLocationField(
//                   isTo: false,
//                   color: Colors.green,
//                   text: state.currentLocation?.address,
//                   onPressed: () async {
//                     ManageVibration.vibrate();
//                     context.push(Routes.GoogleMapsSearchAndPick,
//                         extra: RideGoogleMapSearchAndPickParams(
//                       onPicked: (pickedData) async {
//                         serviceLocator<RideCubit>().updateFromLocation(
//                           lat: pickedData.latitude,
//                           lng: pickedData.longitude,
//                           address: pickedData.address,
//                         );
//                         context.pop();
//                       },
//                     ));
//                   },
//                 ),
//                 if (serviceLocator<RideCubit>().showWaypointOne)
//                   _customLocationField(
//                     isTo: true,
//                     color: Colors.red,
//                     text: state.wayPointOne?.address,
//                     onPressed: () async {
//                       ManageVibration.vibrate();
//                       context.push(Routes.GoogleMapsSearchAndPick,
//                           extra: RideGoogleMapSearchAndPickParams(
//                             onPicked: (pickedData) async {
//                               serviceLocator<RideCubit>().updateWayPointOne(
//                                 lat: pickedData.latitude,
//                                 lng: pickedData.longitude,
//                                 address: pickedData.address,
//                               );
//                               await serviceLocator<RideCubit>()
//                                   .fetchRideExpectedPrice(id: 'id');
//                               context.pop();
//                             },
//                           ));
//                     },
//                     onAddPressed: () {
//                       ManageVibration.vibrate();
//                       setState(() {
//                         serviceLocator<RideCubit>().showWaypointTwo = true;
//                       });
//                     },
//
//                     showAddIcon: state.wayPointOne != null &&
//                         !serviceLocator<RideCubit>().showWaypointTwo,
//                   ),
//                 if (serviceLocator<RideCubit>().showWaypointTwo)
//                   _customLocationField(
//                     isTo: true,
//                     color: Colors.red,
//                     text: state.wayPointTwo?.address,
//                     onPressed: () async {
//                       ManageVibration.vibrate();
//                       context.push(Routes.GoogleMapsSearchAndPick,
//                           extra: RideGoogleMapSearchAndPickParams(
//                             onPicked: (pickedData) async {
//                               serviceLocator<RideCubit>().updateWayPointTwo(
//                                 lat: pickedData.latitude,
//                                 lng: pickedData.longitude,
//                                 address: pickedData.address,
//                               );
//                               await serviceLocator<RideCubit>()
//                                   .fetchRideExpectedPrice(id: 'id');
//                               context.pop();
//                             },
//                           ));
//                     },
//                   ),
//                 _customLocationField(
//                   isTo: true,
//                   color: Colors.blue,
//                   text: state.toLocation?.address,
//                   onPressed: () async {
//                     ManageVibration.vibrate();
//                     context.push(Routes.GoogleMapsSearchAndPick,
//                         extra: RideGoogleMapSearchAndPickParams(
//                       onPicked: (pickedData) async {
//                         serviceLocator<RideCubit>().updateToLocation(
//                           lat: pickedData.latitude,
//                           lng: pickedData.longitude,
//                           address: pickedData.address,
//                         );
//                         await serviceLocator<RideCubit>()
//                             .fetchRideExpectedPrice(id: 'id');
//                         context.pop();
//                       },
//                     ));
//                   },
//                   onAddPressed: () {
//                     setState(() {
//                       serviceLocator<RideCubit>().showWaypointOne = true;
//                     });
//                   },
//                   showAddIcon: state.toLocation != null &&
//                       !serviceLocator<RideCubit>().showWaypointOne,
//                 ),
//
//                 _locationInfoBox(state.toLocation?.address),
//                 if (serviceLocator<RideCubit>().showWaypointOne)
//                   _locationInfoBox(state.wayPointOne?.address),
//                 if (serviceLocator<RideCubit>().showWaypointTwo)
//                   _locationInfoBox(state.wayPointTwo?.address),
//                 const SizedBox(height: 10),
//                 AppButton(
//                   label: context.isArabic ? 'تم' : 'Done',
//                   onPressed: () {
//                     ManageVibration.vibrate();
//                     context.pop();
//                   },
//                   width: MediaQuery.of(context).size.width / 2,
//                   backColor: AppColors.PRIMARY_COLOR,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _locationInfoBox(String? address) {
//     if (address == null) return const SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//         decoration: BoxDecoration(
//           color: context.isDarkMode
//               ? AppColors.GREY_DARK_COLOR
//               : const Color(0xFFEEEEEE),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.location_on_sharp, size: 30),
//             const SizedBox(width: 5),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     address,
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                     // maxLines: 1,
//                     // overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _customLocationField({
//     required Color color,
//     required String? text,
//     required bool isTo,
//     required Function()? onPressed,
//     Function()? onAddPressed,
//     bool showAddIcon = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: InkWell(
//         onTap: onPressed,
//         child: Container(
//           height: 40,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: context.isDarkMode
//                 ? AppColors.GREY_DARK_COLOR
//                 : const Color(0xFFEEEEEE),
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.transparent,
//                 child: CircleAvatar(
//                   backgroundColor: color,
//                   radius: 10,
//                   child: const CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 5,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   text ??
//                       (isTo
//                           ? (context.isArabic ? "إلى" : "To")
//                           : (context.isArabic ? "من" : "From")),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               if (showAddIcon)
//                 GestureDetector(
//                   onTap: onAddPressed,
//                   child: const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Icon(Icons.add, size: 18),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/gmap_search_and_pick.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../service_locator/service_locator.dart';

class AddStopsWidget extends StatefulWidget {
  const AddStopsWidget({super.key, required this.rideCubit});
  final RideCubit rideCubit;

  @override
  State<AddStopsWidget> createState() => _AddStopsWidgetState();
}

class _AddStopsWidgetState extends State<AddStopsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.rideCubit,
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        // From Location Field
                        Padding(
                          padding: EdgeInsets.only(left: context.isArabic ? 0 : 48.w, right: context.isArabic ? 48.w : 0),
                          child: _customLocationField(
                            isTo: false,
                            color: Colors.green,
                            text: state.currentLocation?.address,
                            onPressed: () async {
                              ManageVibration.vibrate();
                              context.push(Routes.GoogleMapsSearchAndPick,
                                  extra: RideGoogleMapSearchAndPickParams(
                                    onPicked: (pickedData) async {
                                      serviceLocator<RideCubit>().updateFromLocation(
                                        lat: pickedData.latitude,
                                        lng: pickedData.longitude,
                                        address: pickedData.address,
                                      );
                                      context.pop();
                                    },
                                  ));
                            },
                          ),
                        ),

                        // Waypoint One (if shown)
                        if (serviceLocator<RideCubit>().showWaypointOne) ...[
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(left: context.isArabic ? 0 : 48.w, right: context.isArabic ? 48.w : 0),
                            child: _customLocationField(
                              isTo: true,
                              color: Colors.red,
                              text: state.wayPointOne?.address,
                              onPressed: () async {
                                ManageVibration.vibrate();
                                context.push(Routes.GoogleMapsSearchAndPick,
                                    extra: RideGoogleMapSearchAndPickParams(
                                      onPicked: (pickedData) async {
                                        serviceLocator<RideCubit>().updateWayPointOne(
                                          lat: pickedData.latitude,
                                          lng: pickedData.longitude,
                                          address: pickedData.address,
                                        );
                                        await serviceLocator<RideCubit>()
                                            .fetchRideExpectedPrice(id: 'id');
                                        context.pop();
                                      },
                                    ));
                              },
                              onAddPressed: () {
                                ManageVibration.vibrate();
                                setState(() {
                                  serviceLocator<RideCubit>().showWaypointTwo = true;
                                });
                              },
                              showAddIcon: state.wayPointOne != null &&
                                  !serviceLocator<RideCubit>().showWaypointTwo,
                            ),
                          ),
                        ],

                        // Waypoint Two (if shown)
                        if (serviceLocator<RideCubit>().showWaypointTwo) ...[
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(left: context.isArabic ? 0 : 48.w, right: context.isArabic ? 48.w : 0),
                            child: _customLocationField(
                              isTo: true,
                              color: Colors.red,
                              text: state.wayPointTwo?.address,
                              onPressed: () async {
                                ManageVibration.vibrate();
                                context.push(Routes.GoogleMapsSearchAndPick,
                                    extra: RideGoogleMapSearchAndPickParams(
                                      onPicked: (pickedData) async {
                                        serviceLocator<RideCubit>().updateWayPointTwo(
                                          lat: pickedData.latitude,
                                          lng: pickedData.longitude,
                                          address: pickedData.address,
                                        );
                                        await serviceLocator<RideCubit>()
                                            .fetchRideExpectedPrice(id: 'id');
                                        context.pop();
                                      },
                                    ));
                              },
                            ),
                          ),
                        ],

                        // To Location Field
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: context.isArabic ? 0 : 48.w, right: context.isArabic ? 48.w : 0),
                          child: _customLocationField(
                            isTo: true,
                            color: Colors.blue,
                            text: state.toLocation?.address,
                            onPressed: () async {
                              ManageVibration.vibrate();
                              context.push(Routes.GoogleMapsSearchAndPick,
                                  extra: RideGoogleMapSearchAndPickParams(
                                    onPicked: (pickedData) async {
                                      serviceLocator<RideCubit>().updateToLocation(
                                        lat: pickedData.latitude,
                                        lng: pickedData.longitude,
                                        address: pickedData.address,
                                      );
                                      await serviceLocator<RideCubit>()
                                          .fetchRideExpectedPrice(id: 'id');
                                      context.pop();
                                    },
                                  ));
                            },
                            onAddPressed: () {
                              ManageVibration.vibrate();
                              setState(() {
                                serviceLocator<RideCubit>().showWaypointOne = true;
                              });
                            },
                            showAddIcon: state.toLocation != null &&
                                !serviceLocator<RideCubit>().showWaypointOne,
                          ),
                        ),
                      ],
                    ),

                    // Stepper Line with Dots
                    Positioned(
                      left: context.isArabic ? null : -10,
                      right: context.isArabic ? -10 : null,
                      top: 0,
                      bottom: 0,
                      child: _buildStepperLine(context, state),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Location Info Boxes
                _locationInfoBox(state.toLocation?.address),
                if (serviceLocator<RideCubit>().showWaypointOne)
                  _locationInfoBox(state.wayPointOne?.address),
                if (serviceLocator<RideCubit>().showWaypointTwo)
                  _locationInfoBox(state.wayPointTwo?.address),

                const SizedBox(height: 10),
                AppButton(
                  label: context.isArabic ? 'تم' : 'Done',
                  onPressed: () {
                    ManageVibration.vibrate();
                    context.pop();
                  },
                  width: MediaQuery.of(context).size.width / 2,
                  backColor: AppColors.PRIMARY_COLOR,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepperLine(BuildContext context, RideState state) {
    bool showWaypoint1 = serviceLocator<RideCubit>().showWaypointOne;
    bool showWaypoint2 = serviceLocator<RideCubit>().showWaypointTwo;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Green dot for "From" location
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 6,
            child: const CircleAvatar(
                backgroundColor: Colors.white, radius: 3),
          ),

          const SizedBox(height: 4),

          // Connecting dots
          ...List.generate(
            4,
                (index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? Colors.grey[600]
                    : Colors.grey[400],
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Red dot for Waypoint 1 (if shown)
          if (showWaypoint1) ...[
            const SizedBox(height: 4),
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 6,
              child: const CircleAvatar(
                  backgroundColor: Colors.white, radius: 3),
            ),
            const SizedBox(height: 4),

            ...List.generate(
              4,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? Colors.grey[600]
                      : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],

          // Red dot for Waypoint 2 (if shown)
          if (showWaypoint2) ...[
            const SizedBox(height: 4),
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 6,
              child: const CircleAvatar(
                  backgroundColor: Colors.white, radius: 3),
            ),
            const SizedBox(height: 4),
            ...List.generate(
              4,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? Colors.grey[600]
                      : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],

          const SizedBox(height: 4),

          // Blue dot for "To" location
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 6,
            child: const CircleAvatar(
                backgroundColor: Colors.white, radius: 3),
          ),
        ],
      ),
    );
  }

  Widget _locationInfoBox(String? address) {
    if (address == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? AppColors.GREY_DARK_COLOR
              : const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_sharp, size: 30),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customLocationField({
    required Color color,
    required String? text,
    required bool isTo,
    required Function()? onPressed,
    Function()? onAddPressed,
    bool showAddIcon = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.isDarkMode
              ? AppColors.GREY_DARK_COLOR
              : const Color(0xFFEEEEEE),
        ),
        child: Row(
          children: [
            // CircleAvatar(
            //   backgroundColor: Colors.transparent,
            //   child: CircleAvatar(
            //     backgroundColor: color,
            //     radius: 10,
            //     child: const CircleAvatar(
            //       backgroundColor: Colors.white,
            //       radius: 5,
            //     ),
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric( horizontal: 8.0),
                child: Text(
                  text ??
                      (isTo
                          ? (context.isArabic ? "إلى" : "To")
                          : (context.isArabic ? "من" : "From")),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (showAddIcon)
              GestureDetector(
                onTap: onAddPressed,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.add, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}