import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/pages/empty.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import '../../domain/entity/get_all_count_ads_entity.dart';
import '../../domain/entity/my_ads_auction.dart';
import '../../domain/usecases/get_all_counts_ads_usecase.dart';

class CustomButtonCountAds extends StatelessWidget {
  const CustomButtonCountAds(
      {super.key, required this.model, required this.status});

  final MyAuctionAdsEntity model;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Request Ads',
      ),
      body: BlocProvider<MyAddsCubit>(
        create: (BuildContext context) => serviceLocator()
          ..getAllCountAds(
              params: CountAdsParams(id: model.id, status: status)),
        child: BlocBuilder<MyAddsCubit, MyAddsState>(
          builder: (BuildContext context, state) {
            if (state.status == MyAddsStates.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == MyAddsStates.initState) {
              if (state.countAds == null || state.countAds!.isEmpty) {
                return const EmptyPage();
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: ListView.separated(
                  itemBuilder: (context, index) =>
                      buildItem(context, state.countAds![index]),
                  separatorBuilder: (context, index) => const Sizer(),
                  itemCount: state.countAds?.length ?? 0,
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget buildItem(context, GetAllCountAdsEntity count) => Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: kToolbarHeight * 2.5.h,
                  width: kToolbarHeight * 2.5.w,
                  child: ImageFromInternet(
                    isCircle: true,
                    image: count.gender == 'male'
                        ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwC-ZR1TdJ7VIAMeqhjm-u29-HB0PyAuSFFQ&s'
                        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKc-oaCL6lH4WNLuY-A6H7UyEJmZQ5HdN6Os89NNXXANez6DAEM9SJdKu-Drj6L2LSfpM&usqp=CAU',
                  ),
                ),
                const Sizer(),
                Label(
                  text: count.firstName,
                  style: Styles.headerText(),
                ),
              ],
            ),
            Sizer(
              height: 10.h,
            ),
            // CallMessageButtons(
            //   otherUserId: otherUserId,
            //   subcategoryId: subcategoryId,
            //   phone: phone,
            //   id: id,
            // ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AvaialbleTripsButton(
                    title: LocaleKeys.call.localize,
                    icon: Icons.phone,
                    color: AppColors.PRIMARY_COLOR,
                    onTap: () {
                      launchUrlString("tel://01023765247");
                    },
                  ),
                ),
                Sizer(width: 10.w),
                Expanded(
                  flex: 3,
                  child: AvaialbleTripsButton(
                    title: LocaleKeys.message.localize,
                    icon: Icons.mail,
                    color: AppColors.PRIMARY_COLOR,
                    onTap: () {},
                  ),
                ),
                Sizer(width: 10.w),
                Expanded(
                  flex: 3,
                  child: AvaialbleTripsButton(
                    title: LocaleKeys.report.localize,
                    icon: Icons.report,
                    color: AppColors.SECONDARY_COLOR,
                    onTap: () {
                      bottomSheet(
                          context: context,
                          widget: ReportView(
                            id: count.id,
                            categoryId: model.id,
                          ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
