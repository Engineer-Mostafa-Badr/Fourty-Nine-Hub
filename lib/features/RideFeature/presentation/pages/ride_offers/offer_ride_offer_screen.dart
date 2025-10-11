import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/common/global_card.dart';
import 'package:fourtyninehub/core/widget/common/profile_picture_widget.dart';
import 'package:fourtyninehub/core/widget/common/trip_location_widget.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/banner.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/shared_web_socket.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../domain/entities/get_client_offer_trips_entity.dart';
import '../../controllers/client_trips_cubit/client_trips_cubit.dart';
import '../loading_dashboard/loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class OfferRideOfferScreen extends StatefulWidget {
  final String type;

  const OfferRideOfferScreen({
    super.key,
    required this.type,
  });

  @override
  State<OfferRideOfferScreen> createState() => _OfferRideOfferScreenState();
}

class _OfferRideOfferScreenState extends State<OfferRideOfferScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'shipping') {
      context.read<ClientTripsCubit>().listenToUpdateOfferTripShipping();
    }
    if (widget.type == 'ride') {
      context.read<ClientTripsCubit>().listenToUpdateOfferTripNonSocket();
    }
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    SharedWebSocket.socket!.off(SocketIOListeners.rideUpdateUntrackedTrip);
    SharedWebSocket.socket!.off(SocketIOListeners.rideUpdateOfferShippingClientTrip);
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
                            .clientOfferTripsData
                            .isEmpty
                        ? Center(
                            child: Label(
                              text:
                                  LocaleKeys.youDontHaveAvailableOffer.localize,
                              // style:
                              //     TextStyle(color: Colors.red, fontSize: 18)
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: context
                                    .read<ClientTripsCubit>()
                                    .clientOfferTripsData
                                    .isEmpty
                                ? CustomEmptyWidget(label: context.isArabic?'لا يوجد لديك عروض':'You don\'t have any offers',)
                                :OlxPaginationWidget(
                              itemsPerPage: 3,
                              scrollController: _scrollController,
                              banners: bannersList,
                              loadPage: (page) {
                                if (widget.type == 'ride') {
                                  return context.read<ClientTripsCubit>().getClientOfferTrips();
                                }else{
                                  return context.read<ClientTripsCubit>().getClientOfferShippingTrips();
                                }
                                },

                              items: List.generate(
                                context
                                    .read<ClientTripsCubit>()
                                    .clientOfferTripsData.length,
                                    (index) {
                                  return ClientOfferWidget(
                                    offers: context
                                        .read<ClientTripsCubit>()
                                        .clientOfferTripsData[index],
                                    modeType: widget.type,
                                    onRefuseOffer: (String id) {
                                      // context.read<ClientTripsCubit>().refuseClientShippingTrip(id,context);
                                      setState(() {});
                                    },
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

class ClientOfferWidget extends StatelessWidget {
  final String modeType;
  final ClientOfferTripEntity? offers;
  final Function(String id) onRefuseOffer;

  const ClientOfferWidget(
      {super.key,
      required this.modeType,
      this.offers,
      required this.onRefuseOffer});

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
    return GlobalCard(subcategoryId: '',
      isView: offers?.isRead??false,
      phone: '',
      reportId: '',
      otherUserId: '',
    onTap: (){
      ManageVibration.vibrate();
      if((offers?.isRead??false)==false){
        if(modeType == 'ride')context.read<ClientTripsCubit>().readNonTrackingOffer(offers?.id??'');
        if(modeType == 'shipping')context.read<ClientTripsCubit>().readLoadingOffer(offers?.id??'');
      }
    },
    body: Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Row(
                    children: [
                      ClickableWidget(
                        onTap: (){},
                        child: ProfilePictureWidget(
                            rating:(offers?.driverDetails?.rating?.average??0).toInt(),
                          image: offers?.driverDetails?.pictureUrl??'',
                          hasStories: false,
                        ),
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
                        ],
                      ),

                    ]),
              ),
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
                            offers?.price ?? 0, context),
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
                          offers?.tripDetails?.subcategory?.pictureUrl ?? '',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain),
                      Label(
                          text: context.isArabic
                              ? (offers?.tripDetails?.subcategory?.nameAr ?? '')
                              : (offers?.tripDetails?.subcategory?.nameEn ?? ''),
                          style: Styles.mediumText(fontSize: 25))
                    ],
                  ),
                ],
              ),

              // const Sizer(width: 32),
              // Expanded(
              //   flex: 8,
              //   child: IntrinsicWidth(
              //     child: Column(
              //       spacing: 4,
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Expanded(
              //               flex: 7,
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Row(
              //                     spacing: 5,
              //                     children: [
              //                       Expanded(
              //                         flex: 1,
              //                         child: Image.asset(Assets.rideFrom,
              //                             width: 24, height: 24),
              //                       ),
              //                       Expanded(
              //                           flex: 8,
              //                           child: Label(
              //                               text: offers?.tripDetails?.location
              //                                   ?.fromTitle ??
              //                                   'Cairo International Airport',
              //                               style: Styles.headerText()))
              //                     ],
              //                   ),
              //                   Row(
              //                     spacing: 5,
              //                     children: [
              //                       Expanded(
              //                           flex: 1,
              //                           child: Image.asset(Assets.rideTo,
              //                               width: 24, height: 24)),
              //                       Expanded(
              //                           flex: 8,
              //                           child: Label(
              //                               text: offers?.tripDetails?.location
              //                                   ?.toTitle ??
              //                                   'Cairo International Airport',
              //                               style: Styles.mediumText(
              //                                   fontWeight: FontWeight.w300)))
              //                     ],
              //                   ),
              //                   if (modeType == 'ride')
              //                     Label(
              //                         text:
              //                         '${LocaleKeys.passenger.localize}  $passengersCount',
              //                         style: Styles.mediumText())
              //                 ],
              //               ),
              //             ),
              //             Expanded(
              //                 flex: 3,
              //                 child: Column(
              //                   children: [
              //                     ImageFromInternet(
              //                         image: offers!
              //                             .tripDetails!.subcategory!.pictureUrl!,
              //                         width: 40,
              //                         height: 40,
              //                         fit: BoxFit.contain),
              //                     Label(
              //                         text: isArabic
              //                             ? (offers?.tripDetails?.subcategory
              //                             ?.nameAr ??
              //                             '')
              //                             : (offers?.tripDetails?.subcategory
              //                             ?.nameEn ??
              //                             ''),
              //                         style: Styles.mediumText(fontSize: 25))
              //                   ],
              //                 )),
              //           ],
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             Label(
              //               text: formatPrice(
              //                   offers?.isFromSocket == true
              //                       ? offers?.newOfferPrice ??
              //                       offers?.newOfferPrice ??
              //                       300
              //                       : offers?.newOfferPrice ?? 300,
              //                   context),
              //               style: Styles.mediumText(fontWeight: FontWeight.w700),
              //             ),
              //             const Sizer(width: 4),
              //             Label(
              //                 text: LocaleKeys.egp.tr(),
              //                 style: Styles.mediumText(
              //                     color: AppColors.SECONDARY_COLOR,
              //                     fontWeight: FontWeight.w700))
              //           ],
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Label(
              //               text:
              //               formatTimeOnly(offers?.tripDetails?.date, context),
              //               style: Styles.mediumText(
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ),
              //             Label(
              //               text: formatPickupDate(
              //                   offers?.tripDetails?.date, context),
              //               style: Styles.mediumText(
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ),
              //           ],
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Expanded(
              //               child: AppButton(
              //                   height: 30,
              //                   radius: 15,
              //                   label: LocaleKeys.Accept.tr(),
              //                   onPressed: () {
              //                     ManageVibration.vibrate();
              //                     modeType == 'ride'
              //                         ? context
              //                         .read<ClientTripsCubit>()
              //                         .acceptClientTrip(offers?.id ?? "")
              //                         : context
              //                         .read<ClientTripsCubit>()
              //                         .acceptClientShippingTrip(
              //                         offers?.id ?? "");
              //                     onRefuseOffer(offers?.id ?? "");
              //                   },
              //                   backColor: AppColors.PRIMARY_COLOR),
              //             ),
              //             const Sizer(),
              //             Expanded(
              //               child: AppButton(
              //                   radius: 15,
              //                   height: 30,
              //                   label: LocaleKeys.refuse.tr(),
              //                   style: Styles.mediumText(
              //                       color: Colors.white, fontSize: 23),
              //                   onPressed: () async {
              //                     ManageVibration.vibrate();
              //                     modeType == 'ride'
              //                         ? await context
              //                         .read<ClientTripsCubit>()
              //                         .refuseClientTrip(offers?.id ?? "")
              //                         : await context
              //                         .read<ClientTripsCubit>()
              //                         .refuseClientShippingTrip(
              //                         offers?.id ?? "", context);
              //                     onRefuseOffer(offers?.id ?? "");
              //                   },
              //                   backColor: AppColors.SECONDARY_COLOR_DARK2),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
          Sizer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                text:
                formatTimeOnly(offers?.tripDetails?.date, context),
                style: Styles.mediumText(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Label(
                text: formatPickupDate(
                    offers?.tripDetails?.date, context),
                style: Styles.mediumText(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Sizer(),
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
                      modeType == 'ride'
                          ? context
                          .read<ClientTripsCubit>()
                          .acceptClientTrip(offers?.id ?? "")
                          : context
                          .read<ClientTripsCubit>()
                          .acceptClientShippingTrip(
                          offers?.id ?? "");
                      onRefuseOffer(offers?.id ?? "");
                    },
                    backColor: AppColors.PRIMARY_COLOR),
              ),
              const Sizer(),
              Expanded(
                child: AppButton(
                    radius: 15,
                    height: 30,
                    label: LocaleKeys.refuse.tr(),
                    style: Styles.mediumText(
                        color: Colors.white, fontSize: 23),
                    onPressed: () async {
                      ManageVibration.vibrate();
                      modeType == 'ride'
                          ? await context
                          .read<ClientTripsCubit>()
                          .refuseClientTrip(offers?.id ?? "")
                          : await context
                          .read<ClientTripsCubit>()
                          .refuseClientShippingTrip(
                          offers?.id ?? "", context);
                      onRefuseOffer(offers?.id ?? "");
                    },
                    backColor: AppColors.SECONDARY_COLOR_DARK2),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
