// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
// // // // import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
// // // // import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// // // // import 'package:fourtyninehub/core/enums/reports_enum.dart';
// // // // import 'package:fourtyninehub/core/error/failure.dart';
// // // // import 'package:fourtyninehub/core/messages/messages.dart';
// // // // import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
// // // // import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
// // // // import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
// // // // import 'package:fourtyninehub/res/style/app_colors.dart';
// // // // import 'package:fourtyninehub/res/style/styles.dart';
// // // // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // // // import 'package:go_router/go_router.dart';
// // // //
// // // // class ReportView extends StatefulWidget {
// // // //   const ReportView({
// // // //     super.key,
// // // //     required this.id,
// // // //     required String categoryId,
// // // //   });
// // // //
// // // //   final String id;
// // // //
// // // //   @override
// // // //   State<ReportView> createState() => _ReportViewState();
// // // // }
// // // //
// // // // class _ReportViewState extends State<ReportView> {
// // // //   final reportTextController = TextEditingController();
// // // //   ReportsEnum? selectedReport;
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     List<ReportsEnum> reports = ReportsEnum.values;
// // // //     return Scaffold(
// // // //       backgroundColor: Colors.transparent,
// // // //       body: BlocProvider<TwitterCubit>(
// // // //         create: (_) => serviceLocator(),
// // // //         child: BlocBuilder<TwitterCubit, TwitterState>(
// // // //           builder: (context, state) {
// // // //             final controller = context.read<TwitterCubit>();
// // // //             return Column(
// // // //               children: [
// // // //                 Row(
// // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // //                   children: [
// // // //                     Label(
// // // //                       text: "Report",
// // // //                       style: Styles.headerText(
// // // //                         fontSize: 24,
// // // //                         fontWeight: FontWeight.bold,
// // // //                         color: Colors.black,
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(
// // // //                       width: 10,
// // // //                     ),
// // // //                     const Icon(
// // // //                       Icons.report_gmailerrorred_rounded,
// // // //                       color: AppColors.SECONDARY_COLOR,
// // // //                       size: 30,
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 const SizedBox(
// // // //                   height: 10,
// // // //                 ),
// // // //                 Expanded(
// // // //                   child: ListView.separated(
// // // //                     shrinkWrap: true,
// // // //                     itemCount: reports.length,
// // // //                     separatorBuilder: (context, i) => const SizedBox(
// // // //                       height: 10,
// // // //                     ),
// // // //                     itemBuilder: (context, i) {
// // // //                       return Row(
// // // //                         children: [
// // // //                           Expanded(
// // // //                             child: Label(
// // // //                               text: TinderSharedUtils.capitalizeEachWord(
// // // //                                   reports[i].name),
// // // //                               style: Styles.headerText(
// // // //                                 fontWeight: FontWeight.bold,
// // // //                                 color: AppColors.DARK_GRAY_COLOR,
// // // //                               ),
// // // //                               maxLines: 3,
// // // //                             ),
// // // //                           ),
// // // //                           Checkbox(
// // // //                             value: selectedReport == reports[i],
// // // //                             onChanged: (v) {
// // // //                               setState(() {
// // // //                                 selectedReport = v! ? reports[i] : null;
// // // //                               });
// // // //                             },
// // // //                             activeColor: AppColors.SECONDARY_COLOR,
// // // //                           ),
// // // //                         ],
// // // //                       );
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //                 Row(
// // // //                   children: [
// // // //                     Expanded(
// // // //                       child: FormTextField(
// // // //                         hint: 'Type report reason ....',
// // // //                         height: kToolbarHeight * .7,
// // // //                         action: (v) {
// // // //                           setState(() {});
// // // //                         },
// // // //                         controller: reportTextController,
// // // //                       ),
// // // //                     ),
// // // //                     if (reportTextController.text.isNotEmpty)
// // // //                       IconAppButton(
// // // //                         icon: Icons.send,
// // // //                         isCircle: true,
// // // //                         onPressed: () async {
// // // //                           if (selectedReport == null) {
// // // //                             showErrorMessage(context, "Please select reason!");
// // // //                           } else {
// // // //                             var response = await controller.onReport(
// // // //                               TwitterReportParams(
// // // //                                 userId: widget.id,
// // // //                                 category: selectedReport!.name,
// // // //                                 content: reportTextController.text,
// // // //                                 categoryId: '66a3583454e6e337915514db',
// // // //                                 reason: selectedReport!.name,
// // // //                               ),
// // // //                             );
// // // //
// // // //                             if (response == true) {
// // // //                               showSuccessMessage(
// // // //                                 context,
// // // //                                 "Report send successfully",
// // // //                               );
// // // //                               context.pop();
// // // //                             } else {
// // // //                               showErrorMessage(
// // // //                                 context,
// // // //                                 getFailureMessage(
// // // //                                   state.failure ?? const UnknownFailure(''),
// // // //                                   context,
// // // //                                 ),
// // // //                               );
// // // //                             }
// // // //                           }
// // // //                         },
// // // //                       ),
// // // //                   ],
// // // //                 ),
// // // //               ],
// // // //             );
// // // //           },
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
// // // import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// // // import 'package:fourtyninehub/core/enums/reports_enum.dart';
// // // import 'package:fourtyninehub/core/error/failure.dart';
// // // import 'package:fourtyninehub/core/messages/messages.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
// // // import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
// // // import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
// // // import 'package:fourtyninehub/res/style/app_colors.dart';
// // // import 'package:fourtyninehub/res/style/styles.dart';
// // // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // // import 'package:go_router/go_router.dart';
// // //
// // // class ReportView extends StatefulWidget {
// // //   const ReportView({
// // //     super.key,
// // //     required this.id,
// // //     required String categoryId,
// // //   });
// // //
// // //   final String id;
// // //
// // //   @override
// // //   State<ReportView> createState() => _ReportViewState();
// // // }
// // //
// // // class _ReportViewState extends State<ReportView> {
// // //   final reportTextController = TextEditingController();
// // //   ReportsEnum? selectedReport;
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     List<ReportsEnum> reports = ReportsEnum.values;
// // //     final screenWidth = MediaQuery.of(context).size.width;
// // //
// // //     return Scaffold(
// // //       backgroundColor: Colors.transparent,
// // //       body: BlocProvider<TwitterCubit>(
// // //         create: (_) => serviceLocator(),
// // //         child: BlocBuilder<TwitterCubit, TwitterState>(
// // //           builder: (context, state) {
// // //             final controller = context.read<TwitterCubit>();
// // //             return Padding(
// // //               padding: EdgeInsets.symmetric(
// // //                 horizontal: screenWidth * 0.05,
// // //               ),
// // //               child: Column(
// // //                 children: [
// // //                   Row(
// // //                     mainAxisAlignment: MainAxisAlignment.center,
// // //                     children: [
// // //                       Label(
// // //                         text: "Report",
// // //                         style: Styles.headerText(
// // //                           fontSize: screenWidth * 0.07,
// // //                           fontWeight: FontWeight.bold,
// // //                           color: Colors.black,
// // //                         ),
// // //                       ),
// // //                       const SizedBox(
// // //                         width: 10,
// // //                       ),
// // //                       const Icon(
// // //                         Icons.report_gmailerrorred_rounded,
// // //                         color: AppColors.SECONDARY_COLOR,
// // //                         size: 30,
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(
// // //                     height: 10,
// // //                   ),
// // //                   Expanded(
// // //                     child: ListView.separated(
// // //                       shrinkWrap: true,
// // //                       itemCount: reports.length,
// // //                       separatorBuilder: (context, i) => const SizedBox(
// // //                         height: 10,
// // //                       ),
// // //                       itemBuilder: (context, i) {
// // //                         return Row(
// // //                           children: [
// // //                             Expanded(
// // //                               child: Label(
// // //                                 text: capitalizeAndSplit(
// // //                                     reports[i].name),
// // //                                 style: Styles.headerText(
// // //                                   fontSize: screenWidth * 0.05,
// // //                                   fontWeight: FontWeight.bold,
// // //                                   color: AppColors.DARK_GRAY_COLOR,
// // //                                 ),
// // //                                 maxLines: 3,
// // //                               ),
// // //                             ),
// // //                             Radio<ReportsEnum>(
// // //                               value: reports[i],
// // //                               groupValue: selectedReport,
// // //                               onChanged: (ReportsEnum? value) {
// // //                                 setState(() {
// // //                                   selectedReport = value;
// // //                                 });
// // //                               },
// // //                               activeColor: AppColors.SECONDARY_COLOR,
// // //                             ),
// // //                           ],
// // //                         );
// // //                       },
// // //                     ),
// // //                   ),
// // //                   Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                     children: [
// // //                       Expanded(
// // //                         child: TextField(
// // //                           style: Styles.headerText(
// // //                             fontSize: MediaQuery.of(context).size.width * 0.04,
// // //                             fontWeight: FontWeight.bold,
// // //                             color: AppColors.DARK_BLUE_COLOR,
// // //                           ),
// // //                           // hint: 'Type report reason...',
// // //                           // height: MediaQuery.of(context).size.height * 0.07,
// // //                           // action: (v) {
// // //                           //   setState(() {});
// // //                           // },
// // //                           onChanged: (value) {
// // //                             setState(() {});
// // //                           },
// // //                           controller: reportTextController,
// // //
// // //                           decoration: InputDecoration(
// // //                             fillColor: AppColors.UNSELECTED_GRAY_COLOR,
// // //                             contentPadding: EdgeInsets.symmetric(
// // //                               vertical:
// // //                                   MediaQuery.of(context).size.height * 0.02,
// // //                               horizontal: 16.0,
// // //                             ),
// // //                             hintText: 'Type report reason...',
// // //                             hintStyle: TextStyle(
// // //                               fontSize:
// // //                                   MediaQuery.of(context).size.width * 0.04,
// // //                               color: AppColors.BARRIER_COLOR,
// // //                             ),
// // //                             border: OutlineInputBorder(
// // //                               borderRadius: BorderRadius.circular(8.0),
// // //                               borderSide: const BorderSide(
// // //                                   color: AppColors.LIGHT_GRAY_COLOR),
// // //                             ),
// // //                             focusedBorder: OutlineInputBorder(
// // //                               borderRadius: BorderRadius.circular(8.0),
// // //                               borderSide: const BorderSide(
// // //                                   color: AppColors.PRIMARY_COLOR),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(
// // //                         width: 8,
// // //                       ),
// // //                       if (reportTextController.text.isNotEmpty)
// // //                         IconAppButton(
// // //                           height: screenWidth * 0.1,
// // //                           width: screenWidth * 0.1,
// // //                           icon: Icons.send,
// // //                           isCircle: true,
// // //                           onPressed: () async {
// // //                             if (selectedReport == null) {
// // //                               showErrorMessage(
// // //                                   context, "Please select reason!");
// // //                             } else {
// // //                               var response = await controller.onReport(
// // //                                 TwitterReportParams(
// // //                                   userId: widget.id,
// // //                                   category: selectedReport!.name,
// // //                                   content: reportTextController.text,
// // //                                   categoryId: '66a3583454e6e337915514db',
// // //                                   reason: selectedReport!.name,
// // //                                 ),
// // //                               );
// // //
// // //                               if (response == true) {
// // //                                 showSuccessMessage(
// // //                                   context,
// // //                                   "Report sent successfully",
// // //                                 );
// // //                                 context.pop();
// // //                               } else {
// // //                                 showErrorMessage(
// // //                                   context,
// // //                                   getFailureMessage(
// // //                                     state.failure ?? const UnknownFailure(''),
// // //                                     context,
// // //                                   ),
// // //                                 );
// // //                               }
// // //                             }
// // //                           },
// // //                         ),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             );
// // //           },
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
// // import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// // import 'package:fourtyninehub/core/enums/reports_enum.dart';
// // import 'package:fourtyninehub/core/error/failure.dart';
// // import 'package:fourtyninehub/core/messages/messages.dart';
// // import 'package:fourtyninehub/res/style/app_colors.dart';
// // import 'package:fourtyninehub/res/style/styles.dart';
// // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // import 'package:go_router/go_router.dart';
// //
// // import '../../../tinder/presentation/pages/user_profile.dart';
// // import '../../domain/usecases/twitter_report_usecase.dart';
// // import '../bloc/twitter_bloc.dart';
// //
// // class ReportView extends StatefulWidget {
// //   const ReportView({
// //     super.key,
// //     required this.id,
// //     required this.categoryId,
// //   });
// //
// //   final String id;
// //   final String categoryId;
// //
// //   @override
// //   State<ReportView> createState() => _ReportViewState();
// // }
// //
// // class _ReportViewState extends State<ReportView> {
// //   final reportTextController = TextEditingController();
// //   ReportsEnum? selectedReport;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     List<ReportsEnum> reports = ReportsEnum.values;
// //     final screenWidth = MediaQuery.of(context).size.width;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.transparent,
// //       body: BlocProvider<TwitterCubit>(
// //         create: (_) => serviceLocator<TwitterCubit>(),
// //         child: BlocBuilder<TwitterCubit, TwitterState>(
// //           builder: (context, state) {
// //             final controller = context.read<TwitterCubit>();
// //             return Padding(
// //               padding: EdgeInsets.symmetric(
// //                 horizontal: screenWidth * 0.05,
// //               ),
// //               child: Column(
// //                 children: [
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Label(
// //                         text: "Report",
// //                         style: Styles.headerText(
// //                           fontSize: screenWidth * 0.07,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black,
// //                         ),
// //                       ),
// //                       const SizedBox(
// //                         width: 10,
// //                       ),
// //                       const Icon(
// //                         Icons.report_gmailerrorred_rounded,
// //                         color: AppColors.SECONDARY_COLOR,
// //                         size: 30,
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(
// //                     height: 10,
// //                   ),
// //                   if (reports.isEmpty)
// //                     const Expanded(
// //                       child: Center(
// //                         child: Text(
// //                           'No report categories available',
// //                           style: TextStyle(color: Colors.grey),
// //                         ),
// //                       ),
// //                     )
// //                   else
// //                     Expanded(
// //                       child: ListView.separated(
// //                         shrinkWrap: true,
// //                         itemCount: reports.length,
// //                         separatorBuilder: (context, i) => const SizedBox(
// //                           height: 10,
// //                         ),
// //                         itemBuilder: (context, i) {
// //                           return Row(
// //                             children: [
// //                               Expanded(
// //                                 child: Label(
// //                                   text: capitalizeAndSplit(reports[i].name),
// //                                   style: Styles.headerText(
// //                                     fontSize: screenWidth * 0.05,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: AppColors.DARK_GRAY_COLOR,
// //                                   ),
// //                                   maxLines: 3,
// //                                 ),
// //                               ),
// //                               Radio<ReportsEnum>(
// //                                 value: reports[i],
// //                                 groupValue: selectedReport,
// //                                 onChanged: (ReportsEnum? value) {
// //                                   setState(() {
// //                                     selectedReport = value;
// //                                   });
// //                                 },
// //                                 activeColor: AppColors.SECONDARY_COLOR,
// //                               ),
// //                             ],
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Expanded(
// //                         child: TextField(
// //                           style: Styles.headerText(
// //                             fontSize: screenWidth * 0.04,
// //                             fontWeight: FontWeight.bold,
// //                             color: AppColors.DARK_BLUE_COLOR,
// //                           ),
// //                           onChanged: (value) {
// //                             setState(() {});
// //                           },
// //                           controller: reportTextController,
// //                           decoration: InputDecoration(
// //                             fillColor: AppColors.UNSELECTED_GRAY_COLOR,
// //                             contentPadding: EdgeInsets.symmetric(
// //                               vertical: MediaQuery.of(context).size.height * 0.02,
// //                               horizontal: 16.0,
// //                             ),
// //                             hintText: 'Type report reason...',
// //                             hintStyle: TextStyle(
// //                               fontSize: MediaQuery.of(context).size.width * 0.04,
// //                               color: AppColors.BARRIER_COLOR,
// //                             ),
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(8.0),
// //                               borderSide: const BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
// //                             ),
// //                             focusedBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(8.0),
// //                               borderSide: const BorderSide(color: AppColors.PRIMARY_COLOR),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(
// //                         width: 8,
// //                       ),
// //                       if (reportTextController.text.isNotEmpty)
// //                         IconAppButton(
// //                           height: screenWidth * 0.1,
// //                           width: screenWidth * 0.1,
// //                           icon: Icons.send,
// //                           isCircle: true,
// //                           onPressed: () async {
// //                             if (selectedReport == null) {
// //                               showErrorMessage(context, "Please select reason!");
// //                             } else {
// //                               var response = await controller.onReport(
// //                                 TwitterReportParams(
// //                                   userId: widget.id,
// //                                   category: selectedReport!.name,
// //                                   content: reportTextController.text,
// //                                   categoryId: widget.categoryId,
// //                                   reason: selectedReport!.name,
// //                                 ),
// //                               );
// //
// //                               if (response == true) {
// //                                 showSuccessMessage(context, "Report sent successfully");
// //                                 context.pop();
// //                               } else {
// //                                 showErrorMessage(
// //                                   context,
// //                                   getFailureMessage(state.failure ?? const UnknownFailure(''), context),
// //                                 );
// //                               }
// //                             }
// //                           },
// //                         ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/enums/reports_enum.dart';
// import 'package:fourtyninehub/core/error/failure.dart';
// import 'package:fourtyninehub/core/messages/messages.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../tinder/presentation/pages/user_profile.dart';
// import '../../domain/usecases/twitter_report_usecase.dart';
// import '../bloc/twitter_bloc.dart';
//
// class ReportView extends StatefulWidget {
//   const ReportView({
//     super.key,
//     required this.id,
//     required this.categoryId,
//   });
//
//   final String id;
//   final String categoryId;
//
//   @override
//   State<ReportView> createState() => _ReportViewState();
// }
//
// class _ReportViewState extends State<ReportView> {
//   final reportTextController = TextEditingController();
//   ReportsEnum? selectedReport;
//
//   @override
//   Widget build(BuildContext context) {
//     List<ReportsEnum> reports = ReportsEnum.values;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return BlocProvider<TwitterCubit>(
//       create: (_) => serviceLocator<TwitterCubit>(),
//       child: BlocBuilder<TwitterCubit, TwitterState>(
//         builder: (context, state) {
//           final controller = context.read<TwitterCubit>();
//
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const SizedBox(height: 12),
//                   _buildHandleIndicator(),
//                   const SizedBox(height: 12),
//                   _buildHeader(context, screenWidth),
//                   const SizedBox(height: 10),
//                   if (reports.isEmpty)
//                     const Center(
//                       child: Text(
//                         'No report categories available',
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     )
//                   else
//                     ListView.separated(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: reports.length,
//                       separatorBuilder: (context, i) =>
//                           const SizedBox(height: 10),
//                       itemBuilder: (context, i) {
//                         return _buildReportOption(
//                             context, reports[i], screenWidth);
//                       },
//                     ),
//                   const SizedBox(height: 20),
//                   _buildTextFieldWithSendButton(
//                       context, screenWidth, controller, state),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildHandleIndicator() {
//     return Container(
//       width: 40,
//       height: 5,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context, double screenWidth) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Label(
//           text: "Report",
//           style: Styles.headerText(
//             fontSize: screenWidth * 0.07,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(width: 10),
//         const Icon(
//           Icons.report_gmailerrorred_rounded,
//           color: AppColors.SECONDARY_COLOR,
//           size: 30,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildReportOption(
//       BuildContext context, ReportsEnum report, double screenWidth) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedReport = report;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         decoration: BoxDecoration(
//           color: selectedReport == report
//               ? AppColors.SECONDARY_COLOR.withOpacity(0.1)
//               : Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selectedReport == report
//                 ? AppColors.SECONDARY_COLOR
//                 : Colors.grey[300]!,
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Label(
//                 text: capitalizeAndSplit(report.name),
//                 style: Styles.headerText(
//                   fontSize: screenWidth * 0.05,
//                   fontWeight: FontWeight.bold,
//                   color: selectedReport == report
//                       ? AppColors.SECONDARY_COLOR
//                       : AppColors.DARK_GRAY_COLOR,
//                 ),
//                 maxLines: 3,
//               ),
//             ),
//             Radio<ReportsEnum>(
//               value: report,
//               groupValue: selectedReport,
//               onChanged: (ReportsEnum? value) {
//                 setState(() {
//                   selectedReport = value;
//                 });
//               },
//               activeColor: AppColors.SECONDARY_COLOR,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextFieldWithSendButton(BuildContext context, double screenWidth,
//       TwitterCubit controller, TwitterState state) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             style: Styles.headerText(
//               fontSize: screenWidth * 0.04,
//               fontWeight: FontWeight.bold,
//               color: AppColors.DARK_BLUE_COLOR,
//             ),
//             onChanged: (value) {
//               setState(() {});
//             },
//             controller: reportTextController,
//             decoration: InputDecoration(
//               fillColor: AppColors.UNSELECTED_GRAY_COLOR,
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: MediaQuery.of(context).size.height * 0.02,
//                 horizontal: 16.0,
//               ),
//               hintText: 'Type report reason...',
//               hintStyle: TextStyle(
//                 fontSize: screenWidth * 0.04,
//                 color: AppColors.BARRIER_COLOR,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: const BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//                 borderSide: const BorderSide(color: AppColors.PRIMARY_COLOR),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         AnimatedOpacity(
//           opacity: reportTextController.text.isNotEmpty ? 1.0 : 0.5,
//           duration: const Duration(milliseconds: 300),
//           child: IconAppButton(
//             height: screenWidth * 0.1,
//             width: screenWidth * 0.1,
//             icon: Icons.send,
//             isCircle: true,
//             onPressed: reportTextController.text.isNotEmpty
//                 ? () async {
//                     if (selectedReport == null) {
//                       showErrorMessage(context, "Please select a reason!");
//                     } else {
//                       var response = await controller.onReport(
//                         TwitterReportParams(
//                           userId: widget.id,
//                           category: selectedReport!.name,
//                           content: reportTextController.text,
//                           categoryId: widget.categoryId,
//                           reason: selectedReport!.name,
//                         ),
//                       );
//
//                       if (response == true) {
//                         showSuccessMessage(context, "Report sent successfully");
//                         context.pop();
//                       } else {
//                         showErrorMessage(
//                           context,
//                           getFailureMessage(
//                               state.failure ?? const UnknownFailure(''), context),
//                         );
//                       }
//                     }
//                   }
//                 : () => null,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/reports_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../tinder/presentation/pages/user_profile.dart';
import '../../domain/usecases/twitter_report_usecase.dart';
import '../bloc/twitter_bloc.dart';

class ReportView extends StatefulWidget {
  const ReportView({
    super.key,
    required this.id,
    required this.categoryId,
  });

  final String id;
  final String categoryId;

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final reportTextController = TextEditingController();
  ReportsEnum? selectedReport;

  @override
  Widget build(BuildContext context) {
    List<ReportsEnum> reports = ReportsEnum.values;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider<TwitterCubit>(
      create: (_) => serviceLocator<TwitterCubit>(),
      child: BlocBuilder<TwitterCubit, TwitterState>(
        builder: (context, state) {
          final controller = context.read<TwitterCubit>();
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;

          return Container(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    _buildHandleIndicator(),
                    const SizedBox(height: 12),
                    _buildHeader(context, screenWidth),
                    const SizedBox(height: 10),
                    if (reports.isEmpty)
                      const Center(
                        child: Text(
                          'No report categories available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reports.length,
                        separatorBuilder: (context, i) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          return _buildReportOption(
                              context, reports[i], screenWidth);
                        },
                      ),
                    const SizedBox(height: 20),
                    _buildTextFieldWithSendButton(
                        context, screenWidth, controller, state),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandleIndicator() {
    return Container(
      width: 40,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Label(
          text: "Report",
          style: Styles.headerText(
            fontSize: screenWidth * 0.1,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        const Icon(
          Icons.report_gmailerrorred_rounded,
          color: AppColors.SECONDARY_COLOR,
          size: 30,
        ),
      ],
    );
  }

  Widget _buildReportOption(
      BuildContext context, ReportsEnum report, double screenWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedReport = report;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: selectedReport == report
              ? AppColors.SECONDARY_COLOR.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedReport == report
                ? AppColors.SECONDARY_COLOR
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Label(
                text: capitalizeAndSplit(report.name),
                style: Styles.headerText(
                  fontSize: screenWidth * 0.09,
                  fontWeight: FontWeight.bold,
                  color: selectedReport == report
                      ? AppColors.SECONDARY_COLOR
                      : AppColors.DARK_GRAY_COLOR,
                ),
                maxLines: 3,
              ),
            ),
            Radio<ReportsEnum>(
              value: report,
              groupValue: selectedReport,
              onChanged: (ReportsEnum? value) {
                setState(() {
                  selectedReport = value;
                });
              },
              activeColor: AppColors.SECONDARY_COLOR,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithSendButton(BuildContext context, double screenWidth,
      TwitterCubit controller, TwitterState state) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: Styles.headerText(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR_LIGHT,
            ),
            onChanged: (value) {
              setState(() {});
            },
            controller: reportTextController,
            decoration: InputDecoration(
              fillColor: AppColors.LIGHT_COLOR,
              contentPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: 16.0,
              ),
              hintText: 'Type report reason...',
              hintStyle: TextStyle(
                fontSize: screenWidth * 0.04,
                color: AppColors.DARK_GRAY_COLOR,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.PRIMARY_COLOR),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        AnimatedOpacity(
          opacity: reportTextController.text.isNotEmpty ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 300),
          child: IconAppButton(
            height: screenWidth * 0.1,
            width: screenWidth * 0.1,
            icon: Icons.send,
            isCircle: true,
            onPressed: reportTextController.text.isNotEmpty
                ? () async {
                    if (selectedReport == null) {
                      showErrorMessage(context, "Please select a reason!");
                      context.pop();
                    } else {
                      var response = await controller.onReport(
                        TwitterReportParams(
                          userId: widget.id,
                          category: selectedReport!.name,
                          content: reportTextController.text,
                          categoryId: widget.categoryId,
                          reason: selectedReport!.name,
                        ),
                      );

                      if (response == true) {
                        showSuccessMessage(context, "Report sent successfully");
                        context.pop();
                      } else {
                        showErrorMessage(
                          context,
                          getFailureMessage(
                              state.failure ?? const UnknownFailure(''),
                              context),
                        );
                        context.pop();
                      }
                    }
                  }
                : () => null,
          ),
        ),
      ],
    );
  }
}
