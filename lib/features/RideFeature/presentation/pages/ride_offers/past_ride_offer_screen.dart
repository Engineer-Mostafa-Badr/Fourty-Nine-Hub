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
import 'package:go_router/go_router.dart';

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
  // final bool isTruk;

  const PastRideOfferScreen({
    super.key,
  });

  @override
  State<PastRideOfferScreen> createState() => _PastRideOfferScreenState();
}

class _PastRideOfferScreenState extends State<PastRideOfferScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ClientTripsCubit>().getClientPastTrips();
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
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : state.isError
                    ? Center(
                        child: Label(
                            text: LocaleKeys.errorHappen.localize,
                            style: const TextStyle(color: Colors.red)),
                      )
                    : context
                                    .read<ClientTripsCubit>()
                                    .clientPastTripsData ==
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
                                physics: BouncingScrollPhysics(), // Shows default Android glow (wave effect)
                                    itemBuilder: (context, index) =>
                                        ClientPastWidget(
                                          offers: context.read<ClientTripsCubit>()
                                              .clientPastTripsData?[index],
                                        ),
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

  const ClientPastWidget({super.key,  this.offers});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(
        offers?.tripDetails?.createdAt ?? '2025-03-11T21:50:21.998Z');
    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    String formattedTime =
        "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12} ${dateTime.hour < 12 ? 'AM' : 'PM'}";
    return ClickableWidget(
      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context)=> RideDetailsScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color:
                context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.cF5F5F5,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
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
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: offers?.yourDetails?.pictureUrl == null ||
                              offers!.yourDetails!.pictureUrl!.isEmpty
                              ? Image.asset(
                            Assets.maleImagePlaceholder,
                            fit: BoxFit.cover,
                          )
                              : ImageFromInternet(
                            fit: BoxFit.cover,
                            image: offers!.yourDetails!.pictureUrl!,
                          ),
                        ),
                      ),

                      Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.cF5F5F5,
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
                                        text: offers?.yourDetails?.rating?.count
                                                .toString() ??
                                            '0',
                                        style: Styles.smallText(
                                            color: AppColors.PRIMARY_COLOR))
                                  ]))))
                    ],
                  ),
                  Label(
                      text: offers?.yourDetails?.firstName ?? '',
                      style: Styles.mediumText()),
                  Label(
                      text: '(${offers?.yourDetails?.rating?.average ?? 0})',
                      style: Styles.smallText())
                ])),
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
                              Label(
                                  text: '${LocaleKeys.passenger.localize}  ${offers?.tripDetails?.passengers ?? 0}',

                                  style: Styles.mediumText())
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
                                        offers!.tripDetails!.category!.picture!,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain),
                                Label(
                                    text: context.isArabic
                                        ? (offers
                                                ?.tripDetails?.category?.nameAr ??
                                            '')
                                        : (offers
                                                ?.tripDetails?.category?.nameEn ??
                                            ''),
                                    style: Styles.mediumText(fontSize: 25))
                              ],
                            )),
                      ],
                    ),
                    // Label(
                    //   text: modeType == 'truk'
                    //       ? "${LocaleKeys.cargoDescription.tr()} : Car"
                    //       : '${LocaleKeys.passenger.tr()} : ${offers?.tripDetails?.passengers ?? 0}',
                    //   style: Styles.mediumText(fontSize: 32),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Label(
                            text: "${offers?.tripDetails?.price ?? 300}",
                            style:
                                Styles.mediumText(fontWeight: FontWeight.w700)),
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
                          text: formattedTime, //'10 AM',
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Label(
                          text: formattedDate, //'20/2/2025',
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
