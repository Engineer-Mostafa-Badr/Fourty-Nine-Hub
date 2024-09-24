import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/address_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../ride/RideRequest/presentation/widgets/customer/createOrder/changePhoneNumber.dart';

class AdDetailsView extends StatefulWidget {
  final String id;
  const AdDetailsView({super.key, required this.id});

  @override
  State<AdDetailsView> createState() => _AdDetailsViewState();
}

class _AdDetailsViewState extends State<AdDetailsView> {
  @override
  void initState() {
    context.read<AdDetailsCubit>().loadData(adId: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(),
        body: BlocConsumer<AdDetailsCubit, AdDetailsState>(
            listener: (contex, state) {
          if (state.isError) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure!,
                context,
              ),
            );
          } else if (state.isSuccess) {
            showSuccessMessage(context, Labels.success);
          }
        }, builder: (context, state) {
          if (state.ad == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildAdInfoWidget(ad: state.ad!),
                      const Sizer(),
                      // const GoogleAddsBanner(
                      //   margin: 0,
                      // ),
                      const Sizer(),
                      _buildDetailsWidget(ad: state.ad!),
                      // _buildLocationWidget(address: state.ad!.address!),
                      const Sizer(),
                      _buildRelevantAdsWidget(),
                    ],
                  ),
                ),
                _buildActionsWidget(),
              ],
            ),
          );
        }));
  }

  Widget _buildRelevantAdsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
      if (state.relevantAds?.isEmpty ?? true) {
        return const SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: 'Relevant Ads',
            style: Styles.mediumText(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: kToolbarHeight * 3.5,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    AdCard(item: state.relevantAds![index]),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: state.relevantAds?.length ?? 0),
          ),
        ],
      );
    });
  }

  Widget _buildActionsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
      final controller = context.read<AdDetailsCubit>();
      return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            FutureBuilder(
                future: ButtonAvailability().isShowButton(
                    otherUserId: state.ad?.user?.id ?? '',
                    subcategoryId: state.ad?.subCategoryId ?? ''),
                builder: (context, snap) {
                  if (snap.data ?? false) {
                    return Row(
                      children: [
                        Expanded(
                            child: AppButton(
                                label: 'Chat',
                                icon: Icons.chat_bubble_outline,
                                onPressed: () =>
                                    context.push(Routes.CHATROOM))),
                        const Sizer(
                          width: 5,
                        ),
                        Expanded(
                            child: AppButton(
                                label: 'Call',
                                icon: Icons.call,
                                onPressed: () => LaunchURLHelper()
                                    .call(phone: state.ad?.phone ?? ''))),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(
                            child: AppButton(
                                label: 'Chat',
                                icon: Icons.chat_bubble_outline,
                                backColor: AppColors.GREY_DARK_COLOR,
                                color: Colors.white,
                                onPressed: () {})),
                        const Sizer(
                          width: 5,
                        ),
                        Expanded(
                            child: AppButton(
                                label: 'Call',
                                icon: Icons.call,
                                backColor: AppColors.GREY_DARK_COLOR,
                                color: Colors.white,
                                onPressed: () {})),
                      ],
                    );
                  }
                }),
            const Sizer(),
            Row(
              children: [
                Expanded(
                    child: AppButton(
                        label: 'Premium Request',
                        icon: Icons.bookmark,
                        onPressed: () {
                          serviceLocator<SubscriptionController>()
                              .checkIfUserSubscribed(
                                  onSubscribed: () {
                                    if (controller.phone == null) {
                                      bottomSheet(
                                          context: context,
                                          widget: RideContactPhoneNumber(
                                            onChanged: (String v) =>
                                                controller.changePhone(v: v),
                                            onSubmit: () => controller
                                                .makeAdRequest(id: widget.id),
                                          ));
                                    } else {
                                      controller.makeAdRequest(id: widget.id);
                                    }
                                  },
                                  subCategoryId: state.ad?.subCategoryId ??
                                      '62c8ba9f8e28a58a3edf57eb');
                        })),
                const Sizer(
                  width: 5,
                ),
                Expanded(
                    child: AppButton(
                        label: 'Request',
                        icon: Icons.bookmark,
                        onPressed: () {
                          if (controller.phone == null) {
                            bottomSheet(
                                context: context,
                                widget: RideContactPhoneNumber(
                                  onChanged: (String v) =>
                                      controller.changePhone(v: v),
                                  onSubmit: () =>
                                      controller.makeAdRequest(id: widget.id),
                                ));
                          } else {
                            controller.makeAdRequest(id: widget.id);
                          }
                        })),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAdInfoWidget({required AdModel ad}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kToolbarHeight * 4,
          child: Swiper(
            itemCount: ad.images.length,
            onIndexChanged: (i) {},
            outer: true,
            physics: ad.images.length > 1
                ? null
                : const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: ImageFromInternet(
                image: ad.images[index],
                defaultLogo: true,
              ),
            ),
            pagination: SwiperPagination(
                builder: SwiperCustomPagination(builder: (context, config) {
              return const DotSwiperPaginationBuilder(
                      color: AppColors.GREY_DARK_COLOR,
                      activeColor: AppColors.SECONDARY_COLOR,
                      size: 10.0,
                      activeSize: 10.0)
                  .build(context, config);
            })),
          ),
        ),
        Row(
          children: [
            Label(
              text: "${LocaleKeys.title.localize} : ",
              style: Styles.mediumText(
                  fontWeight: FontWeight.bold,
                  color: AppColors.SECONDARY_COLOR),
            ),
            Label(
              text: ad.title,
              style: Styles.mediumText(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Label(text: ad.formatedDate)],
        ),
        const Sizer(),
        Label(
          text: "${LocaleKeys.desc.localize} : ",
          style: Styles.mediumText(
              fontWeight: FontWeight.bold, color: AppColors.SECONDARY_COLOR),
        ),
        Label(text: ad.description),
      ],
    );
  }

  Widget _buildDetailsWidget({required AdModel ad}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: LocaleKeys.details.localize,
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        ListView.builder(
            itemCount: ad.details.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final detail = ad.details[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                decoration: BoxDecoration(
                    color: index.isEven
                        ? AppColors.LIGHT_GRAY_COLOR
                        : Colors.white),
                child: Row(
                  children: [
                    Expanded(
                        child: Label(
                            text: "${detail.label} : ",
                            style: Styles.mediumText(
                                fontWeight: FontWeight.bold,
                                color: AppColors.SECONDARY_COLOR))),
                    Expanded(child: Label(text: detail.value)),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
