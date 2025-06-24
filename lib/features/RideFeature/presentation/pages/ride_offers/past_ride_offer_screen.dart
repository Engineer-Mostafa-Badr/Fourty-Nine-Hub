import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_client_accepted_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_offers/ride_non_socket_details_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../helpers/subscription_method.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../domain/entities/get_client_past_trips_entity.dart';
import '../../../domain/entities/get_client_pending_trips_entity.dart';
import '../../controllers/client_trips_cubit/client_trips_cubit.dart';
import '../dashboards/widgets/client_offers_widget.dart';
import '../ride_details_screen.dart';

class PastRideOfferScreen extends StatefulWidget {
  final String type;

  const PastRideOfferScreen({
    super.key,required this.type,
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
      if(widget.type=='ride')context.read<ClientTripsCubit>().getClientPastTrips();
      if(widget.type=='shipping')context.read<ClientTripsCubit>().getClientPastShippingTrips();
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
                ? Center(
                    child: CustomCircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : state.isError
                    ? Center(
                        child: Label(
                            text: LocaleKeys.errorHappen.localize,
                            style: const TextStyle(color: Colors.red)),
                      )
                    : context.read<ClientTripsCubit>().clientPastTripsData ==
                                null ||
                            context
                                .read<ClientTripsCubit>()
                                .clientPastTripsData
                                .isEmpty
                        ? Center(
                            child: Label(
                                text: LocaleKeys.youDontHavePastOffer.localize,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 18)),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: context
                                            .read<ClientTripsCubit>()
                                            .clientPastTripsData ==
                                        null ||
                                    context
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
    final priceText = _formatNumber(
        "${offers?.tripDetails?.price?.toInt() ?? 300}", context);
    return ClickableWidget(
      onTap: () {
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
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? AppColors.PRIMARY_COLOR
              : AppColors.cF5F5F5,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClickableWidget(
              onTap: () {
                context.push(
                  Routes.allDriverRatingScreen,
                  extra:offers?.driverDetails?.userId,
                );
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: offers?.driverDetails?.pictureUrl == null ||
                              offers!.driverDetails!.pictureUrl!.isEmpty
                              ? Image.asset(
                            Assets.maleImagePlaceholder,
                            fit: BoxFit.cover,
                          )
                              : ImageFromInternet(
                            fit: BoxFit.cover,
                            image: offers!.driverDetails!.pictureUrl!,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            // color: AppColors.cF5F5F5,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.star2,
                                  width: 8,
                                  height: 8,
                                ),
                                const Sizer(width: 4),
                                Label(
                                  text: _formatNumber(
                                      offers?.driverDetails?.rating?.count
                                          .toString() ??
                                          '0',
                                      context),
                                  style: Styles.smallText(
                                      color: AppColors.PRIMARY_COLOR),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Label(
                    text: offers?.driverDetails?.firstName ?? '',
                    style: Styles.mediumText(),
                  ),
                  Label(
                      text:context.isArabic ? offers?.driverDetails!.vehicleDetails?.brandAr ?? '': offers?.driverDetails!.vehicleDetails?.brandEn ?? '',
                      style: Styles.mediumText()),
                  Label(
                      text:context.isArabic ? offers?.driverDetails!.vehicleDetails?.modelAr ?? '':
                      offers?.driverDetails!.vehicleDetails?.modelEn ?? '',
                      style: Styles.mediumText()),
                  Label(
                    text: '(${_formatNumber(
                        offers?.driverDetails?.rating?.average
                            ?.toStringAsFixed(1) ??
                            '0',
                        context)})',
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
                              Label(
                                text:
                                '${LocaleKeys.passenger.localize} ${_formatNumber((offers?.tripDetails?.passengers ?? 0).toString(), context)}',
                                style: Styles.mediumText(),
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
                                        offers?.subCategory?.pictureUrl??'',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain),
                                Label(
                                    text: context.isArabic
                                        ? (offers
                                                ?.subCategory?.nameAr ??
                                            '')
                                        : (offers
                                                ?.subCategory?.nameEn ??
                                            ''),
                                    style: Styles.mediumText(fontSize: 25))
                              ],
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Label(
                          text: priceText,
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
                          text: formattedTime,
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Label(
                          text: formattedDate,
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
    );
  }
}
