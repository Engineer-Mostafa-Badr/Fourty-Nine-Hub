import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
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
import '../../../domain/entities/get_client_offer_trips_entity.dart';
import '../../controllers/client_trips_cubit/client_trips_cubit.dart';
import '../loading_dashboard/loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class OfferRideOfferScreen extends StatefulWidget {
  final String type;

  const OfferRideOfferScreen({
    super.key,required this.type,
  });

  @override
  State<OfferRideOfferScreen> createState() =>
      _OfferRideOfferScreenState();
}

class _OfferRideOfferScreenState extends State<OfferRideOfferScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    if(widget.type=='shipping') {
      // context.read<ClientTripsCubit>().loadInitialClientOfferShippingTrips();
    context.read<ClientTripsCubit>().listenToUpdateOfferTripShipping();
    }
    if(widget.type=='ride') {
      // context.read<ClientTripsCubit>().loadInitialClientOfferTrips();
    context.read<ClientTripsCubit>().listenToUpdateOfferTripNonSocket();
    }
    _scrollController = ScrollController()..addListener(_onScroll);
      // if (!dashboardCubit.isClosed) {
      // // dashboardCubit.getAvailableNonSocketTrips(),
      // dashboardCubit.listenToRemoveUntrackedTrip(),
      // dashboardCubit.listenToNewTripNonSocket()
      // // }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if(widget.type=='ride')context.read<ClientTripsCubit>().getClientOfferTrips();
      if(widget.type=='shipping')context.read<ClientTripsCubit>().getClientOfferShippingTrips();
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
            showErrorMessage(context, getFailureMessage(state.failure!, context));
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
                    : context.read<ClientTripsCubit>().clientOfferTripsData.isEmpty
                        ?  Center(
                            child: Label(
                                text: LocaleKeys.youDontHaveAvailableOffer.localize,
                                // style:
                                //     TextStyle(color: Colors.red, fontSize: 18)
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: context.read<ClientTripsCubit>().clientOfferTripsData.isEmpty
                                ? const EmptyPage()
                                : ListView.separated(
                                    itemBuilder: (context, index) =>
                                        ClientOfferWidget(
                                          offers: context.read<ClientTripsCubit>().clientOfferTripsData[index],
                                          modeType: widget.type,
                                          onRefuseOffer: (String id){
                                            // context.read<ClientTripsCubit>().refuseClientShippingTrip(id,context);
                                            setState(() {

                                            });
                                          },
                                        ),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 5),
                                    itemCount:
                                    context.read<ClientTripsCubit>().clientOfferTripsData.length),
                          );
          },
        ),
      ),
    );
  }
}

class ClientOfferWidget extends StatelessWidget {
  final String modeType;
  final ClientOfferTripEntity? offers;
  final Function(String id) onRefuseOffer;

  const ClientOfferWidget({super.key,required this.modeType, this.offers,required this.onRefuseOffer});

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

    DateTime dateTime = DateTime.parse(
        offers?.tripDetails?.date ?? '2025-03-11T21:50:21.998Z');

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

    // Format rating count and average
    final ratingCount = _formatNumber(
        offers?.driverDetails?.rating?.count?.toString() ?? '0', context);
    final ratingAverage = _formatNumber(
        (offers?.driverDetails?.rating?.average ?? 0).toStringAsFixed(1), context);

    // Format passengers count
    final passengersCount = _formatNumber(
        (offers?.tripDetails?.passengers ?? 0).toString(), context);

    // Format price (handle socket price if applicable)
    final price = offers?.isFromSocket == true
        ? offers?.newOfferPrice ?? offers?.price ?? 300
        : offers?.price ?? 300;
    final priceText = _formatNumber(price.toString(), context);


    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth * 0.2; // 20% of screen width, tweak as needed
    final badgeTopOffset = avatarSize * 0.1; // 10% from top of avatar container
    final badgeEndOffset = avatarSize * 0.0; // 0% from right edge (or tweak slightly)

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.cF5F5F5,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClickableWidget(
            onTap: () {
      ManageVibration.vibrate();
              context.push(
                Routes.allDriverRatingScreen,
                extra:offers?.id,
              );
            },
            child: Column(children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Container(
                        // width: 75,
                        // height: 75,
                        width: avatarSize,
                        height: avatarSize,
                        decoration:
                        const BoxDecoration(shape: BoxShape.circle),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: offers?.driverDetails?.pictureUrl == null ||
                            offers!.driverDetails!.pictureUrl!.isEmpty
                            ? Image.asset(
                          Assets.maleImagePlaceholder,
                          fit: BoxFit.cover,
                        )
                            : ImageFromInternet(
                          image: offers!.driverDetails!.pictureUrl!,
                        )),
                  ),
                  PositionedDirectional(
                      top: badgeTopOffset,
                      end: badgeEndOffset,
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            // color: AppColors.cF5F5F5,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Row(children: [
                                SvgPicture.asset(Assets.star2,
                                    width: 8, height: 8),
                                const Sizer(width: 4),
                                Label(
                                    text: ratingCount,
                                    style: Styles.smallText(
                                        color: AppColors.PRIMARY_COLOR))
                              ]))))
                ],
              ),
              Label(
                  text: offers?.driverDetails?.firstName ?? '',
                  style: Styles.mediumText()),
              Label(
                  text:context.isArabic ? offers?.driverDetails!.vehicleDetails?.brandAr ?? '': offers?.driverDetails!.vehicleDetails?.brandEn ?? '',
                  style: Styles.mediumText()),
              Label(
                  text:context.isArabic ? offers?.driverDetails!.vehicleDetails?.modelAr ?? '':
                  offers?.driverDetails!.vehicleDetails?.modelEn ?? '',
                  style: Styles.mediumText()),
              Label(
                  text: '($ratingAverage)',
                  style: Styles.smallText())
            ]),
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
                                  child: Image.asset(Assets.rideFrom,
                                      width: 24, height: 24),
                                ),
                                Expanded(
                                    flex: 8,
                                    child: Label(
                                        text: offers?.tripDetails?.location
                                            ?.fromTitle ??
                                            'Cairo International Airport',
                                        style: Styles.headerText()))
                              ],
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(Assets.rideTo,
                                        width: 24, height: 24)),
                                Expanded(
                                    flex: 8,
                                    child: Label(
                                        text: offers?.tripDetails?.location
                                            ?.toTitle ??
                                            'Cairo International Airport',
                                        style: Styles.mediumText(
                                            fontWeight: FontWeight.w300)))
                              ],
                            ),
                            if(modeType =='ride')
                            Label(
                                text:
                                '${LocaleKeys.passenger.localize}  $passengersCount',
                                style: Styles.mediumText())
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              ImageFromInternet(
                                  image:
                                  offers!.tripDetails!.subcategory!.pictureUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain),
                              Label(
                                  text: isArabic
                                      ? (offers
                                      ?.tripDetails?.subcategory?.nameAr ??
                                      '')
                                      : (offers
                                      ?.tripDetails?.subcategory?.nameEn ??
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
                        text: formatPrice(offers?.isFromSocket == true ? offers?.newOfferPrice ?? offers?.newOfferPrice ?? 300 : offers?.newOfferPrice ?? 300, context),
                        style: Styles.mediumText(fontWeight: FontWeight.w700),
                      ),
                      const Sizer(width: 4),
                      Label(
                          text: LocaleKeys.egp.tr(),
                          style: Styles.mediumText(
                              color: AppColors.SECONDARY_COLOR,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Label(
                        text: formatTimeOnly(offers?.tripDetails?.date,context),
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Label(
                        text: formatPickupDate(offers?.tripDetails?.date, context),
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppButton(
                            height: 30,
                            radius: 15,
                            label: LocaleKeys.Accept.tr(),
                            onPressed: () {
      ManageVibration.vibrate();
                              modeType=='ride'?context.read<ClientTripsCubit>().acceptClientTrip(offers?.id ?? ""):context.read<ClientTripsCubit>().acceptClientShippingTrip(offers?.id ?? "");
                              onRefuseOffer(offers?.id??"");
                            },
                            backColor: AppColors.PRIMARY_COLOR
                        ),
                      ),
                      const Sizer(),
                      Expanded(
                        child: AppButton(
                            radius: 15,
                            height: 30,
                            label: LocaleKeys.refuse.tr(),
                            style: Styles.mediumText(
                                color: Colors.white, fontSize: 23),
                            onPressed: () async{
      ManageVibration.vibrate();
                              modeType=='ride'?await context.read<ClientTripsCubit>().refuseClientTrip(offers?.id ?? ""):await context.read<ClientTripsCubit>().refuseClientShippingTrip(offers?.id ?? "",context);
                                onRefuseOffer(offers?.id??"");

                            },
                            backColor: AppColors.SECONDARY_COLOR_DARK2

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
    );
  }
}