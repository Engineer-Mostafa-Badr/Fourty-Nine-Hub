// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/enums/reports_enum.dart';
// import 'package:fourtyninehub/core/error/failure.dart';
// import 'package:fourtyninehub/core/messages/messages.dart';
// import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
// import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
//
// class PostOptions extends StatefulWidget {
//   const PostOptions({super.key, required this.id, required this.onReport});
//   final String id;
//   final Function(TwitterReportParams) onReport;
//
//   @override
//   State<PostOptions> createState() => _PostOptionsState();
// }
//
// class _PostOptionsState extends State<PostOptions> {
//   final reportTextController = TextEditingController();
//   ReportsEnum? selectedReport;
//
//   @override
//   Widget build(BuildContext context) {
//     List<ReportsEnum> reports = ReportsEnum.values;
//     return Scaffold(
//       body: BlocProvider<TwitterCubit>(
//         create: (_)=>serviceLocator(),
//         child: BlocBuilder<TwitterCubit,TwitterState>(
//           builder: (context,state) {
//             final controller = context.read<TwitterCubit>();
//             return Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Label(
//                       text: "Report",
//                       style: Styles.headerText(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     const Icon(
//                       Icons.report_gmailerrorred_rounded,
//                       color: AppColors.SECONDARY_COLOR,
//                       size: 30,
//                     )
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: reports.length,
//                     itemBuilder: (context, i) {
//                       return Row(
//                         children: [
//                           Label(
//                             text: reports[i].displayTitle,
//                             style: Styles.headerText(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.DARK_GRAY_COLOR),
//                           ),
//                           const Spacer(),
//                           Checkbox(
//                             value: selectedReport == reports[i],
//                             onChanged: (v) {
//                               setState(() {
//                                 selectedReport = v! ? reports[i] : null;
//                               });
//                             },
//                             activeColor: AppColors.SECONDARY_COLOR,
//                           )
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
//                     if(reportTextController.text.isNotEmpty)IconAppButton(
//                         icon: Icons.send,
//                         isCircle: true,
//                         onPressed: () async{
//                           if(selectedReport==null){
//                             showErrorMessage(context, "message");
//                           }else{
//                             var response =await controller.onReport(
//                                 TwitterReportParams(
//                                   userId: widget.id,
//                                   category: selectedReport!.name,
//                                   content: reportTextController.text,
//                                   categoryId: '66a3583454e6e337915514db',
//                                   reason: selectedReport!.name,
//                                 )
//                             );
//
//                             if(response == true){
//                               showErrorMessage(context, "Report send successfully");
//                             }else{
//                               showErrorMessage(
//                                 context,
//                                 getFailureMessage(
//                                   state.failure ?? const UnknownFailure(),
//                                   context,
//                                 ),
//                               );
//                             }
//
//                           }
//                         })
//                   ],
//                 ),
//               ],
//             );
//           }
//         ),
//       ),
//     );
//   }
// }
