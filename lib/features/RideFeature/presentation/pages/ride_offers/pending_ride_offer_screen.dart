import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../domain/entities/get_client_pending_trips_entity.dart';
import '../../controllers/client_trips_cubit/client_trips_cubit.dart';

class PendingRideOfferScreen extends StatefulWidget {
  final String type;

  const PendingRideOfferScreen({
    super.key, required this.type,
  });

  @override
  State<PendingRideOfferScreen> createState() =>
      _PendingRideOfferScreenState();
}

class _PendingRideOfferScreenState extends State<PendingRideOfferScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    // if(widget.type=='shipping')context.read<ClientTripsCubit>().loadInitialClientPendingShippingTrips();
    // if(widget.type=='ride')context.read<ClientTripsCubit>().loadInitialClientPendingTrips();
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if(widget.type=='ride')context.read<ClientTripsCubit>().getClientPendingTrips();
      if(widget.type=='shipping')context.read<ClientTripsCubit>().getClientPendingShippingTrips();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

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
                    :context.read<ClientTripsCubit>().clientPendingTripsData.isEmpty
                        ?  Center(
                            child: Label(
                                text: LocaleKeys.youDontHavePendingOffer.localize,

                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: context.read<ClientTripsCubit>().clientPendingTripsData.isEmpty
                                ? const EmptyPage()
                                : ListView.separated(
                                    itemBuilder: (context, index) =>
                                        ClientPendingWidget(
                                          modeType: widget.type,
                                          offers: state
                                              .clientPendingTripData?[index],
                                        ),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 5),
                                    itemCount:
                                        context.read<ClientTripsCubit>().clientPendingTripsData.length ??
                                            0),
                          );
          },
        ),
      ),
    );
  }
}

class ClientPendingWidget extends StatelessWidget {
  final String modeType;
  final ClientPendingTripEntity? offers;

  const ClientPendingWidget({super.key,required this.modeType, this.offers});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth * 0.2; // 20% of screen width, tweak as needed
    final badgeTopOffset = avatarSize * 0.1; // 10% from top of avatar container
    final badgeEndOffset = avatarSize * 0.0; // 0% from right edge (or tweak slightly)

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.cF5F5F5,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // Trip Details Column
          Expanded(
            flex: 8,
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Container(
                                  width: avatarSize,
                                  height: avatarSize,
                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: (offers?.yourDetails?.pictureUrl == null ||
                                      offers!.yourDetails!.pictureUrl!.isEmpty)
                                      ? Image.asset(
                                    Assets.maleImagePlaceholder,
                                    fit: BoxFit.cover,
                                  )
                                      : ImageFromInternet(
                                    image: offers!.yourDetails!.pictureUrl!,
                                  ),
                                ),
                              ),
                              if((offers?.yourDetails?.rating?.count??0)>0)PositionedDirectional(
                                top: badgeTopOffset,
                                end: badgeEndOffset,
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
                                        const SizedBox(width: 4),
                                        Label(
                                          text: offers?.yourDetails?.rating?.count.toString() ?? '0',
                                          style: Styles.smallText(color: AppColors.PRIMARY_COLOR),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Label(
                            text: offers?.yourDetails?.firstName ?? '',
                            style: Styles.mediumText(),
                          ),
                          if((offers?.yourDetails?.rating?.average??0)>0)Label(
                            text: '(${offers?.yourDetails?.rating?.average ?? 0})',
                            style: Styles.smallText(),
                          ),
                        ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  Assets.rideFrom,
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Label(
                                    text: offers?.tripDetails?.location?.fromTitle ??
                                        'Cairo International Airport',
                                    style: Styles.headerText(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  Assets.rideTo,
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Label(
                                    text: offers?.tripDetails?.location?.toTitle ??
                                        'Cairo International Airport',
                                    style: Styles.mediumText(fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                            Label(
                              text:
                              modeType=='shipping'?'':'${LocaleKeys.passenger.localize}  ${formatPrice(offers?.tripDetails?.passengers ?? 1,context)}',
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
                      ),
                    ],
                  ),
                  if(modeType=='shipping')...[
                    ReadMoreLabel(text: modeType=='shipping'?'${context.isArabic ? 'وصف الشحنة' : 'Cargo Description'} : ${offers?.tripDetails?.note??''} ':'',
                        style: Styles.mediumText(color: AppColors.PRIMARY_COLOR)
                    )
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label(
                        text: formatPrice(offers?.tripDetails?.price?.toInt() ?? 300, context),
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
                  const SizedBox(height: 4),
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
                        if(modeType=='shipping'){
                          context
                              .read<ClientTripsCubit>()
                              .cancelClientShippingTrip(offers?.tripDetails?.id ?? "");
                        }else{
                          context
                              .read<ClientTripsCubit>()
                              .cancelClientTrip(offers?.tripDetails?.id ?? "");
                        }
                      },
                      backColor: AppColors.cD9D9D9),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
