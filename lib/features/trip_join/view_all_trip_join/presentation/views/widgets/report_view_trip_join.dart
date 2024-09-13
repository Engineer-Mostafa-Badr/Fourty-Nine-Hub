import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/reports_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ReportViewTripJoin extends StatefulWidget {
  const ReportViewTripJoin({
    super.key,
    required this.id,
    required this.categoryId,
    required this.cardId,
  });

  final String id;
  final String categoryId;
  final String cardId;
  @override
  State<ReportViewTripJoin> createState() => _ReportViewTripJoinState();
}

class _ReportViewTripJoinState extends State<ReportViewTripJoin> {
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
                    SizedBox(height: 12.h),
                    _buildHandleIndicator(),
                    SizedBox(height: 12.h),
                    _buildHeader(context, screenWidth),
                    SizedBox(height: 10.h),
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
                            SizedBox(height: 10.h),
                        itemBuilder: (context, i) {
                          return _buildReportOption(
                              context, reports[i], screenWidth);
                        },
                      ),
                    SizedBox(height: 20.h),
                    _buildTextFieldWithSendButton(
                        context, screenWidth, controller, state),
                    SizedBox(height: 20.h),
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
      height: 5.h,
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
        SizedBox(width: 10),
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
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10),
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
        SizedBox(width: 8),
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
                      print(' ============= ${TwitterReportParams(
                        userId: widget.id,
                        category: selectedReport!.name,
                        content: reportTextController.text,
                        categoryId: widget.categoryId,
                        reason: selectedReport!.name,
                        comeWithYouTrip: widget.cardId,
                      )}');
                      // return;
                      var response = await controller.onReport(
                        TwitterReportParams(
                          userId: widget.id,
                          category: selectedReport!.name,
                          content: reportTextController.text,
                          categoryId: widget.categoryId,
                          reason: selectedReport!.name,
                          comeWithYouTrip: widget.cardId,
                        ),
                      );

                      if (response == true) {
                        showSuccessMessage(context, "Report sent successfully");
                        context.pop();
                      } else {
                        showErrorMessage(
                          context,
                          getFailureMessage(
                              state.failure ?? UnknownFailure(''), context),
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
