// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../../../../common/widgets/stateless/buttons/app_button.dart';
// import '../../../../../core/extensions/string_extension.dart';
// import '../../../../../core/localization/locale_keys.g.dart';
// import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import '../../../../zoom/presentation/widgets/join_meeting_screen.dart';
// import '../../../../../res/assets/assets.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../routes/routes.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../../res/style/styles.dart';
// import '../../../../../helpers/manage_vibration.dart';
//
// void showTiktokOption(BuildContext context, int randomNumber) =>
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       // Make background transparent for rounded effect
//       isScrollControlled: true,
//       // Allows the sheet to take more space
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.4,
//           // Adjust as needed
//           maxChildSize: 0.7,
//           minChildSize: 0.2,
//           builder: (_, controller) {
//             return TiktokOptionBottomSheetWidget(
//               randomNumber: randomNumber,
//             );
//           },
//         );
//       },
//     );
//
// class TiktokOptionBottomSheetWidget extends StatelessWidget {
//   const TiktokOptionBottomSheetWidget({
//     super.key,
//     required this.randomNumber,
//   });
//
//   final int randomNumber;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color:
//             Theme.of(context).scaffoldBackgroundColor, // Set background color
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 5,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
//       child: Column(
//         // controller: controller,
//         // shrinkWrap: true,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Header Section
//           Center(
//             child: Container(
//               width: 60,
//               height: 5,
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           Label(
//             text: LocaleKeys.liveStreamOptions.localize,
//             style: Styles.headerText(
//               fontWeight: FontWeight.w500,
//               fontSize: 40,
//             ),
//           ),
//           SizedBox(height: 64.h),
//           // Option 1: Create Live
//           ListTile(
//             contentPadding: EdgeInsets.zero,
//             leading: SvgPicture.asset(Assets.tiktokVedioIcon),
//             title: Label(
//               text: LocaleKeys.createLive.localize,
//               style: Styles.mediumText(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 32,
//               ),
//             ),
//             onTap: () async {
//               ManageVibration.vibrate();
//               Navigator.pop(context);
//               context.push(
//                 Routes.LIVEView,
//                 extra: ZegoArgs(
//                   randomNumber.toString(),
//                   true,
//                   context.read<UserCubit>().state.data?.fullName ?? 'N/A',
//                   // '${UserCubit.to.state.data?.firstName} + ${UserCubit.to.state.data?.lastName}',
//                 ),
//               );
//               // var result = await context.read<StreamCubit>().createLive(
//               //       title: 'create live',
//               //       roomId: randomNumber.toString(),
//               //       context: context,
//               //     );
//               // if (result == true && context.mounted) {
//               //   context.push(
//               //     Routes.LIVEView,
//               //     extra: ZegoArgs(
//               //       context
//               //           .read<StreamCubit>()
//               //           .state
//               //           .liveCreateResponseEntity!
//               //           .id,
//               //       true,
//               //       context.read<UserCubit>().state.data!.fullName,
//               //     ),
//               //   );
//               // } else {
//               //   print("Failed to create live stream");
//               // }
//             },
//           ),
//           const Divider(
//             height: 0,
//             thickness: 2,
//             color: Color(0xffD9D9D9),
//           ),
//           // Option 2: Watch Live
//           ListTile(
//             contentPadding: EdgeInsets.zero,
//             leading: SvgPicture.asset(Assets.tiktokEyeIcon),
//             title: Label(
//               text: LocaleKeys.watch.localize,
//               style: Styles.mediumText(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 32,
//               ),
//             ),
//             onTap: () {
//               ManageVibration.vibrate();
//               context.pop();
//               context.push(Routes.LIVE);
//             },
//           ),
//           const SizedBox(height: 30),
//           // Cancel Button
//           AppButton(
//             label: LocaleKeys.cancel.localize,
//             backColor: AppColors.SECONDARY_COLOR_DARK2,
//             style: Styles.headerText(
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//               fontSize: 32,
//             ),
//             onPressed: () => Navigator.pop(context),
//             // style: ElevatedButton.styleFrom(
//             //   backgroundColor: Colors.redAccent,
//             //   shape: RoundedRectangleBorder(
//             //     borderRadius: BorderRadius.circular(10),
//             //   ),
//             // ),
//           ),
//         ],
//       ),
//     );
//   }
// }
