import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../ads/native_ad_card.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../../../domain/entities/trip_join_card_entity.dart';
import '../../cubits/request_trip_join_cubit/request_trip_join_cubit.dart';
import '../../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'available_trip_card.dart';
import 'available_trips_card_loading.dart';
import 'report_view_trip_join.dart';
import 'request_trip_Join_bottom_sheet.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../service_locator/service_locator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../../common/widgets/dialogs/please_login_dialog.dart';

class ViewAllTripJoinCardBuilder extends StatefulWidget {
  const ViewAllTripJoinCardBuilder({
    super.key,
  });

  @override
  State<ViewAllTripJoinCardBuilder> createState() =>
      _ViewAllTripJoinCardBuilderState();
}

class _ViewAllTripJoinCardBuilderState
    extends State<ViewAllTripJoinCardBuilder> {
  late final ViewAllTripJoinCubit viewAllTripJoinCubit;
  final AdsManager _adsManager = AdsManager();

  @override
  void initState() {
    viewAllTripJoinCubit = context.read<ViewAllTripJoinCubit>();
    super.initState();
    _adsManager.preloadAds();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
      // buildWhen: (previous, current) => !viewAllTripJoinCubit.noMoreDataInDatabase,
      builder: (context, state) {
        if (viewAllTripJoinCubit.tripJoinCards.isEmpty &&
            (state.status == ViewAllTripJoinStatus.success ||
                state.status == ViewAllTripJoinStatus.failure)) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(LocaleKeys.noTripsAvailable.localize),
          );
        }
        return ListView.builder(
          itemCount: viewAllTripJoinCubit.tripJoinCards.length + 1,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            if (index > nativeAdStart &&
                index % adFrequency == adFrequency - 1) {
              return getAdIfNeeded(index, _adsManager);
            }
            if (index < viewAllTripJoinCubit.tripJoinCards.length) {
              TripJoinCardEntity tripJoinCardEntity =
                  viewAllTripJoinCubit.tripJoinCards[index];
              return AvailableTripCard(
                tripJoinCardEntity: tripJoinCardEntity,
                reportOnTap: () {
                  if (context.read<UserCubit>().isLoggedIn) {
                    _reportOnTap(context, index);
                  } else {
                    return pleaseLoginDialog(context);

                    // context.pushNamed(Routes.LOGIN);
                  }
                },
                premuimRequestOnTap: () async {
                  if (context.read<UserCubit>().isLoggedIn) {
                    if (await _isPremuim(
                      tripJoinCardEntity,
                      tripJoinCardEntity.categoryId ?? '',
                      LocaleKeys.tripjoinPremuimSubscription.localize,
                    )) {
                      await showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        isScrollControlled: true,
                        builder: (_) {
                          return BlocProvider.value(
                              value: BlocProvider.of<RequestTripJoinCubit>(
                                  context),
                              child: RequstTripJoinBottomSheet(
                                  subCategory: "62ea00e269ea29c91dfc390c",
                                  url: "/ride/come-with-you/request/",
                                  tripId: tripJoinCardEntity.id ?? '',
                                  isPremium: true));
                        },
                      );
                    }
                  } else {
                    return pleaseLoginDialog(context);

                    // context.pushNamed(Routes.LOGIN);
                  }
                },
                requestOnTap: () async {
                  if (context.read<UserCubit>().isLoggedIn) {
                    await showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      builder: (_) {
                        return BlocProvider.value(
                            value:
                                BlocProvider.of<RequestTripJoinCubit>(context),
                            child: RequstTripJoinBottomSheet(
                              subCategory: "62ea00e269ea29c91dfc390c",
                              url: "/ride/come-with-you/request/",
                              tripId: tripJoinCardEntity.id ?? '',
                            ));
                      },
                    );
                  } else {
                    return pleaseLoginDialog(context);

                    // context.pushNamed(Routes.LOGIN);
                  }
                },
                callOnTap: () async {
                  if (context.read<UserCubit>().isLoggedIn) {
                    if (await _isPremuim(
                      tripJoinCardEntity,
                      UIConst.chatNormalId,
                      LocaleKeys.chatSubscription.localize,
                    )) {
                      launchUrlString("tel://${tripJoinCardEntity.phone}");
                    }
                  } else {
                    return pleaseLoginDialog(context);

                    // context.pushNamed(Routes.LOGIN);
                  }
                  // launchUrlString("tel://${tripJoinCardEntity.phone}");
                  // return;
                },
                messageOnTap: () async {
                  if (context.read<UserCubit>().isLoggedIn) {
                    if (await _isPremuim(
                      tripJoinCardEntity,
                      UIConst.chatNormalId,
                      LocaleKeys.chatSubscription.localize,
                    )) {}
                  } else {
                    return pleaseLoginDialog(context);

                    // context.pushNamed(Routes.LOGIN);
                  }
                },
                subscribeMessageOnTap: () async {
                  if (context.read<UserCubit>().isLoggedIn) {
                    print("LOOGEDIN \n");
                    if (await _isPremuim(
                      tripJoinCardEntity,
                      tripJoinCardEntity.categoryId ?? '',
                      LocaleKeys.tripjoinPremuimSubscription.localize,
                    )) {}
                  } else {
                    print("not LOOGEDIN \n");
                    return pleaseLoginDialog(context);

                    // context.pushNamed(Routes.LOGIN);
                  }
                },
              );
            }
            return state.status == ViewAllTripJoinStatus.loading &&
                    !viewAllTripJoinCubit.noMoreDataInDatabase
                ? const AvailableTripCardLoadingList()
                : const SizedBox();
          },
        );
      },
    );
  }

  Future<bool> _isPremuim(TripJoinCardEntity tripJoinCardEntity,
      String subCategoryId, String title) async {
    if (tripJoinCardEntity.subscribedPremium == null ||
        tripJoinCardEntity.subscribedPremium == false) {
      print("=========0=========");
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
        wallets: [
          tripJoinCardEntity.paymentMethod?.toWalletType ??
              WalletTypes.mainWallet
        ],
        subCategoryId: subCategoryId,
        title: title,
      );
      print("=========1=========");
      return false;
    }
    return true;
  }

  Future<bool> _userApproved(TripJoinCardEntity tripJoinCardEntity,
      String subCategoryId, String title) async {
    if (tripJoinCardEntity.isApproved == null ||
        tripJoinCardEntity.isApproved == false) {
      await serviceLocator<SubscriptionController>().showSubscriptionPlans(
        wallets: [
          tripJoinCardEntity.paymentMethod?.toWalletType ??
              WalletTypes.mainWallet
        ],
        subCategoryId: subCategoryId,
        title: title,
      );
      return false;
    }
    return true;
  }

  void _reportOnTap(BuildContext context, int index) {
    bottomSheet(
        context: context,
        widget: ReportViewTripJoin(
          id: viewAllTripJoinCubit.tripJoinCards[index].userId ?? '',
          cardId: viewAllTripJoinCubit.tripJoinCards[index].id ?? '',
          categoryId:
              viewAllTripJoinCubit.tripJoinCards[index].categoryId ?? '',
        ));
  }
}
