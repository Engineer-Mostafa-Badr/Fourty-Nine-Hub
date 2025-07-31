import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/ads/native_ad_card.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/domain/entities/pickme_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/cubits/view_all_pick_me/view_all_pick_me_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/all_pick_me_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/widgets/all_pick_me_card_loading.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/request_trip_join_cubit/request_trip_join_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/report_view_trip_join.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/request_trip_Join_bottom_sheet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';

class AllPickMeBuilder extends StatefulWidget {
  const AllPickMeBuilder({super.key});

  @override
  State<AllPickMeBuilder> createState() => _AllPickMeBuilderState();
}

class _AllPickMeBuilderState extends State<AllPickMeBuilder> {
  late final ViewAllPickMeCubit viewAllPickMeCubit;
  late final ScrollController scrollController;
  late double scrollPosition;
  late double scrollMaxExtent;
  bool isLoading = false;
  final AdsManager _adsManager = AdsManager();
  @override
  void initState() {
    viewAllPickMeCubit = context.read<ViewAllPickMeCubit>();
    _fetchCardsIfEmpty();
    _scrollListener();
    _adsManager.preloadAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewAllPickMeCubit, ViewAllPickMeState>(
      listener: (context, state) {
        if (state is ViewAllPickMeFailed) {
          showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return ListView.builder(
          controller: scrollController,
          itemCount: viewAllPickMeCubit.cards.length,
          itemBuilder: (context, index) {
            if (index > nativeAdStart &&
                index % adFrequency == adFrequency - 1) {
              return getAdIfNeeded(index, _adsManager);
            }
            if (index == 0) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      style: Styles.mediumText(
                        color: AppColors.PRIMARY_COLOR_DARK,
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(
                          text: context.isArabic ? " لا تمتلك سيارة؟ " : "",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold), // تعديل الحجم هنا
                        ),
                        TextSpan(
                          text: context.isArabic
                              ? " أعلن عن رحلتك اليومية وابحث عن شخص يمكنه أن يوصلك بأسعار مخفضة"
                              : "",
                        ),
                        TextSpan(
                          text: context.isArabic ? "" : "Don’t have a car? ",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold), // تعديل الحجم هنا
                        ),
                        TextSpan(
                          text: context.isArabic
                              ? ""
                              : " Post your daily ride and find someone who can give you a discounted lift!",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            index--;

            if (index < viewAllPickMeCubit.cards.length) {
              final pickMeCardEntity = viewAllPickMeCubit.cards[index];
              return AllPickMeCard(
                pickMeCardEntity: pickMeCardEntity,
                reportOnTap: () {
                  context.pop();
                  if (context.read<UserCubit>().isLoggedIn) {
                    _reportOnTap(context, pickMeCardEntity);
                  } else {
                    return pleaseLoginDialog(context);

                    // context.push(Routes.LOGIN);
                  }
                },
                premuimRequestOnTap: () async {
                  context.pop();
                  if (context.read<UserCubit>().isLoggedIn) {
                    print(
                        "pickMeCardEntity.categoryId ${pickMeCardEntity.categoryId} \n");
                    if (await _isPremuim(
                      pickMeCardEntity,
                      pickMeCardEntity.categoryId ?? '',
                      LocaleKeys.tripjoinPremuimSubscription.localize,
                    )) {
                      print("====heeeeeeel==");
                      await showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        isScrollControlled: true,
                        builder: (_) {
                          return BlocProvider.value(
                              value: BlocProvider.of<RequestTripJoinCubit>(
                                  context),
                              child: RequstTripJoinBottomSheet(
                                  tripId: pickMeCardEntity.id ?? '',
                                  subCategory: "62ea008d69ea29c91dfc3908",
                                  url: "/ride/pick-me/request/",
                                  isPremium: true));
                        },
                      );
                    }
                  } else {
                    return pleaseLoginDialog(context);

                    // context.push(Routes.LOGIN);
                  }
                },
                requestOnTap: () async {
                  if (context.read<UserCubit>().isLoggedIn) {
                    await showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      builder: (_) {
                        print("hello");
                        return BlocProvider.value(
                            value:
                                BlocProvider.of<RequestTripJoinCubit>(context),
                            child: RequstTripJoinBottomSheet(
                              tripId: pickMeCardEntity.id ?? '',
                              subCategory: "62ea008d69ea29c91dfc3908",
                              url: "/ride/pick-me/request/",
                              isPremium: false,
                            ));
                      },
                    );
                  } else {
                    return pleaseLoginDialog(context);

                    // context.push(Routes.LOGIN);
                  }
                },
                callOnTap: () async {
                  if (context.read<UserCubit>().isLoggedIn) {
// launchUrlString("tel://${tripJoinCardEntity.phone}");
                    // return;
                    if (await _userApproved(
                      pickMeCardEntity,
                      UIConst.chatNormalId,
                      LocaleKeys.chatSubscription.localize,
                    )) {
                      launchUrlString("tel://${pickMeCardEntity.phone}");
                    }
                  } else {
                    return pleaseLoginDialog(context);

                    // context.push(Routes.LOGIN);
                  }
                },
                messageOnTap: () async {
                  if (context.read<UserCubit>().isLoggedIn) {
                    if (await _userApproved(
                      pickMeCardEntity,
                      UIConst.chatNormalId,
                      LocaleKeys.chatSubscription.localize,
                    )) {}
                  } else {                                  return pleaseLoginDialog(context);

                  // context.push(Routes.LOGIN);
                  }
                },
                subscribeMessageOnTap: () async {
                  if (context.read<UserCubit>().isLoggedIn) {
                    if (await _userApproved(
                      pickMeCardEntity,
                      pickMeCardEntity.categoryId ?? '',
                      LocaleKeys.tripjoinPremuimSubscription.localize,
                    )) {}
                  } else {                                  return pleaseLoginDialog(context);

                    // context.push(Routes.LOGIN);
                  }
                },
              );
            }
            return state is ViewAllPickMeLoading
                ? const PickMeCardLoadingList()
                : const SizedBox();
          },
        );
      },
    );
  }

  Future<bool> _isPremuim(PickMeCardEntity pickMeCardEntity,
      String subCategoryId, String title) async {
    print("-1========");
    print(pickMeCardEntity.subscribedPremium);
    if (pickMeCardEntity.subscribedPremium == null ||
        pickMeCardEntity.subscribedPremium == false) {
      print("=========0=========");

      // Await the completion of showSubscriptionPlans
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
        wallets: [
          pickMeCardEntity.paymentMethod?.toWalletType ?? WalletTypes.mainWallet,
        ],
        subCategoryId: subCategoryId,
        title: title,
      );

      print("==========1========");

      // Assuming user subscription could happen here,
      // check if the user subscribed after showing the subscription plans.
      return pickMeCardEntity.subscribedPremium == true;
    }
    return true;
  }

  Future<bool> _userApproved(PickMeCardEntity pickMeCardEntity,
      String subCategoryId, String title) async {
    if (pickMeCardEntity.isApproved == null ||
        pickMeCardEntity.isApproved == false) {
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
        wallets: [
          pickMeCardEntity.paymentMethod?.toWalletType ?? WalletTypes.mainWallet
        ],
        subCategoryId: subCategoryId,
        title: title,
      );
      return false;
    }
    return true;
  }

  void _reportOnTap(BuildContext context, PickMeCardEntity pickMeCardEntity) {
    bottomSheet(
        context: context,
        widget: ReportViewTripJoin(
          id: pickMeCardEntity.userId ?? '',
          cardId: pickMeCardEntity.id ?? '',
          categoryId: pickMeCardEntity.categoryId ?? '',
        ));
  }

  void _scrollListener() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      scrollPosition = scrollController.position.pixels;
      scrollMaxExtent = scrollController.position.maxScrollExtent;
      if (scrollPosition >= 0.7 * scrollMaxExtent) {
        if (!isLoading &&
            (viewAllPickMeCubit.cards.last.hasNextPage ?? false)) {
          isLoading = true;
          viewAllPickMeCubit.page =
              viewAllPickMeCubit.cards.last.nextPage!.toInt();
          await viewAllPickMeCubit.getAllPickMe();
          isLoading = false;
        }
      }
    });
  }

  void _fetchCardsIfEmpty() {
    if (viewAllPickMeCubit.cards.isEmpty) {
      viewAllPickMeCubit.page = 1;
      viewAllPickMeCubit.getAllPickMe();
    }
  }
}
