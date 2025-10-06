import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/common/profile_picture_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_offers/ride_non_socket_details_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../domain/entities/get_client_past_trips_entity.dart';
import '../../controllers/client_trips_cubit/client_trips_cubit.dart';
import '../loading_dashboard/loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class PastRideOfferScreen extends StatefulWidget {
  final String type;

  const PastRideOfferScreen({
    super.key,
    required this.type,
  });

  @override
  State<PastRideOfferScreen> createState() => _PastRideOfferScreenState();
}

class _PastRideOfferScreenState extends State<PastRideOfferScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    // if(widget.type=='ride')context.read<ClientTripsCubit>().loadInitialClientPastTrips();
    // if(widget.type=='shipping')context.read<ClientTripsCubit>().loadInitialClientPastShippingTrips();
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.type == 'ride')
        context.read<ClientTripsCubit>().getClientPastTrips();
      if (widget.type == 'shipping')
        context.read<ClientTripsCubit>().getClientPastShippingTrips();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        child: Label(
                            text: LocaleKeys.errorHappen.localize,
                            style: const TextStyle(color: Colors.red)),
                      )
                    : context
                            .read<ClientTripsCubit>()
                            .clientPastTripsData
                            .isEmpty
                        ? Center(
                            child: Label(
                              text: LocaleKeys.youDontHavePastOffer.localize,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: context
                                    .read<ClientTripsCubit>()
                                    .clientPastTripsData
                                    .isEmpty
                                ? const EmptyPage()
                                : ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    // Shows default Android glow (wave effect)
                                    itemBuilder: (context, index) {
                                      return ClientPastWidget(
                                        offers: context
                                            .read<ClientTripsCubit>()
                                            .clientPastTripsData[index],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 5),
                                    itemCount: context
                                            .read<ClientTripsCubit>()
                                            .clientPastTripsData
                                            .length ??
                                        0),
                          );
          },
        ),
      ),
    );
  }
}

class ClientPastWidget extends StatelessWidget {
  final ClientPastTripEntity? offers;

  const ClientPastWidget({super.key, this.offers});

  // Helper method to convert digits based on locale
  String _formatNumber(String input, BuildContext context) {
    if (Localizations.localeOf(context).languageCode != 'ar') {
      return input;
    }

    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], arabic[i]);
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final dateTime = DateTime.parse(
        offers?.tripDetails?.createdAt ?? '2025-03-11T21:50:21.998Z');

    // Format date with Arabic digits if needed
    final formattedDate = isArabic
        ? _formatNumber(
            "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}",
            context)
        : "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

    // Format time with Arabic digits if needed
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    final formattedTime =
        "${_formatNumber(hour.toString(), context)} ${isArabic ? (period == 'AM' ? 'ص' : 'م') : period}";

    // Format price with Arabic digits if needed
    final priceText =
        _formatNumber("${offers?.tripDetails?.price?.toInt() ?? 300}", context);
    return GlobalCard(subcategoryId: '', phone: '', reportId: '', otherUserId: '',
    body: ClickableWidget(
      onTap: () {
        ManageVibration.vibrate();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RideNonSocketDetailsScreen(
              tripEntity: offers!,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClickableWidget(
              onTap: () {
                ManageVibration.vibrate();
                context.push(
                  Routes.allDriverRatingScreen,
                  extra: offers?.driverDetails?.userId,
                );
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      ProfilePictureWidget(
                        image: offers?.driverDetails?.pictureUrl,
                        hasStories: false,
                        rating: (offers?.driverDetails?.rating?.average??0).toInt(),
                      ),
                    ],
                  ),
                  Label(
                    text: offers?.clientDetails?.firstName ?? '',
                    style: Styles.mediumText(),
                  ),
                  Label(
                      text: context.isArabic
                          ? offers?.driverDetails?.vehicleDetails?.brandAr ?? ''
                          : offers?.driverDetails?.vehicleDetails?.brandEn ??
                          '',
                      style: Styles.mediumText()),
                  Label(
                      text: context.isArabic
                          ? offers?.driverDetails?.vehicleDetails?.modelAr ?? ''
                          : offers?.driverDetails?.vehicleDetails?.modelEn ??
                          '',
                      style: Styles.mediumText()),
                  Label(
                    text:
                    '(${_formatNumber(offers?.clientDetails?.rating?.average?.toStringAsFixed(1) ?? '0', context)})',
                    style: Styles.smallText(),
                  ),
                ],
              ),
            ),
            const Sizer(width: 32),
            Expanded(
              flex: 8,
              child: IntrinsicWidth(
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 5,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      Assets.rideFrom,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Label(
                                      text: offers?.tripDetails?.location
                                          ?.fromTitle ??
                                          'Cairo International Airport',
                                      style: Styles.headerText(),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      Assets.rideTo,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Label(
                                      text: offers?.tripDetails?.location
                                          ?.toTitle ??
                                          'Cairo International Airport',
                                      style: Styles.mediumText(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                              (offers?.tripDetails?.note==null||offers?.tripDetails?.note=='')?Label(
                                text:
                                '${LocaleKeys.passenger.localize} ${_formatNumber((offers?.tripDetails?.passengers ?? 0).toString(), context)}',
                                style: Styles.mediumText(),
                              ):Label(
                                text:
                                '${LocaleKeys.cargoDescription.localize}: ${offers?.tripDetails?.note}',
                                style: Styles.mediumText(),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                // offers?.category?.picture != null
                                //     ? Image.asset(Assets.rideIcon,
                                //     width: 40, height: 40, fit: BoxFit.cover)
                                //     :
                                ImageFromInternet(
                                    image:
                                    offers?.subCategory?.pictureUrl ?? '',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain),
                                Label(
                                    text: context.isArabic
                                        ? (offers?.subCategory?.nameAr ?? '')
                                        : (offers?.subCategory?.nameEn ?? ''),
                                    style: Styles.mediumText(fontSize: 25))
                              ],
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Label(
                          text: formatPrice(
                              offers?.tripDetails?.price ?? 0, context),
                          style: Styles.mediumText(fontWeight: FontWeight.w700),
                        ),
                        const Sizer(width: 4),
                        Label(
                          text: LocaleKeys.egp.tr(),
                          style: Styles.mediumText(
                            color: AppColors.SECONDARY_COLOR,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          text: formatTimeOnly(
                              offers?.tripDetails?.pickupTime, context),
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Label(
                          text: formatPickupDate(
                              offers?.tripDetails?.pickupTime, context),
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
