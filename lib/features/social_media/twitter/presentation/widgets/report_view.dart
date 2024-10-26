import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/reports_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../tinder/presentation/pages/user_profile.dart';
import '../../domain/usecases/twitter_report_usecase.dart';
import '../bloc/twitter_bloc.dart';

class ReportView extends StatefulWidget {
  const ReportView({
    super.key,
    required this.id,
    this.loadingTripId,
    required this.categoryId,
  });

  final String id;
  final String categoryId;
  final String? loadingTripId;

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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocProvider<TwitterCubit>(
        create: (_) => serviceLocator<TwitterCubit>(),
        child: BlocBuilder<TwitterCubit, TwitterState>(
          builder: (context, state) {
            final controller = context.read<TwitterCubit>();
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 12.h),
                    _buildHandleIndicator(),
                    SizedBox(height: 12.h),
                    _buildHeader(context, screenWidth),
                    const SizedBox(height: 16),
                    if (reports.isEmpty)
                      Center(
                        child: Text(
                          LocaleKeys.noReportCategoriesAvailable.localize,
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 40.sp),
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
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: _buildReportOption(
                                context, reports[i], screenWidth),
                          );
                        },
                      ),
                    SizedBox(height: 20.h),
                    _buildTextFieldWithSendButton(
                        context, screenWidth, controller, state),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          },
        ),
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
        Text(
          LocaleKeys.report.localize,
          textScaleFactor: 1.0,
          style: TextStyle(
            fontSize: 55.sp,
            fontWeight: FontWeight.bold,
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
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10),
        decoration: BoxDecoration(
          color: selectedReport == report
              ? AppColors.SECONDARY_COLOR.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedReport == report
                ? AppColors.SECONDARY_COLOR
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                capitalizeAndSplit(report.displayTitleAr),
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: selectedReport == report
                      ? AppColors.SECONDARY_COLOR
                      : (isDarkTheme(context)
                          ? Colors.white70
                          : AppColors.DARK_GRAY_COLOR),
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
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            // Disable scaling

            child: Container(
              constraints: BoxConstraints(
                maxHeight: 150.h
              ),
              child: TextField(
                maxLines: null,
                style: TextStyle(
                  fontSize: 35.sp,
                  fontWeight: FontWeight.bold,
                  color: isDarkTheme(context)
                      ? Colors.white70
                      : AppColors.PRIMARY_COLOR_LIGHT,
                ),
                onChanged: (value) {
                  setState(() {});
                },
                controller: reportTextController,
                decoration: InputDecoration(
                  fillColor: isDarkTheme(context)
                      ? Colors.transparent
                      : AppColors.LIGHT_COLOR,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02,
                    horizontal: 16.0,
                  ),
                  hintText: '${LocaleKeys.typeReportReason.localize}...',
                  hintStyle: TextStyle(
                    fontSize: 35.sp,
                    color: isDarkTheme(context)
                        ? Colors.white70
                        : AppColors.DARK_GRAY_COLOR,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        const BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                    const BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                  ),
                  errorBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide:
                  const BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        const BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        AnimatedOpacity(
          opacity: reportTextController.text.isNotEmpty ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 300),
          child: IconButton(
            color: AppColors.PRIMARY_COLOR_DARK,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: reportTextController.text.isNotEmpty
                ? () async {
                    if (selectedReport == null) {
                      showErrorMessage(
                          context, LocaleKeys.pleaseSelectReason.localize);
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
                        showSuccessMessage(context,
                            LocaleKeys.reportSentSuccessfully.localize);
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
                : () {},
          ),
        ),
      ],
    );
  }
}
