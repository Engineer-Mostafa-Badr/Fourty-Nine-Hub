import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/common/trip_location_widget.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../domain/entities/get_client_pending_trips_entity.dart';
import '../../controllers/client_trips_cubit/client_trips_cubit.dart';

class ClientPendingWidget extends StatelessWidget {
  final String modeType;
  final ClientPendingTripEntity? offers;

  const ClientPendingWidget({super.key, required this.modeType, this.offers});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    String formatNumber(String input, BuildContext context) {
      if (input.isEmpty) return '';

      // Parse number safely
      final number = double.tryParse(input.replaceAll(',', '')) ?? 0;

      // Format large numbers
      String formatted;
      if (number >= 1000000000) {
        formatted = "${(number / 1000000000).toStringAsFixed(1)}B";
      } else if (number >= 1000000) {
        formatted = "${(number / 1000000).toStringAsFixed(1)}M";
      } else if (number >= 1000) {
        formatted = "${(number / 1000).toStringAsFixed(1)}K";
      } else {
        formatted = number.toStringAsFixed(0);
      }

      // Remove trailing .0 if exists
      if (formatted.endsWith('.0')) {
        formatted = formatted.replaceAll('.0', '');
      }

      // Localize to Arabic if needed
      if (Localizations.localeOf(context).languageCode == 'ar') {
        const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
        const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

        for (int i = 0; i < english.length; i++) {
          formatted = formatted.replaceAll(english[i], arabic[i]);
        }
      }

      return formatted;
    }

    return GlobalCard(
      subcategoryId: '',
      phone: '',
      reportId: '',
      otherUserId: '',
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TripLocationWidget(
                        isFrom: true,
                        title: offers?.tripDetails?.location?.fromTitle ??
                            'Initial Location',
                      ),
                      TripLocationWidget(
                        isFrom: false,
                        title: offers?.tripDetails?.location?.toTitle ??
                            'Target Location',
                      ),
                      (offers?.tripDetails?.note == null ||
                              offers?.tripDetails?.note == '')
                          ? Label(
                              text:
                                  '${LocaleKeys.passenger.localize} ${formatNumber((offers?.tripDetails?.passengers ?? 0).toString(), context)}',
                              style: Styles.mediumText(),
                            )
                          : Label(
                              text:
                                  '${LocaleKeys.cargoDescription.localize}: ${offers?.tripDetails?.note}',
                              style: Styles.mediumText(),
                              maxLines: 2,
                            ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Label(
                          text: formatPrice(
                              offers?.tripDetails?.price?.toInt() ?? 300,
                              context),
                          style: Styles.mediumText(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 4),
                        Label(
                          text: LocaleKeys.egp.tr(),
                          style: Styles.mediumText(
                            color: AppColors.SECONDARY_COLOR,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    ImageFromInternet(
                      image: offers!.tripDetails!.category!.picture!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    Label(
                      text: context.isArabic
                          ? (offers?.tripDetails?.category?.nameAr ?? '')
                          : (offers?.tripDetails?.category?.nameEn ?? ''),
                      style: Styles.mediumText(fontSize: 25),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Label(
                  text: formatTimeOnly(offers?.tripDetails?.date, context),
                  style: Styles.mediumText(fontWeight: FontWeight.w700),
                ),
                Label(
                  text: formatPickupDate(offers?.tripDetails?.date, context),
                  style: Styles.mediumText(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppButton(
                border: Border.all(color: AppColors.PRIMARY_COLOR_DARK),
                height: 30,
                radius: 15,
                color: AppColors.PRIMARY_COLOR_DARK,
                label: LocaleKeys.cancel.tr(),
                onPressed: () {
                  ManageVibration.vibrate();
                  if (modeType == 'shipping') {
                    context.read<ClientTripsCubit>().cancelClientShippingTrip(
                        offers?.tripDetails?.id ?? "");
                  } else {
                    context
                        .read<ClientTripsCubit>()
                        .cancelClientTrip(offers?.tripDetails?.id ?? "");
                  }
                },
                backColor: AppColors.cD9D9D9),
          ],
        ),
      ),
    );
  }
}

class PendingRideOfferScreen extends StatefulWidget {
  final String type;

  const PendingRideOfferScreen({
    super.key,
    required this.type,
  });

  @override
  State<PendingRideOfferScreen> createState() => _PendingRideOfferScreenState();
}

class _PendingRideOfferScreenState extends State<PendingRideOfferScreen> {
  late ScrollController _scrollController;

  // @override
  // void initState() {
  //   super.initState();
  //   // if (widget.isTruk) {
  //   //   serviceLocator<ClientTripsCubit>().getLoadingOffers(context);
  //   // } else {
  //   //   serviceLocator<ClientTripsCubit>().getClientOffers(context);
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    print("objectType ${widget.type}");
    return Scaffold(
      body: BlocListener<ClientTripsCubit, ClientTripsState>(
        listener: (context, state) {
          if (state.status == ClientTripsStates.success &&
              state.showSnackbar &&
              state.createNonTrackTripEntity?.message.isNotEmpty == true) {
            showCustomSnackBar(
              context,
              state.createNonTrackTripEntity?.message ??
                  LocaleKeys.requestSentSuccess.localize,
              Icon(Icons.done_all_outlined, color: AppColors.CHECK_MARK_COLOR),
            );

            // Reset showSnackbar so it doesn’t show again
            context.read<ClientTripsCubit>().emit(
                  state.copyWith(showSnackbar: false),
                );
          }

          if (state.status == ClientTripsStates.error) {
            final failure = state.failure;
            if (failure is ServerFailure &&
                failure.errors != null &&
                failure.errors!.isNotEmpty) {
              showErrorMessage(context, failure.errors!.first);
              return;
            }
            showErrorMessage(
                context, getFailureMessage(state.failure!, context));
          }
        },
        child: BlocBuilder<ClientTripsCubit, ClientTripsState>(
          builder: (context, state) {
            return state.isLoading
                ? CustomLoadingSearchWidget()
                : state.isError
                    ? Center(
                        child: CustomEmptyWidget(
                            label: LocaleKeys.errorHappen.localize),
                      )
                    : context
                            .read<ClientTripsCubit>()
                            .clientPendingTripsData
                            .isEmpty
                        ? Center(
                            child: CustomEmptyWidget(
                              label:
                                  LocaleKeys.youDontHavePendingOffer.localize,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: context
                                    .read<ClientTripsCubit>()
                                    .clientPendingTripsData
                                    .isEmpty
                                ? const EmptyPage()
                                : OlxPaginationWidget(
                                    itemsPerPage: 3,
                                    scrollController: _scrollController,
                                    banners: bannersList,
                                    loadPage: (page) {
                                      if (widget.type == 'ride') {
                                        return context
                                            .read<ClientTripsCubit>()
                                            .getClientPendingTrips();
                                      } else {
                                        return context
                                            .read<ClientTripsCubit>()
                                            .getClientPendingShippingTrips();
                                      }
                                    },
                                    items: List.generate(
                                      context
                                          .read<ClientTripsCubit>()
                                          .clientPendingTripsData
                                          .length,
                                      (index) {
                                        return ClientPendingWidget(
                                          modeType: widget.type,
                                          offers: context
                                              .read<ClientTripsCubit>()
                                              .clientPendingTripsData[index],
                                        );
                                      },
                                    ),
                                  )
                            // GlowingOverscrollIndicator(
                            //         color: AppColors.SECONDARY_COLOR,
                            //         axisDirection: AxisDirection.down,
                            //         child: ListView.separated(
                            //             itemBuilder: (context, index) => ClientPendingWidget(
                            //                   modeType: widget.type,
                            //                   offers: state.clientPendingTripData?[index],
                            //                 ),
                            //             separatorBuilder: (context, index) => const SizedBox(height: 5),
                            //             itemCount: context.read<ClientTripsCubit>().clientPendingTripsData.length ?? 0),
                            //       ),
                            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_onScroll);
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // if(widget.type=='shipping')context.read<ClientTripsCubit>().loadInitialClientPendingShippingTrips();
    // if(widget.type=='ride')context.read<ClientTripsCubit>().loadInitialClientPendingTrips();
    super.initState();
    _scrollController = ScrollController();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.type == 'ride') {
        context.read<ClientTripsCubit>().getClientPendingTrips();
      }
      if (widget.type == 'shipping') {
        context.read<ClientTripsCubit>().getClientPendingShippingTrips();
      }
    }
  }
}
