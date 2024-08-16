// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/enums/reports_enum.dart';
// import 'package:fourtyninehub/core/error/failure.dart';
// import 'package:fourtyninehub/core/messages/messages.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
// import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
// import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:go_router/go_router.dart';
//
// class ReportView extends StatefulWidget {
//   const ReportView({
//     super.key,
//     required this.id,
//     required String categoryId,
//   });
//
//   final String id;
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
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: BlocProvider<TwitterCubit>(
//         create: (_) => serviceLocator(),
//         child: BlocBuilder<TwitterCubit, TwitterState>(
//           builder: (context, state) {
//             final controller = context.read<TwitterCubit>();
//             return Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Label(
//                       text: "Report",
//                       style: Styles.headerText(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     const Icon(
//                       Icons.report_gmailerrorred_rounded,
//                       color: AppColors.SECONDARY_COLOR,
//                       size: 30,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Expanded(
//                   child: ListView.separated(
//                     shrinkWrap: true,
//                     itemCount: reports.length,
//                     separatorBuilder: (context, i) => const SizedBox(
//                       height: 10,
//                     ),
//                     itemBuilder: (context, i) {
//                       return Row(
//                         children: [
//                           Expanded(
//                             child: Label(
//                               text: TinderSharedUtils.capitalizeEachWord(
//                                   reports[i].name),
//                               style: Styles.headerText(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.DARK_GRAY_COLOR,
//                               ),
//                               maxLines: 3,
//                             ),
//                           ),
//                           Checkbox(
//                             value: selectedReport == reports[i],
//                             onChanged: (v) {
//                               setState(() {
//                                 selectedReport = v! ? reports[i] : null;
//                               });
//                             },
//                             activeColor: AppColors.SECONDARY_COLOR,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: FormTextField(
//                         hint: 'Type report reason ....',
//                         height: kToolbarHeight * .7,
//                         action: (v) {
//                           setState(() {});
//                         },
//                         controller: reportTextController,
//                       ),
//                     ),
//                     if (reportTextController.text.isNotEmpty)
//                       IconAppButton(
//                         icon: Icons.send,
//                         isCircle: true,
//                         onPressed: () async {
//                           if (selectedReport == null) {
//                             showErrorMessage(context, "Please select reason!");
//                           } else {
//                             var response = await controller.onReport(
//                               TwitterReportParams(
//                                 userId: widget.id,
//                                 category: selectedReport!.name,
//                                 content: reportTextController.text,
//                                 categoryId: '66a3583454e6e337915514db',
//                                 reason: selectedReport!.name,
//                               ),
//                             );
//
//                             if (response == true) {
//                               showSuccessMessage(
//                                 context,
//                                 "Report send successfully",
//                               );
//                               context.pop();
//                             } else {
//                               showErrorMessage(
//                                 context,
//                                 getFailureMessage(
//                                   state.failure ?? const UnknownFailure(),
//                                   context,
//                                 ),
//                               );
//                             }
//                           }
//                         },
//                       ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/reports_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class ReportView extends StatefulWidget {
  const ReportView({
    super.key,
    required this.id,
    required String categoryId,
  });

  final String id;

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocProvider<TwitterCubit>(
        create: (_) => serviceLocator(),
        child: BlocBuilder<TwitterCubit, TwitterState>(
          builder: (context, state) {
            final controller = context.read<TwitterCubit>();
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Label(
                        text: "Report",
                        style: Styles.headerText(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.report_gmailerrorred_rounded,
                        color: AppColors.SECONDARY_COLOR,
                        size: 30,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: reports.length,
                      separatorBuilder: (context, i) => const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, i) {
                        return Row(
                          children: [
                            Expanded(
                              child: Label(
                                text: TinderSharedUtils.capitalizeEachWord(
                                    reports[i].name),
                                style: Styles.headerText(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.DARK_GRAY_COLOR,
                                ),
                                maxLines: 3,
                              ),
                            ),
                            Radio<ReportsEnum>(
                              value: reports[i],
                              groupValue: selectedReport,
                              onChanged: (ReportsEnum? value) {
                                setState(() {
                                  selectedReport = value;
                                });
                              },
                              activeColor: AppColors.SECONDARY_COLOR,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          style: Styles.headerText(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: AppColors.DARK_BLUE_COLOR,
                          ),
                          // hint: 'Type report reason...',
                          // height: MediaQuery.of(context).size.height * 0.07,
                          // action: (v) {
                          //   setState(() {});
                          // },
                          onChanged: (value) {
                            setState(() {});
                          },
                          controller: reportTextController,

                          decoration: InputDecoration(
                            fillColor: AppColors.DARK_GRAY_COLOR,

                            contentPadding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                              horizontal: 16.0,
                            ),
                            hintText: 'Type report reason...',
                            hintStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: AppColors.BARRIER_COLOR,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.LIGHT_GRAY_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: AppColors.PRIMARY_COLOR),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (reportTextController.text.isNotEmpty)
                        IconAppButton(
                          height: screenWidth * 0.1,
                          width: screenWidth * 0.1,
                          icon: Icons.send,
                          isCircle: true,
                          onPressed: () async {
                            if (selectedReport == null) {
                              showErrorMessage(
                                  context, "Please select reason!");
                            } else {
                              var response = await controller.onReport(
                                TwitterReportParams(
                                  userId: widget.id,
                                  category: selectedReport!.name,
                                  content: reportTextController.text,
                                  categoryId: '66a3583454e6e337915514db',
                                  reason: selectedReport!.name,
                                ),
                              );

                              if (response == true) {
                                showSuccessMessage(
                                  context,
                                  "Report sent successfully",
                                );
                                context.pop();
                              } else {
                                showErrorMessage(
                                  context,
                                  getFailureMessage(
                                    state.failure ?? const UnknownFailure(),
                                    context,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
