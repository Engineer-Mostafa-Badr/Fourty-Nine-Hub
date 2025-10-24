import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/constants/subscription_status.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/cubit/ad_details_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/pages/ad_requests_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_details_prop_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/are_you_sure_delete_ad_widget.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

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
    final userId = serviceLocator<UserCubit>().state.data?.id ?? '';

    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
      builder: (context, state) {
        if (state.ad == null) {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        }
        return CustomScaffold(
          body: BlocConsumer<AdDetailsCubit, AdDetailsState>(
            listener: (context, state) {
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
            },
            builder: (context, state) {
              if (state.ad == null) {
                return const Center(
                  child: CustomCircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  // Images Section - Fixed at top
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Stack(
                      children: [
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => ImageFromInternet(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.4,
                            image: state.ad!.images[index],
                            defaultLogo: true,
                            fit: BoxFit.cover,
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 8,
                          ),
                          itemCount: state.ad!.images.length,
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top * 2),
                        ),
                        // Navigation buttons overlay
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 8,
                          left: 16,
                          right: 16,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  ManageVibration.vibrate();
                                  context.pop();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.getReversedTextColor(context),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  ManageVibration.vibrate();
                                  if (state.ad!.isFavourite == true) {
                                    await context
                                        .read<AdvertisementCubit>()
                                        .unFavouriteAd(state.ad!.id);
                                    state.ad!.isFavourite = false;
                                  } else {
                                    await context
                                        .read<AdvertisementCubit>()
                                        .favouriteAd(state.ad!.id);
                                    state.ad!.isFavourite = true;
                                  }
                                  if (mounted) setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    state.ad!.isFavourite == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: state.ad!.isFavourite == true
                                        ? Colors.red
                                        : AppColors.getTextColor(context),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom Sheet with Details
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.getReversedTextColor(context),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Basic Info Section
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Label(
                                  text: state.ad!.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  color: AppColors.getTextColor(context),
                                  style: Styles.headerText(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF33D49)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFF33D49)
                                          .withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Label(
                                    text:
                                        '${FormatNumbers().formatNumberByComma(state.ad!.price.toString(), isArabic: context.isArabic)} ${context.isArabic ? state.ad!.currencyAr : state.ad!.currencyEn}',
                                    color: const Color(0xFFF33D49),
                                    style: Styles.headerText(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Label(
                                  text: state.ad!.description,
                                  color: AppColors.getTextColor(context),
                                  style: Styles.mediumText(
                                    fontSize: 26,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      Assets.adsLocationIcon,
                                      color: AppColors.getTextColor(context),
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Label(
                                        text: context.isArabic
                                            ? '${state.ad!.cityAr}, ${state.ad!.governorateAr}'
                                            : '${state.ad!.cityEn}, ${state.ad!.governorateEn}',
                                        style: Styles.mediumText(
                                          fontSize: 24,
                                          height: 1.60,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Details Section
                            Builder(
                              builder: (context) {
                                // Filter out salary and price details as they're already shown
                                List<AdDetailsPropEntity> details = state
                                    .ad!.details
                                    .where((e) =>
                                        e.nameAr != 'الراتب' &&
                                        e.nameAr != 'السعر')
                                    .toList();

                                print(
                                    "DEBUG: Total details: ${state.ad!.details.length}, Filtered: ${details.length}");
                                if (details.isNotEmpty) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: AppColors.getTextColor(context)
                                            .withOpacity(0.2),
                                      ),
                                      const SizedBox(height: 16),
                                      Label(
                                        text: context.isArabic
                                            ? 'تفاصيل الإعلان'
                                            : 'Ad Details',
                                        style: Styles.headerText(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              AppColors.getTextColor(context),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _buildDetailsSection(state.ad!),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),

                            const SizedBox(height: 42),
                            userId == state.ad?.userId
                                ? _buildRequestsButton(state.ad?.id ?? '')
                                : _buildActionsWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRequestsButton(String adId) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 8),
      child: Column(
        children: [
          AppButton(
            height: 38,
            backColor: AppColors.c0B1035,
            onPressed: () async {
              ManageVibration.vibrate();
              context.push(Routes.ADRequests,
                  extra: AdRequestParams(id: widget.id, userName: ''));
            },
            label: LocaleKeys.showAdRequests.localize,
            style: Styles.headerText(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          AppButton(
            label: LocaleKeys.deleteRequest.localize,
            height: 38,
            backColor: AppColors.SECONDARY_COLOR_DARK2,
            onPressed: () {
              ManageVibration.vibrate();
              bottomSheet(
                  context: context,
                  isFloating: true,
                  asAlertDialog: true,
                  widget: AreYouSureDeleteAdWidget(
                    title: LocaleKeys.alert.localize,
                    subTitle: LocaleKeys.areYouSureAboutDeletingTheAD.localize,
                    action: () async {
                      showLoadingDialog(context);
                      await context.read<SubcategoriesCubit>().deleteAd(adId);
                      if (!mounted) return;
                      context.pop();
                      context.pop();
                      if (context
                              .read<SubcategoriesCubit>()
                              .state
                              .deleteAdStatus ==
                          SubcategoriesStates.adsSuccess) {
                        context
                            .read<SubcategoriesCubit>()
                            .loadMyAds(id: widget.id);
                        showSuccessMessage(
                            context,
                            context.isArabic
                                ? 'تم حذف اعلانك'
                                : 'Your ad has been deleted');
                        context.pop();
                      }
                      if (context
                              .read<SubcategoriesCubit>()
                              .state
                              .deleteAdStatus ==
                          SubcategoriesStates.error) {
                        showErrorMessage(
                            context,
                            getFailureMessage(
                                context
                                        .read<SubcategoriesCubit>()
                                        .state
                                        .failure ??
                                    UnknownFailure(''),
                                context));
                      }
                    },
                  ));
            },
            style: Styles.headerText(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(AddDetailsModel ad) {
    // Filter out salary and price details as they're already shown
    List<AdDetailsPropEntity> details = ad.details
        .where((e) => e.nameAr != 'الراتب' && e.nameAr != 'السعر')
        .toList();

    print("DEBUG: _buildDetailsSection called with ${details.length} details");
    if (details.isEmpty) {
      print("DEBUG: No details to show, returning SizedBox.shrink()");
      return const SizedBox.shrink();
    }

    return Column(
      children: details.map((detail) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.getTextColor(context).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.getTextColor(context).withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon if available
              if (detail.imageUrl.isNotEmpty) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF33D49).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: ImageFromInternet(
                      image: detail.imageUrl,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Detail content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: context.isArabic ? detail.nameAr : detail.nameEn,
                      style: Styles.mediumText(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF33D49),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Label(
                      text: context.isArabic ? detail.valueAr : detail.valueEn,
                      style: Styles.mediumText(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: AppColors.getTextColor(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionsWidget() {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                BlocProvider.value(
                  value: serviceLocator<AdvertisementCubit>(),
                  child: Row(
                    children: [
                      Expanded(
                        child: PremiumRequestButton(
                          adId: state.ad?.id ?? '',
                          subCategoryId: state.ad?.subCategoryId ?? '',
                          subscriptionStatus:
                              state.ad?.userSubscriptionStatus ?? '',
                          dontPop: true,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: RequestButton(
                          adId: state.ad?.id ?? '',
                          subscriptionStatus:
                              state.ad?.userSubscriptionStatus ?? '',
                          dontPop: true,
                          successRequest: () {
                            context.pop();
                            showSuccessMessage(
                                context,
                                context.isArabic
                                    ? 'تم ارسال طلب التواصل'
                                    : 'Request Sent Successfully');
                            context.read<AdvertisementCubit>().resetRequest();
                          },
                          errorRequest: (failure) {
                            context.pop();
                            showSuccessMessage(
                                context,
                                context.isArabic
                                    ? 'تم ارسال طلب التواصل'
                                    : 'Request Sent Successfully');
                            context.read<AdvertisementCubit>().resetRequest();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (state.ad?.userSubscriptionStatus ==
                    SubscriptionStatus.notSubscribed.status)
                  const SizedBox(
                    height: 16,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: MarriageCallMessageButtons(
                    otherUserId: state.ad?.userId ?? '',
                    subcategoryId: state.ad?.subCategoryId ?? '',
                    phone: state.ad?.phone ?? '',
                    id: state.ad?.id ?? '',
                    hasReport: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}


// Stack(
//                 children = [
//                   ListView.separated(
//                     itemBuilder: (context, index) => ImageFromInternet(
//                       width: double.infinity,
//                       height: 600.h, // Reduced from 600.h for better UX
//                       image: state.ad!.images[index],
//                       defaultLogo: true,
//                       fit: BoxFit.cover,
//                     ),
//                     separatorBuilder: (context, index) => const SizedBox(
//                       height: 8,
//                     ),
//                     itemCount: state.ad!.images.length,
//                     padding: EdgeInsets.only(
//                         top: MediaQuery.of(context).padding.top * 3),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                       top: MediaQuery.of(context).padding.top + 8,
//                       left: 16,
//                       right: 16,
//                     ),
//                     child: Row(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             ManageVibration.vibrate();
//                             context.pop();
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: AppColors.getReversedTextColor(context),
//                               shape: BoxShape.circle,
//                             ),
//                             padding: const EdgeInsets.all(8),
//                             child: const Icon(
//                               Icons.arrow_back,
//                               size: 24,
//                             ),
//                           ),
//                         ),