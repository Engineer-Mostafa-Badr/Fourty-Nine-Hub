import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_arrived_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';

class BuildDriverCompleteTripSheet extends StatefulWidget {
  const BuildDriverCompleteTripSheet(
      {super.key, required this.onPressed, required this.onStartRecord, required this.onStopRecord, required this.onCompleteRide, required this.tripId});
  final Function(String) onPressed;
  final Function onStartRecord;
  final Function onStopRecord;
  final Function onCompleteRide;
  final String tripId;

  @override
  State<BuildDriverCompleteTripSheet> createState() => _BuildDriverCompleteTripSheetState();
}

class _BuildDriverCompleteTripSheetState extends State<BuildDriverCompleteTripSheet> {
  bool _isRecording = false;
  bool _isComplete = false;
  bool _isOtherReason = false;
  bool _isChangedMindReason = false;
  bool _isClientNotShownReason = false;

  TextEditingController otherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.76,
      minChildSize: 0.2,
      maxChildSize: 0.76,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Baseline(
                          baseline: 10.h,
                          baselineType: TextBaseline.alphabetic,
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              context.isArabic ? "تقرير العميل" : "Report Client",
                              style: const TextStyle(
                                fontSize: FontSize.s16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.PRIMARY_COLOR_DARK,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      _buildActionCircle(
                        icon: Icons.security,
                        label: LocaleKeys.safety.localize,
                        onTap: () {
                          context.push(Routes.ratingClientScreen);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // PaymentInfoWidget(price: price),
                  //
                  LocationInfoWidget(
                    hasTitle: !_isComplete,
                    from: 'أول العاشر من رمضان',
                    to: 'المنطقة الصناعية الثالثة العاشر من رمضان (10th of Ramadan City 1) العالمية',
                  ),
                  const SizedBox(height: 10),
                  if (!_isComplete) ...[
                    Container(
                      width: double.infinity,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.PRIMARY_COLOR, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.PRIMARY_COLOR)),
                      child: Text(
                        context.isArabic ? "افتح خرائط جوجل" : "Open Google Map",
                        style: const TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "Travel time: ~14 min. Distance: 6.58 Km.",
                            style: TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClickableWidget(
                      onTap: () {
                        if (_isRecording) {
                          setState(() {
                            _isRecording = false;
                            widget.onStopRecord();
                          });
                        } else {
                          setState(() {
                            _isRecording = true;
                            widget.onStartRecord();
                          });
                        }
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(color: _isRecording ? Colors.grey[100] : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(20.w),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.rideRecord,
                              color: _isRecording ? null : Colors.black,
                            ),
                            SizedBox(width: 30.w),
                            if (!_isRecording) Text('Record', style: TextStyle(fontSize: FontSize.s14, fontWeight: FontWeight.bold)) else Expanded(child: _buildWaveform())
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClickableWidget(
                      onTap: () {
                        setState(() {
                          _isComplete = true;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.PRIMARY_COLOR, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.PRIMARY_COLOR)),
                        child: Text(
                          context.isArabic ? "انهاء الرحلة" : "Complete Ride",
                          style: const TextStyle(
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClickableWidget(
                      onTap: () {
                        showCancelTripDialog(
                            context: context,
                            isChangedMindReason: _isChangedMindReason,
                            onSelectChangedMindReason: () {
                              setState(() {
                                _isClientNotShownReason = false;
                                _isChangedMindReason = !_isChangedMindReason;
                                _isOtherReason = false;
                              });
                            },
                            isClientNotShownReason: _isClientNotShownReason,
                            onSelectClientNotShownReason: () {
                              setState(() {
                                _isClientNotShownReason = !_isClientNotShownReason;
                                _isChangedMindReason = false;
                                _isOtherReason = false;
                              });
                            },
                            isOtherReason: _isOtherReason,
                            onSelectOtherReason: () {
                              setState(() {
                                _isClientNotShownReason = false;
                                _isChangedMindReason = false;
                                _isOtherReason = !_isOtherReason;
                              });
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          LocaleKeys.cancelTheRide.localize,
                          style: const TextStyle(
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.PRIMARY_COLOR_DARK,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (_isComplete) ...[
                    ClickableWidget(
                      onTap: () {
                        widget.onCompleteRide();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.PRIMARY_COLOR, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.PRIMARY_COLOR)),
                        child: Text(
                          context.isArabic ? "نعم" : "Yes",
                          style: const TextStyle(
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ClickableWidget(
                      onTap: () {
                        setState(() {
                          _isComplete = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          context.isArabic ? "لا" : "No",
                          style: const TextStyle(
                            fontSize: FontSize.s16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveform() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(20, (index) {
        final height = (index % 5 + 1) * 4.0;
        return Container(
          width: 3,
          height: height,
          margin: EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  Widget _buildActionCircle({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.buttonDialog,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  showCancelTripDialog({
    required BuildContext context,
    required bool isOtherReason,
    required bool isChangedMindReason,
    required bool isClientNotShownReason,
    required Function onSelectOtherReason,
    required Function onSelectChangedMindReason,
    required Function onSelectClientNotShownReason,
  }) {
    showCustomDialogTrip(
        context,
        BlocProvider.value(
          value: serviceLocator<DashboardsCubit>(),
          child: BlocBuilder<DashboardsCubit, DashboardsState>(builder: (context, state) {
            var cubit = context.read<DashboardsCubit>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.alert.localize,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Why do you want to cancel ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.s16,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    )),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
                    cubit.changeReasonSelection(isClientNotShown: true);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: state.isClientNotShownReason == true ? Border.all(color: AppColors.SECONDARY_COLOR_DARK2) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic ? "لم يظهر العميل" : "The client did not show up",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
                    cubit.changeReasonSelection(isChangedMind: true);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: state.isChangedMindReason == true ? Border.all(color: AppColors.SECONDARY_COLOR_DARK2) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic ? "لقد قمت بتغيير رأيي" : "I changed my mind",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: () {
                    cubit.changeReasonSelection(isOther: true);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(color: state.isOtherReason == true ? Colors.transparent : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(
                          context.isArabic ? "أخري" : "Other",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.isOtherReason == true) ...[
                  const SizedBox(height: 20),
                  DefaultTextFormField(
                    currentController: cubit.reasonController,
                    fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                    borderColor: Colors.transparent,
                    hint: context.isArabic ? 'اكتب السبب هنا' : 'Write the reason here',
                    // label: LocaleKeys.firstName.localize,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return LocaleKeys.required.localize;
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                        width: context.screenWidth / 3.4,
                        label: context.isArabic ? 'الغاء' : 'Close',
                        backColor: AppColors.SECONDARY_COLOR_DARK2,
                        onPressed: () {
                          context.pop();
                          // cubit
                        }),
                    const SizedBox(width: 16),
                    AppButton(
                        width: context.screenWidth / 3.4,
                        label: context.isArabic ? 'تأكيد' : 'Confirm',
                        backColor: AppColors.PRIMARY_COLOR,
                        onPressed: () {
                          context.pop();
                          if (state.isOtherReason == true || state.isChangedMindReason == true || state.isClientNotShownReason == true) {
                            cubit.cancelDriverTrip(
                              context: context,
                              tripId: widget.tripId,
                              note: state.isOtherReason == true
                                  ? cubit.reasonController.text
                                  : state.isClientNotShownReason == true
                                      ? 'client-no-show'
                                      : state.isChangedMindReason == true
                                          ? 'change-my-mind'
                                          : '',
                              reasonId: state.isOtherReason == true
                                  ? '6693d4723aa4a25077cdbc7b'
                                  : state.isClientNotShownReason == true
                                      ? '665eec12ce3725d6bc6f40ca'
                                      : state.isChangedMindReason == true
                                          ? '665ef7118e67e46ce6498fef'
                                          : '',
                            );
                          } else {
                            showErrorMessage(context, context.isArabic ? "يرجى تحديد سبب" : 'Please select a reason');
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ));
  }
}
