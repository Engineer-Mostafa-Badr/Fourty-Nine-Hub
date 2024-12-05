import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/maps/map_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/success_request_trip_model/success_request_trip_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_offer_model/trip_request_offer_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/address_search_params_entity.dart';
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
                      child: AcceptOrDeclineTrip(
                    tripId: state.data!.id ?? "",
                    model: state.data!,
                    // overlayEntry: overlayEntry,
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
                                                child: Text(
                                                  "EGP ${state.model.price}",
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .QUANTITY_COLOR,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                            // context
                                            //     .read<ShowOffersCubit>()
                                            //     .showOffers();
                                            context
                                                .read<LocationSocketCubit>()
                                                .nearbyDriversEmit(
                                                    tripId:
                                                        state.model.trip?.id ??
                                                            "",
                                                    location: state
                                                            .model
                                                            .trip
                                                            ?.riderLocation
                                                            ?.coordinates ??
                                                        [],
                                                    subcategoryId: state
                                                            .model
                                                            .trip
                                                            ?.subCategoryId ??
                                                        "");

                                            //                                   BlocProvider(
                                            //   create: (context) =>
                                            //       RaiseFareCubit(repository: serviceLocator()),
                                            // ),
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return BlocProvider(
                                                  create: (context) =>
                                                      RaiseFareCubit(
                                                          repository:
                                                              serviceLocator()),
                                                  child:
                                                      RequestButtonSheetWidget(
                                                    model: state.model,
                                                  ),
                                                );
                                              },
                                            );
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
            Expanded(
                child: Stack(
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
            )),
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
  Widget build(BuildContext context) {
    var raiseFareCubit = context.read<RaiseFareCubit>();
    return Container(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.model.closerDrivers?.length ?? 0} ${LocaleKeys.driversAreViewingYourRequest.tr()}",
                  style: Styles.mediumText(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: Stack(
                    children: [
                      ...List.generate(
                        widget.model.closerDrivers?.take(5).length ?? 0,
                        (index) {
                          log((10 + (index + 10)).toString(),
                              name: "lkdjflsdkjfldkjf");
                          spase = spase + 10;
                          return Positioned(
                            right: spase.toDouble(),
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    widget.model.closerDrivers?[index].userData
                                            ?.userPicture ??
                                        "",
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? AppColors.QUANTITY_COLOR
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    LocaleKeys.findingDrivers.tr(),
                    style: Styles.headerText(
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            raiseFareCubit.decreasePrice(newPrice: 3);
                            setState(() {});
                          },
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: raiseFareCubit.price != null
                                    ? AppColors.PRIMARY_COLOR
                                    : const Color(0xFF495563),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "-3",
                                style: Styles.mediumText(
                                  color: raiseFareCubit.price != null
                                      ? Colors.white
                                      : const Color(0xFF5E6A78),
                                  fontSize: 38,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Sizer(),
                      const Sizer(),
                      Column(
                        children: [
                          Text(
                            LocaleKeys.yourOffer.tr(),
                            style: Styles.mediumText(color: Colors.grey),
                          ),
                          const Sizer(
                            height: 5,
                          ),
                          Text(
                            "EGP ${(widget.model.trip?.price ?? 0) + (raiseFareCubit.currentPrice ?? 0)}",
                            style: Styles.headerText(
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ],
                      ),
                      const Sizer(),
                      const Sizer(),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            raiseFareCubit.increasePrice(newPrice: 3);
                            setState(() {});
                          },
                          child: Container(
                            height: 60,
                            width: double.infinity,
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
                        color: const Color(0xFF0E4669),
                        borderRadius: BorderRadius.circular(13)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        const Sizer(),
                        Flexible(
                          child: Text(
                            "${LocaleKeys.travelTime.tr()}: ~${formatDuration(widget.model.trip?.duration ?? 0)} , ${LocaleKeys.Distance.tr()}: ${formatDistance(widget.model.trip?.distance ?? 0)}",
                            style: Styles.mediumText(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        const Sizer(),
                      ],
                    ),
                  ),
                  const Sizer(),
                  GestureDetector(
                    onTap: () {
                      raiseFareCubit.update(
                          tripId: widget.model.trip?.id ?? "",
                          tripPrice: widget.model.trip?.price ?? 0);
                      setState(() {});
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: raiseFareCubit.price != null
                              ? AppColors.PRIMARY_COLOR
                              : const Color(0xFF495563),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          LocaleKeys.raiseFare.tr(),
                          style: Styles.mediumText(
                            color: raiseFareCubit.price != null
                                ? Colors.white
                                : const Color(0xFF5E6A78),
                            fontSize: 38,
                          ),
                        ),
                      ),
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
                                color: const Color(0xFFA1A4AF)),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.credit_card,
                                color: Colors.black,
                              ),
                              Text(
                                "EGP ${(widget.model.trip?.price ?? 0) + (raiseFareCubit.currentPrice ?? 0)} ${widget.model.trip?.paymentMethod}",
                                style: Styles.mediumText(
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
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

class AcceptOrDeclineTrip extends StatelessWidget {
  const AcceptOrDeclineTrip({
    super.key,
    required this.model,
    required this.tripId,
  });
  final TripRequestOfferModel model;
  final String tripId;
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
            if ((model.comfort ?? false))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: (model.comfort ?? false) ? Colors.green : Colors.red,
                ),
                child: Text(
                  LocaleKeys.comfort.tr(),
                  style: Styles.mediumText(),
                ),
              ),
            const Sizer(),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(model.profilePicture ?? ""),
                        fit: BoxFit.cover,
                      )),
                ),
                const Sizer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          model.firstName ?? "",
                          style: Styles.mediumText(color: Colors.black),
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(
                          "${model.averageRating ?? ""} ",
                          style: Styles.mediumText(color: Colors.black),
                        ),
                        Text(
                          "(${model.allCountTrip} ${LocaleKeys.rider.tr()})",
                          style: Styles.mediumText(
                              color: Colors.grey, fontSize: 26),
                        ),
                      ],
                    ),
                    Text(
                      model.model ?? "",
                      style: Styles.mediumText(color: Colors.black),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      formatDuration(model.arrivalTimeToClient ?? 0),
                      style:
                          Styles.headerText(color: Colors.black, fontSize: 30),
                    ),
                    Text(
                      formatDistance(model.distance ?? 0),
                      style:
                          Styles.headerText(color: Colors.black, fontSize: 30),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              "EGP ${model.priceOffer ?? 0}",
              style: Styles.headerText(color: Colors.black, fontSize: 50),
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
                              tripId: tripId,
                            );
                        context.read<ShowOffersCubit>().overlayEntry!.remove();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          LocaleKeys.decline.tr(),
                          style: Styles.mediumText(color: Colors.white),
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
                          tripId: tripId,
                          subCategory: model.subcategoryId ?? "");
                      if (context.read<ShowOffersCubit>().overlayEntry !=
                          null) {
                        context.read<ShowOffersCubit>().overlayEntry!.remove();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          LocaleKeys.Accept.tr(),
                          style: Styles.mediumText(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
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

// // [lklkkkkkkkkkkkkkkkkkkkkkkjjjjjjjjjjjjj] {
// //   status: true,
// //   data: {
// //     price: 235.75,
// //     lowestFare: null,
// //     from: شارع القنال 92، حي المعادي 11728،
// //     مصر, to: شارع العيسي ، حي مصر الجديدة 11، مصر, calculate_b: 0, polyline: {coordinates: , type: LineString}}}
