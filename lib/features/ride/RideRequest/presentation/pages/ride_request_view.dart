import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/maps/map_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/success_request_trip_model/success_request_trip_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_offer_model/trip_request_offer_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/address_search_params_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/cancel_trip_client_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/TripCubit/drivers_nearBy_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/location_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/offer_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/raise_fare_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/show_offers_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/animated_accept_button.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/rider_banner.dart';
import 'package:fourtyninehub/features/ride/rider_shipping/presentation/pages/create_trip_rider.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/sub_category.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card_selected.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../routes/routes.dart';

class RideRequestView extends StatefulWidget {
  const RideRequestView({super.key});

  @override
  State<RideRequestView> createState() => _RideRequestViewState();
}

class _RideRequestViewState extends State<RideRequestView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();

    // context.read<>()
  }

  // OverlayEntry? overlayEntry;
  @override
  Widget build(BuildContext context) {
    // context.read<GetAllTripRiderCubit>().getAllTrip();
    var getTripInfoCubit = context.read<GetTripInfoCubit>();
    return SingleChildScrollView(
      child: BlocListener<ShowOffersCubit, RiderState>(
        listener: (context, state) {
          if (state is SuccessGetOfferDataState) {
            if (state.data != null) {
              var overlay = Overlay.of(context);
              var overlayEntry = OverlayEntry(
                builder: (context) => Positioned(
                  top: 30,
                  left: 10,
                  right: 10,
                  child: Material(
                      child: BlocProvider(
                    create: (context) => GetCurrencyCubit(serviceLocator()),
                    child: AcceptOrDeclineTrip(
                      tripId: state.data!.id ?? "",
                      model: state.data!,
                    ),
                  )),
                ),
              );
              context.read<ShowOffersCubit>().overlayEntry = overlayEntry;
              overlay.insert(overlayEntry);
              Future.delayed(const Duration(seconds: 15), () {
                overlayEntry.remove();
              });
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<GetCateogryRiderCubit, RiderState>(
              builder: (context, state) {
                if (state is SuccessGetCateogyRider) {
                  log(
                      (state.model.mainCategory?.isDriverApproved ?? false)
                          .toString(),
                      name:
                          "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
                  return Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RiderBanner(
                            model: state.model,
                            favoriteName: "Driver",
                          )),
                      (state.model.mainCategory?.isDriverApproved ?? false)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DashboardBanner(
                                onTap: () => context.push(Routes.ALLTRIPRIDER),
                                // onTap: () {
                                // },
                                title: LocaleKeys.rideDashboard.tr(),
                                subTitle:
                                    Labels.driverDashboardBannerDiscription,
                                route: Routes.DOCTORDASHBOARD,
                              ),
                            )
                          : ((state.model.mainCategory?.isDriver ?? true) ==
                                      true &&
                                  (state.model.mainCategory?.isDriverApproved ??
                                          false) ==
                                      false)
                              ? Container()
                              : GestureDetector(
                                  // onTap: () => context
                                  //     .push(Routes.SHIPPING_REGISTER),
                                  onTap: () {
                                    context.push(Routes.SHIPPING_REGISTER);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      LocaleKeys.serveClientsByClickRegister
                                          .tr(),
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: FormField(
                          builder: (field) {
                            return BlocBuilder<GetCateogryRiderCubit,
                                RiderState>(
                              builder: (context, state) {
                                log(state.toString(), name: "lssss");
                                if (state is SuccessGetCateogyRider) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildMainCategoriesWidget(
                                        category: MainCategoryEntity(
                                            nameEn: state
                                                .model.mainCategory?.nameEn,
                                            id: state.model.mainCategory
                                                    ?.mainCategoryId ??
                                                "",
                                            name: LocaleKeys
                                                .chooseYourFavoriteSubCategory
                                                .tr(),
                                            image: state.model.mainCategory
                                                    ?.cover ??
                                                "",
                                            isFavorite: true,
                                            total: state.model.mainCategory
                                                    ?.driverLength ??
                                                0,
                                            cover: state.model.mainCategory
                                                    ?.cover ??
                                                "",
                                            banner: state.model.mainCategory
                                                    ?.banner ??
                                                "",
                                            subcategories: sortList(
                                                    state.model.subCategories)!
                                                .map(
                                                  (e) => SubCategoryEntity(
                                                      id: e.subCategoryId!,
                                                      numberOfContent:
                                                          e.driverCount,
                                                      image: e.picture!,
                                                      isFavorite:
                                                          e.isFavorite ?? false,
                                                      nameAr:
                                                          e.subCategoryNameAr!,
                                                      nameEn:
                                                          e.subCategoryNameEn!),
                                                )
                                                .toList()),
                                      ),
                                      if (field.hasError)
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Text(
                                                field.errorText ?? "",
                                                style: Styles.mediumText(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        )
                                    ],
                                  );
                                } else {
                                  return Container(
                                    width: 12,
                                    height: 12,
                                    color: Colors.red,
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                      BlocBuilder<RiderTripReelTimeCubit, RiderState>(
                        builder: (context, state) {
                          if (state is ViewPickTripDataState) {
                            log(state.toString(),
                                name: "lskdjflskdjflkjfdlkddddd");
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 17),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // SizedBox(
                                      //   width: 5,
                                      // ),
                                      Text(
                                        LocaleKeys.comfort.tr(),
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Switch(
                                        value: getTripInfoCubit.model.comfort ??
                                            false,
                                        onChanged: (value) {
                                          getTripInfoCubit.comfort(value);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Sizer(),
                                  const Sizer(height: 20),
                                  const Sizer(height: 20),
                                  const Sizer(height: 20),
                                  BlocBuilder<GetTripInfoCubit, RiderState>(
                                    builder: (context, state) {
                                      if (state is SuccessGetTripInfoState) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.flash_on),
                                                  Text(
                                                    LocaleKeys.autoAccept.tr(),
                                                    style: Styles.mediumText(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const Spacer(),
                                                  Switch(
                                                    activeColor:
                                                        AppColors.PRIMARY_COLOR,
                                                    value: getTripInfoCubit
                                                            .model.autoAccept ??
                                                        false,
                                                    onChanged: (value) {
                                                      getTripInfoCubit
                                                          .autoAccept(value);
                                                      setState(() {});
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Sizer(),
                                            DefaultTextFormField(
                                              currentController:
                                                  TextEditingController(),
                                              hint:
                                                  LocaleKeys.offerYourFare.tr(),
                                              readOnly: (getTripInfoCubit
                                                      .model.autoAccept ??
                                                  false),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if ((double.tryParse(
                                                            value.toString()) ??
                                                        0) >
                                                    (state.model.lowestFare ??
                                                        0)) {
                                                  return "${LocaleKeys.MinimumFareIs.tr()} ${state.model.lowestFare}";
                                                }
                                                return null;
                                              },
                                              hintColor: Colors.grey,
                                              suffixIcon: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.credit_card),
                                                  Sizer(
                                                    width: 6,
                                                  ),
                                                  Sizer()
                                                ],
                                              ),
                                              prefixIcon: Container(
                                                alignment: (getTripInfoCubit
                                                            .model.autoAccept ??
                                                        false)
                                                    ? Alignment.center
                                                    : null,
                                                margin: EdgeInsets.only(
                                                    top: (getTripInfoCubit.model
                                                                .autoAccept ??
                                                            false)
                                                        ? 0
                                                        : 13,
                                                    left: 8,
                                                    right: 8),
                                                child: Row(
                                                  children: [
                                                    BlocBuilder<
                                                        GetCurrencyCubit,
                                                        GetCurrencyState>(
                                                      builder:
                                                          (context, state) {
                                                        return Text(
                                                          context.isArabic
                                                              ? BlocProvider.of<
                                                                          GetCurrencyCubit>(
                                                                      context)
                                                                  .currnecyAr
                                                              : BlocProvider.of<
                                                                          GetCurrencyCubit>(
                                                                      context)
                                                                  .currnecyEn,
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .QUANTITY_COLOR,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        );
                                                      },
                                                    ),
                                                    Text(
                                                      "${state.model.price}",
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .QUANTITY_COLOR,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Sizer(),
                                            Container(
                                              // padding:
                                              // EdgeInsets.symmetric(horizontal: 15),
                                              width: double.infinity,
                                              height: 46,
                                              decoration: BoxDecoration(
                                                  // color: Color(0xFF0E4669),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          13)),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.info_outline,
                                                    color: Colors.black,
                                                  ),
                                                  const Sizer(),
                                                  Flexible(
                                                    child: Text(
                                                      "${LocaleKeys.travelTime.tr()}: ~${formatDuration(state.model.duration!.toInt())} , ${LocaleKeys.Distance.tr()}: ${formatDistance(state.model.distance!.toInt())}",
                                                      style: Styles.mediumText(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  const Sizer(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  const Sizer(),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: AppButton(
                                          height: 40,
                                          label: LocaleKeys.premiumRequest.tr(),
                                          style: Styles.headerText(
                                              color: Colors.white),
                                          onPressed: () {},
                                        ),
                                      ),
                                      // const Gap(6),
                                      const SizedBox(width: 6),
                                      BlocConsumer<RequestRiderTripCubit,
                                          RiderState>(
                                        listener: (context, state) {
                                          log(state.toString(),
                                              name: "ldsjflskdjflskdfjlskjf");
                                          if (state
                                              is SuccessRequestTripState) {
                                            context
                                                .read<ShowOffersCubit>()
                                                .showOffers();
                                            context
                                                .read<LocationSocketCubit>()
                                                .nearbyDriversEmit(
                                                    tripId:
                                                        state.model.trip?.id ??
                                                            "",
                                                    location: state
                                                            .model
                                                            .trip
                                                            ?.startLocation
                                                            ?.coordinates ??
                                                        [],
                                                    subcategoryId: state
                                                            .model
                                                            .trip
                                                            ?.subCategoryId ??
                                                        "");
                                            Navigator.pop(context);
                                            print("Poped");
                                            // showModalBottomSheet(
                                            //   context: context,
                                            //   isDismissible:
                                            //       false, // Prevent tapping outside to dismiss
                                            //   enableDrag:
                                            //       false, // Prevent drag to dismiss
                                            //   isScrollControlled:
                                            //       true, // Control scroll behavior
                                            //   builder: (context) {
                                            //     return WillPopScope(
                                            //       onWillPop: () async =>
                                            //           false, // Prevent back button dismiss
                                            //       child: BlocProvider(
                                            //         create: (context) =>
                                            //             RaiseFareCubit(
                                            //           repository:
                                            //               serviceLocator(),
                                            //         ),
                                            //         child: ConstrainedBox(
                                            //           constraints:
                                            //               BoxConstraints(
                                            //             maxHeight: MediaQuery
                                            //                         .of(context)
                                            //                     .size
                                            //                     .height *
                                            //                 0.9, // Adjust height to fit screen
                                            //           ),
                                            //           child:
                                            //               RequestButtonSheetWidget(
                                            //             model: state.model,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     );
                                            //   },
                                            // );
                                          }
                                        },
                                        builder: (context, state) {
                                          log(state.toString(),
                                              name:
                                                  "lskdddddddddddddddddddddddddddd");
                                          return Flexible(
                                            child: AppButton(
                                              height: 40,
                                              backColor:
                                                  const Color(0xFF0B1135),
                                              label: LocaleKeys.request.tr(),
                                              style: Styles.headerText(
                                                  color: Colors.white),
                                              onPressed: () async {},
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                          return CreateTripRider();
                        },
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
            Stack(
              children: [
                Positioned.fill(
                  child: BlocProvider(
                    create: (BuildContext context) =>
                        serviceLocator<RiderequestCubit>(),
                    child: BlocBuilder<RiderequestCubit, RiderequestState>(
                      builder: (context, state) {
                        final rideCubit = context.read<RiderequestCubit>();
                        if (state.fromAddress != null &&
                            state.toAddress != null) {
                          return MapPicker(
                            lat: state.fromAddress?.lat,
                            lng: state.fromAddress?.lng,
                            destLat: state.toAddress?.lat,
                            destLng: state.toAddress?.lng,
                          );
                        }
                        return MapPicker(
                          lat: state.fromAddress?.lat,
                          lng: state.fromAddress?.lng,
                          onAddressPicked: (AddressSearchParamsEntity v) =>
                              rideCubit.selectPickUpLocation(item: v),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    left: 10,
                    child: DashboardBanner(
                      title: LocaleKeys.driverDashboard.tr(),
                      subTitle: LocaleKeys
                          .newTripsAreWaitingYouGoToDriverDashboardAndExploreMore
                          .tr(),
                      route: Routes.RIDERDASHBOARD,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(int totalSeconds) {
    if (totalSeconds >= 3600) {
      // إذا كان العدد يساوي أو أكبر من ساعة (3600 ثانية)
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      return '$hours h, $minutes min';
    } else if (totalSeconds >= 60) {
      // إذا كان العدد يساوي أو أكبر من دقيقة (60 ثانية)
      int minutes = totalSeconds ~/ 60;
      int seconds = totalSeconds % 60;
      return '$minutes min, $seconds s';
    } else {
      // إذا كان العدد أقل من دقيقة
      return '$totalSeconds s';
    }
  }

  String formatDistance(int meters) {
    if (meters >= 1000) {
      // تحويل الأمتار إلى كيلومترات
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(2)} km';
    } else {
      // إذا كان العدد أقل من 1000 متر
      return '$meters m';
    }
  }

  Widget _buildMainCategoriesWidget({
    required MainCategoryEntity category,
  }) {
    // final shippingCubit = context.read<ShippingCubit>();
    final riderCubit = context.read<RiderTripReelTimeCubit>();
    final categryId = context.read<GetCateogryRiderCubit>();
    final ScrollController controller = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category.name != null)
          Label(
            text: category.name ?? "",
            style: Styles.headerText(fontWeight: FontWeight.w400),
          ),
        if (category.subcategories?.isNotEmpty ?? false)
          SizedBox(
            height: 80,
            child: ListView.separated(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      log(category.subcategories![index].id.toString(),
                          name: "lllllllllllllllllllllllllllll");
                      riderCubit.selectCateogry(category.subcategories![index]);
                      categryId.sortData(category.subcategories![index].id);
                      controller.jumpTo(0);
                      // context
                      //     .read<LocationSocketCubit>()
                      //     .sendSubCategoryId(category.subcategories![index].id);
                      // context
                      //     .read<LocationSocketCubit>()
                      //     .updateDriverLocationOn();
                      // if (select != null) {
                      //   if (select!.id == category.subcategories![index].id) {
                      //     log("lkjdslkjsdlkfjsdf kkkkkkkkk");

                      //     select = null;
                      // } else {
                      //   log("lkjdslkjsdlkfjsdf");
                      //   select = category.subcategories![index];
                      //   log(select?.id ?? "", name: "lkjdslkjsdlkfjsdf");
                      // }
                      // } else {
                      //   log("lkjdslkjsdlkfjsdf");
                      //   select = category.subcategories![index];
                      //   log(select?.id ?? "", name: "lkjdslkjsdlkfjsdf");
                      // }
                      // if (select != null) {
                      //   shippingCubit.seSubCategoryRequest(
                      //       subCategory: select!);
                      // }
                    });
                  },
                  child: SubcategoryCardSelected(
                    selected: riderCubit.subCategory == null
                        ? false
                        : riderCubit.subCategory!.id ==
                            category.subcategories![index].id,
                    // selected: select == null
                    //     ? false
                    //     : select!.id == category.subcategories![index].id,
                    mainCategory: category,
                    item: category.subcategories![index],
                    isSmallCard: true,
                    onChanged: (value) {
                      setState(() {
                        riderCubit
                            .selectCateogry(category.subcategories![index]);
                        log(category.subcategories![index].id.toString(),
                            name: "lllllllllllllllllllllllllllll");
                        riderCubit
                            .selectCateogry(category.subcategories![index]);
                        categryId.sortData(category.subcategories![index].id);
                        controller.jumpTo(0);
                        // if (select != null) {
                        //   if (select!.id == category.subcategories![index].id) {
                        //     select = null;
                        //   }
                        // } else {
                        //   select = category.subcategories![index];
                        // }
                        // if (select != null) {
                        //   shippingCubit.seSubCategoryRequest(
                        //       subCategory: select!);
                        // }
                        // log(select.toString());
                      });
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: category.subcategories?.length ?? 0,
            ),
          )
      ],
    );
  }

  SubCategoryEntity? getSelectedSubCategory(
      {required List<SubCategory>? categoryes}) {
    SubCategory? model = categoryes?.firstWhere(
      (element) => true,
    );
    // isSelect = true;
    return SubCategoryEntity(
        id: model?.subCategoryId ?? "",
        nameEn: model?.subCategoryNameEn ?? "",
        nameAr: model?.subCategoryNameAr ?? "",
        image: model?.picture ?? "",
        isFavorite: model?.isFavorite ?? false);
  }

  List<SubCategory>? sortList(List<SubCategory>? list) {
    // if (false) {
    //   int index =
    //       list!.indexWhere((model) => model.subCategoryId == widget.selectedId);
    //   if (index != -1) {
    //     return list.sublist(index) + list.sublist(0, index);
    //   }
    //   return list;
    // } else {
    return list;
  }
  // }
}

// class OfferYourFareWidet extends StatelessWidget {
//   const OfferYourFareWidet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//       width: double.infinity,
//       decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//       child: const Column(
//         children: [
//           // TextFormField(
//           //   textAlign: TextAlign.center,
//           //   decoration: InputDecoration(
//           //       fillColor: Colors.white,
//           //       filled: true,
//           //       hintStyle: Styles.headerText(fontSize: 40),
//           //       hintText: "EGP 300",
//           //       border: const UnderlineInputBorder()),
//           // ),
//           // const Spacer(),
//           // DefaultButton(
//           //   width: double.infinity,
//           //   label: "Done",
//           //   onPressed: () {},
//           // )
//         ],
//       ),
//     );
//   }
// }

class RequestButtonSheetWidget extends StatefulWidget {
  const RequestButtonSheetWidget({super.key, required this.model});
  final SuccessRequestTripModel model;

  @override
  State<RequestButtonSheetWidget> createState() =>
      _RequestButtonSheetWidgetState();
}

class _RequestButtonSheetWidgetState extends State<RequestButtonSheetWidget> {
  int spase = 10;
  @override
  void initState() {
    getCurrency();
    context.read<DriversNearbyCubit>().check(
        tripId: widget.model.trip?.id ?? "",
        location: widget.model.trip?.startLocation?.coordinates ?? [],
        subcategoryId: widget.model.trip?.subCategoryId ?? "",
        address: widget.model.trip?.fromTitle ?? "");
    super.initState();
  }

  void getCurrency() async {
    await BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();
  }

  @override
  Widget build(BuildContext context) {
    // log(widget.model.toJson().toString(), name: "lksdjflksjdlfkjsdlfkjslkdjflkdjf");
    var raiseFareCubit = context.read<RaiseFareCubit>();
    return BlocListener<CancelTripClientCubit, RiderState>(
      listener: (context, state) {
        log(state.toString(), name: "lkdjslkdfjslkdjflskdjf");
        if (state is SuccessCancelTripClientState) {
          context.pop();
          // context.read<RecordRideCubit>().stopRecord(
          //                     subcategoryId: widget.model.trip?.subCategoryId??"",
          //                     tripId: widget.model.trip?.id??""
          //                   );
        }
        if (state is FailureRiderState) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<DriversNearbyCubit, RiderState>(
                builder: (context, state) {
                  if (state is SuccessGetDriversNearState) {
                    return Row(
                      children: [
                        Text(
                          "${state.list.length} ${LocaleKeys.driversAreViewingYourRequest.tr()}",
                          style: Styles.mediumText(
                            color: !context.isDarkMode
                                ? AppColors.QUANTITY_COLOR
                                : Colors.white,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Stack(
                            children: [
                              ...List.generate(
                                state.list.take(5).length,
                                (index) {
                                  return Positioned(
                                    left: index * 15,
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              state.list[index].userData
                                                      ?.userPicture ??
                                                  "",
                                            ),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            // Sizer(h),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? AppColors.QUANTITY_COLOR
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      child: Container(
                        width: 36,
                        height: 5,
                        decoration: BoxDecoration(
                            color: AppColors.LIGHT_GRAY_COLOR,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    Text(
                      LocaleKeys.waitingForReplies.localize,
                      style: Styles.headerText(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Sizer(
                      height: 36,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 5,
                      child: const LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.PRIMARY_COLOR),
                      ),
                    ),
                    const Sizer(
                      height: 36,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            raiseFareCubit.decreasePrice();
                            setState(() {});
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                                color: raiseFareCubit.active
                                    ? AppColors.PRIMARY_COLOR
                                    : AppColors.LIGHT_GRAY_COLOR
                                        .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "-3",
                                style: raiseFareCubit.price != null
                                    ? Styles.mediumText(
                                        color: Colors.white,
                                        fontSize: 38,
                                      )
                                    : TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 1.5
                                          ..color = Colors.black,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              LocaleKeys.yourOffer.tr(),
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w600,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            const Sizer(
                              height: 5,
                            ),
                            BlocBuilder<GetCurrencyCubit, GetCurrencyState>(
                              builder: (context, state) {
                                return Text(
                                  "${context.isArabic ? BlocProvider.of<GetCurrencyCubit>(context).currnecyAr : BlocProvider.of<GetCurrencyCubit>(context).currnecyEn}${(raiseFareCubit.price?.toInt() ?? (widget.model.trip?.price?.toInt() ?? 0))}",
                                  style: Styles.headerText(
                                      fontSize: 56,
                                      color: context.isDarkMode
                                          ? Colors.white
                                          : Colors.black),
                                );
                              },
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            raiseFareCubit.increasePrice(
                                tripPrice: widget.model.trip?.price ?? 0);
                            setState(() {});
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                                color: AppColors.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "+3",
                                style: Styles.mediumText(
                                    color: Colors.white, fontSize: 38),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Sizer(),
                    const Sizer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.infinity,
                      height: 46,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(226, 244, 255, 1),
                          borderRadius: BorderRadius.circular(13)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF0E4669),
                          ),
                          const Sizer(),
                          Flexible(
                            child: Text(
                              "${LocaleKeys.travelTime.tr()}: ~${formatDuration(widget.model.trip?.duration ?? 0)} , ${LocaleKeys.Distance.tr()}: ${formatDistance(widget.model.trip?.distance ?? 0)}",
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                          const Sizer(),
                        ],
                      ),
                    ),
                    const Sizer(
                      height: 36,
                    ),
                    GestureDetector(
                      onTap: () {
                        raiseFareCubit.update(
                          tripId: widget.model.trip?.id ?? "",
                        );
                        setState(() {});
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: raiseFareCubit.active
                                ? AppColors.PRIMARY_COLOR
                                : AppColors.LIGHT_GRAY_COLOR.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: raiseFareCubit.price != null
                                ? Text(
                                    LocaleKeys.raiseFare.tr(),
                                    style: Styles.mediumText(
                                      color: Colors.white,
                                      fontSize: 38,
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      // Black stroke
                                      Text(
                                        LocaleKeys.raiseFare.localize,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 2.9
                                            ..color =
                                                Colors.black, // Stroke color
                                        ),
                                      ),
                                      // White fill
                                      Text(
                                        LocaleKeys.raiseFare.localize,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white, // Fill color
                                        ),
                                      ),
                                    ],
                                  )),
                      ),
                    ),
                    const Sizer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.Payment.tr(),
                              style: Styles.mediumText(
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.credit_card,
                                  color: Colors.black,
                                ),
                                const Sizer(),
                                BlocBuilder<GetCurrencyCubit, GetCurrencyState>(
                                  builder: (context, state) {
                                    return Text(
                                      "${context.isArabic ? BlocProvider.of<GetCurrencyCubit>(context).currnecyAr : BlocProvider.of<GetCurrencyCubit>(context).currnecyEn}${(raiseFareCubit.price?.toInt() ?? (widget.model.trip?.price?.toInt() ?? 0))} ${widget.model.trip?.paymentMethod}",
                                      style: Styles.mediumText(
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Sizer(
                      height: 24.h,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.green, width: 3.5)),
                        ),
                        const Sizer(),
                        Flexible(
                            child: Text(
                          widget.model.trip?.fromTitle.toString() ?? "",
                        ))
                      ],
                    ),
                    const Sizer(),
                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.blue, width: 3.5)),
                        ),
                        const Sizer(),
                        Flexible(
                            child: Text(
                          widget.model.trip?.toTitle.toString() ?? "",
                        ))
                      ],
                    ),
                    const Sizer(),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        print(widget.model.trip?.id);

                        showModalBottomSheet(
                          backgroundColor: context.isDarkMode
                              ? AppColors.QUANTITY_COLOR
                              : Colors.white,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.0),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      context.isArabic
                                          ? "هل تريد إلغاء الطلب ؟"
                                          : "Do you want to cancel the request?",
                                      textAlign: TextAlign.center,
                                      style: Styles.headerText(
                                          fontSize: 50,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Sizer(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .PRIMARY_COLOR_DARK,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              context.isArabic
                                                  ? "استمر في البحث"
                                                  : "Keep searching",
                                              style: Styles.mediumText(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 38,
                                              ),
                                            )),
                                          ),
                                        ),
                                        const Sizer(
                                          height: 24,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // log("message");
                                            await context
                                                .read<CancelTripClientCubit>()
                                                .cancelTripClient(
                                                  id: widget.model.trip?.id ??
                                                      "",
                                                );
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 60,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .LIGHT_GRAY_COLOR
                                                    .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              LocaleKeys.cancelRequest.tr(),
                                              style: Styles.mediumText(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 38,
                                              ),
                                            )),
                                          ),
                                        ),
                                        const Sizer(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.LIGHT_GRAY_COLOR.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          LocaleKeys.cancelRequest.tr(),
                          style: Styles.mediumText(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 38,
                          ),
                        )),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatDuration(int totalSeconds) {
    if (totalSeconds >= 3600) {
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      return '$hours h, $minutes min';
    } else if (totalSeconds >= 60) {
      int minutes = totalSeconds ~/ 60;
      return '$minutes min';
    } else {
      return '$totalSeconds s';
    }
  }

  String formatDistance(int meters) {
    if (meters >= 1000) {
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(2)} km';
    } else {
      return '$meters m';
    }
  }
}

class AcceptOrDeclineTrip extends StatefulWidget {
  const AcceptOrDeclineTrip({
    super.key,
    required this.model,
    required this.tripId,
  });
  final TripRequestOfferModel model;
  final String tripId;

  @override
  State<AcceptOrDeclineTrip> createState() => _AcceptOrDeclineTripState();
}

class _AcceptOrDeclineTripState extends State<AcceptOrDeclineTrip> {
  @override
  void initState() {
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OfferCubit, RiderState>(
      listener: (context, state) {
        log(state.toString(), name: "SuccessAcceptOfferRideState");
        if (state is SuccessAcceptOfferRideState) {
          context.pushAndRemoveUntil(
            Routes.TRIPINFOBYRIDERSCREEN,
            extra: state.model,
            (route) => false,
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((widget.model.comfort ?? false))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: (widget.model.comfort ?? false)
                      ? Colors.green
                      : Colors.red,
                ),
                child: Text(
                  LocaleKeys.comfort.tr(),
                  style: Styles.mediumText(),
                ),
              ),
            const Sizer(),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 16, top: 16),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image:
                                NetworkImage(widget.model.profilePicture ?? ""),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                ),
                const Sizer(),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.model.firstName ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Text(
                              "${widget.model.averageRating ?? ""} ",
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Text(
                              "(${widget.model.allCountTrip} ${LocaleKeys.rides.tr()})",
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 26),
                            ),
                          ],
                        ),
                        Text(
                          widget.model.model ?? "",
                          style: Styles.mediumText(
                              fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          formatDuration(widget.model.arrivalTimeToClient ?? 0),
                          style: Styles.headerText(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 30),
                        ),
                        Text(
                          formatDistance(widget.model.distance ?? 0),
                          style: Styles.headerText(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 30),
                        ),
                      ],
                    ),
                  ],
                ),
                // const Spacer(),
              ],
            ),
            const Sizer(
              height: 48,
            ),
            BlocBuilder<GetCurrencyCubit, GetCurrencyState>(
              builder: (context, state) {
                return Text(
                  "${context.isArabic ? BlocProvider.of<GetCurrencyCubit>(context).currnecyAr : BlocProvider.of<GetCurrencyCubit>(context).currnecyEn}${widget.model.priceOffer?.toInt() ?? 0}",
                  style: Styles.headerText(color: Colors.black, fontSize: 56),
                );
              },
            ),
            const Sizer(),
            Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      if (context.read<ShowOffersCubit>().overlayEntry !=
                          null) {
                        context.read<OfferCubit>().declineOffer(
                              tripId: widget.tripId,
                            );
                        context.read<ShowOffersCubit>().overlayEntry!.remove();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.LIGHT_GRAY_COLOR.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          LocaleKeys.decline.tr(),
                          style: Styles.mediumText(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                const Sizer(),
                Flexible(
                  child: GestureDetector(
                      onTap: () {
                        context.read<OfferCubit>().acceptOffer(
                            tripId: widget.tripId,
                            subCategory: widget.model.subcategoryId ?? "");
                        if (context.read<ShowOffersCubit>().overlayEntry !=
                            null) {
                          context
                              .read<ShowOffersCubit>()
                              .overlayEntry!
                              .remove();
                        }
                      },
                      child: const AnimatedAcceptButton()),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String formatDuration(int totalSeconds) {
    if (totalSeconds >= 3600) {
      // إذا كان العدد يساوي أو أكبر من ساعة (3600 ثانية)
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      return '$hours h, $minutes min';
    } else if (totalSeconds >= 60) {
      // إذا كان العدد يساوي أو أكبر من دقيقة (60 ثانية)
      int minutes = totalSeconds ~/ 60;
      // int seconds = totalSeconds % 60;
      return '$minutes min';
    } else {
      // إذا كان العدد أقل من دقيقة
      return '$totalSeconds s';
    }
  }

// , $seconds s
  String formatDistance(int meters) {
    if (meters >= 1000) {
      // تحويل الأمتار إلى كيلومترات
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(2)} km';
    } else {
      // إذا كان العدد أقل من 1000 متر
      return '$meters m';
    }
  }
}
