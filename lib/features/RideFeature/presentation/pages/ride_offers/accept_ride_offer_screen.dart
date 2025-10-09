import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/common/profile_picture_widget.dart';
import 'package:fourtyninehub/core/widget/common/trip_location_widget.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_client_accepted_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
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
import '../../controllers/client_trips_cubit/client_trips_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class AcceptRideOfferScreen extends StatefulWidget {
  final String type;

  const AcceptRideOfferScreen({
    super.key,
    required this.type,
  });

  @override
  State<AcceptRideOfferScreen> createState() => _AcceptRideOfferScreenState();
}

class _AcceptRideOfferScreenState extends State<AcceptRideOfferScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.type == 'ride') {
        context.read<ClientTripsCubit>().getClientAcceptedTrips();
      }
      if (widget.type == 'shipping') {
        context.read<ClientTripsCubit>().getClientAcceptedShippingTrips();
      }
    }
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_onScroll);
    // _scrollController.dispose();
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
                                .clientAcceptedTripsData
                                .isEmpty
                        ? Center(
                            child: Label(
                                text:
                                    LocaleKeys.youDontHaveAcceptedOffer.localize
                                // , style: TextStyle(color: Colors.red, fontSize: 18)
                                ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: context
                                        .read<ClientTripsCubit>()
                                        .clientAcceptedTripsData
                                        .isEmpty
                                ? const EmptyPage()
                            :OlxPaginationWidget(
                              itemsPerPage: 3,
                              scrollController: _scrollController,
                              banners: bannersList,
                              loadPage: (page) {
                                if (widget.type == 'ride') {
                                  return context.read<ClientTripsCubit>().getClientAcceptedTrips();
                                }else{
                                  return context.read<ClientTripsCubit>().getClientAcceptedShippingTrips();
                                }
                              },

                              items: List.generate(
                                context
                                    .read<ClientTripsCubit>()
                                    .clientAcceptedTripsData.length,
                                    (index) {
                                  return ClientAcceptWidget(
                                    offers: context
                                        .read<ClientTripsCubit>()
                                        .clientAcceptedTripsData[index],
                                  );
                                },
                              ),
                            )
                          );
          },
        ),
      ),
    );
  }
}

class ClientAcceptWidget extends StatelessWidget {
  final String modeType;
  final ClientAcceptedTripEntity? offers;

  const ClientAcceptWidget({super.key, this.modeType = 'truk', this.offers});

  // Helper method to convert digits based on locale
  String _formatNumber(String input, BuildContext context) {
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


  String _capitalize(String? s) {
    if (s == null || s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }
  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    DateTime dateTime = DateTime.parse(
      offers?.tripDetails?.createdAt ?? '2025-03-11T21:50:21.998Z',
    );

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
        (offers?.driverDetails?.rating?.average ?? 0).toStringAsFixed(1),
        context);

    // Format passengers count
    final passengersCount = _formatNumber(
        (offers?.tripDetails?.passengers ?? 0).toString(), context);

    // Format price
    final price =
        _formatNumber("${offers?.tripDetails?.price ?? 300}", context);
    print("offers?.isButtonEnabled ${offers?.isButtonEnabled}");
    print("offers?.tripDetails?.category?.id ${offers?.tripDetails?.category?.id}");
    return GlobalCard(
      subcategoryId: offers?.tripDetails?.category?.id??'',
      phone: offers?.driverDetails?.phoneNumber??'',
      reportId: offers?.driverDetails?.id??'',
      otherUserId: '',
      isButtonEnabled: offers?.isButtonEnabled,
      hasBottomSide: true,
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(children: [
                      Row(
                        children: [
                          ProfilePictureWidget(
                            rating:(offers?.driverDetails?.rating?.average??0).toInt(),
                            image: offers?.driverDetails?.picture??'',
                            hasStories: false,
                            isVerified: offers?.driverDetails?.verifiedBadge,
                          ),
                          Sizer(),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Label(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text:
                                        "${_capitalize(offers?.driverDetails?.firstName)} ${_capitalize(offers?.driverDetails?.lastName)}",
                                        style: Styles.mediumText(),
                                      ),
                                    ),

                                  ],
                                ),
                                Row(
                                  children: [
                                    Label(
                                      text:
                                      ' (${_formatNumber(offers?.driverDetails?.countTrips?.toStringAsFixed(0) ?? '0', context)})${context.isArabic?'رحلات': ' Trips'}',
                                      style: Styles.smallText(),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 18, color: Colors.yellow),
                                        Label(
                                          text:
                                          ' (${_formatNumber(offers?.driverDetails?.rating?.average?.toStringAsFixed(1) ?? '0', context)}/${_formatNumber(offers?.driverDetails?.rating?.count?.toStringAsFixed(1) ?? '0', context)})',
                                          style: Styles.smallText(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Label(
                                        text: context.isArabic
                                            ? offers?.driverDetails?.vehicleDetails?.brandAr ?? ''
                                            : offers?.driverDetails?.vehicleDetails?.brandEn ??
                                            '',
                                        style: Styles.mediumText(
                                            fontSize: 24
                                        )),
                                    Label(
                                        text: ' - ',
                                        style: Styles.mediumText()),
                                    Label(
                                        text: context.isArabic
                                            ? offers?.driverDetails?.vehicleDetails?.modelAr ?? ''
                                            : offers?.driverDetails?.vehicleDetails?.modelEn ??
                                            '',
                                        style: Styles.mediumText(
                                            fontSize: 24
                                        )
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                      Sizer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TripLocationWidget(isFrom: true, title: offers?.tripDetails?.location
                              ?.fromTitle ??
                              'From Location',fontSize:28),
                          TripLocationWidget(isFrom: false, title: offers?.tripDetails?.location
                              ?.toTitle ??
                              'Cairo International Airport',fontSize:28),
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
                    ])),
                const Sizer(width: 32),
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     // Expanded(
                    //     //   flex: 7,
                    //     //   child: Column(
                    //     //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     //     children: [
                    //     //       TripLocationWidget(isFrom: true, title: offers?.tripDetails?.location
                    //     //           ?.fromTitle ??
                    //     //           'Cairo International Airport',fontSize:28),
                    //     //       TripLocationWidget(isFrom: false, title: offers?.tripDetails?.location
                    //     //           ?.toTitle ??
                    //     //           'Cairo International Airport',fontSize:28),
                    //     //       (offers?.tripDetails?.note==null||offers?.tripDetails?.note=='')?Label(
                    //     //         text:
                    //     //         '${LocaleKeys.passenger.localize} ${_formatNumber((offers?.tripDetails?.passengers ?? 0).toString(), context)}',
                    //     //         style: Styles.mediumText(),
                    //     //       ):Label(
                    //     //         text:
                    //     //         '${LocaleKeys.cargoDescription.localize}:\n ${offers?.tripDetails?.note}',
                    //     //         style: Styles.mediumText(),
                    //     //         maxLines: 2,
                    //     //       ),
                    //     //     ],
                    //     //   ),
                    //     // ),
                    //     Expanded(
                    //         flex: 3,
                    //         child: Column(
                    //           children: [
                    //             // offers?.category?.picture != null
                    //             //     ? Image.asset(Assets.rideIcon,
                    //             //     width: 40, height: 40, fit: BoxFit.cover)
                    //             //     :
                    //             ImageFromInternet(
                    //                 image:
                    //                 offers?.subCategory?.pictureUrl ?? '',
                    //                 width: 40,
                    //                 height: 40,
                    //                 fit: BoxFit.contain),
                    //             Label(
                    //                 text: context.isArabic
                    //                     ? (offers?.subCategory?.nameAr ?? '')
                    //                     : (offers?.subCategory?.nameEn ?? ''),
                    //                 style: Styles.mediumText(fontSize: 25))
                    //           ],
                    //         )),
                    //   ],
                    // ),
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
                    Column(
                      children: [
                        // offers?.category?.picture != null
                        //     ? Image.asset(Assets.rideIcon,
                        //     width: 40, height: 40, fit: BoxFit.cover)
                        //     :
                        ImageFromInternet(
                            image:
                            offers?.tripDetails?.category?.picture ?? '',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain),
                        Label(
                            text: context.isArabic
                                ? (offers?.tripDetails?.category?.nameAr ?? '')
                                : (offers?.tripDetails?.category?.nameEn ?? ''),
                            style: Styles.mediumText(fontSize: 25))
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Sizer(),
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
    );
  }
}