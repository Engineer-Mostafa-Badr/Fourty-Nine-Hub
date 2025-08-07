import 'package:easy_localization/easy_localization.dart' as easyLocale;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import '../../../add_new_trip_join/presentation/views/widgets/card.dart';
import '../../../fetch_my_pick_me_trips/data/models/fetch_my_pick_me_model.dart';
import '../../../view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../../helpers/manage_vibration.dart';

class MyAllPickMeCard extends StatelessWidget {
  const MyAllPickMeCard({
    super.key,
    required this.fetchMyPickMeModel,
    required this.requestHistoryOnTap,
    required this.subscribeOnTap,
    required this.deleteRequestOnTap,
  });

  final TripData fetchMyPickMeModel;
  final void Function()? requestHistoryOnTap;
  final void Function()? subscribeOnTap;
  final void Function()? deleteRequestOnTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomCard(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 150.w,
                        height: 150.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[300]!,
                                offset: const Offset(3, 3)),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          serviceLocator<UserCubit>().state.data != null
                              ? serviceLocator<UserCubit>()
                                  .state
                                  .data!
                                  .profilePicture!
                              : UIConst.profilePlaceHolder,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Sizer(width: 30.w),
                      Text(fetchMyPickMeModel.firstName,
                          style: Styles.headerText()),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_month),
                      const Sizer(),
                      Text(_formatDate(context), style: Styles.headerText()),
                    ],
                  ),
                  const Sizer(),
                  Visibility(
                    visible: fetchMyPickMeModel.isRepeat,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          fetchMyPickMeModel.isRepeat
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                        Text(LocaleKeys.repeat.localize,
                            style: Styles.headerText()),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: fetchMyPickMeModel.isRepeat,
                    child: const Sizer(),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.trip_origin,
                          color: AppColors.LIGHT_BLUE, size: 20),
                      const Sizer(width: 13),
                      Flexible(
                        child: Text(
                          context.isArabic
                              ? fetchMyPickMeModel.fromAr
                              : fetchMyPickMeModel.fromEn,
                          style: Styles.headerText(fontSize: 32),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.trip_origin,
                          color: AppColors.CHECK_MARK_COLOR, size: 20),
                      const Sizer(width: 13),
                      Flexible(
                        child: Text(
                          context.isArabic
                              ? fetchMyPickMeModel.toAr
                              : fetchMyPickMeModel.toEn,
                          style: Styles.headerText(fontSize: 32),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Sizer(),
                  // Action Buttons placed inside card
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AvaialbleTripsButton(
                          title: LocaleKeys.requestsHistory.localize,
                          color: AppColors.PRIMARY_COLOR,
                          onTap: requestHistoryOnTap,
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 1,
                        child: AvaialbleTripsButton(
                          title: LocaleKeys.deleteRequest.localize,
                          color: AppColors.getSecondryColor(context),
                          onTap: () async {
      ManageVibration.vibrate();
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets.only(
                                    top: 30.h,
                                    right: 15.w,
                                    left: 15.w,
                                    bottom: 20.h,
                                  ),
                                  child: AreYouSure(
                                    title: LocaleKeys.alert.localize,
                                    subTitle: LocaleKeys.clearNoti.localize,
                                    action: () {
                                      deleteRequestOnTap!();
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Sizer(),

                  AvaialbleTripsButton(
                    title: LocaleKeys.subscribe.localize,
                    color: AppColors.PRIMARY_COLOR,
                    onTap: subscribeOnTap,
                  ),
                ],
              ),
              Positioned.directional(
                top: 5,
                end: 20,
                textDirection:
                    context.isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(fetchMyPickMeModel.price.toStringAsFixed(0),
                            style: Styles.headerText(
                                fontSize: 70, color: Colors.green[600])),
                        Text(
                          context.isArabic
                              ? BlocProvider.of<GetCurrencyCubit>(context)
                                  .currnecyAr
                              : BlocProvider.of<GetCurrencyCubit>(context)
                                  .currnecyEn,
                          style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.SECONDARY_COLOR),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context) {
    DateTime dateTime = DateTime.parse(fetchMyPickMeModel.createdAt);
    return intl.DateFormat('dd MMM, hh:mm aaa', context.locale.languageCode)
        .format(dateTime);
  }

  String _localizeStatus(BuildContext context, String text) {
    switch (text) {
      case 'regular':
        return context.isArabic ? 'عادي' : 'Regular';
      case 'premium':
        return context.isArabic ? 'مميز' : 'Premium';
      case 'Not subscribed':
        return context.isArabic ? 'غير مشترك' : 'Not subscribed';
      default:
        return text;
    }
  }
}