import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/maps/map_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/offer_data_model/offer_data_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/success_request_trip_model/success_request_trip_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/address_search_params_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/location_socket_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    // context.read<GetAllTripRiderCubit>().getAllTrip();
    var getTripInfoCubit = context.read<GetTripInfoCubit>();
    log(GoRouter.of(context).routerDelegate.currentConfiguration.toString(),
        name: "llllllllllllllllllllll");
    return SingleChildScrollView(
      child: BlocListener<ShowOffersCubit, RiderState>(
        listener: (context, state) {
          if (state is SuccessGetOfferDataState) {
            if (state.data != null) {
              final overlay = Overlay.of(context);
              final overlayEntry = OverlayEntry(
                builder: (context) => Positioned(
                  top: 30,
                  left: 10,
                  right: 10,
                  child: Material(
                      child: AcceptOrDeclineTrip(
                    model: state.data!,
                  )),
                ),
              );

              overlay.insert(overlayEntry);

              // Remove the overlay after some time or on user action
              Future.delayed(const Duration(seconds: 15), () {
                overlayEntry.remove();
              });
            }
          }
          log(state.toString(),
              name: "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<GetCateogryRiderCubit, RiderState>(
              builder: (context, state) {
                if (state is SuccessGetCateogyRider) {
                  return Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RiderBanner(
                            model: state.model,
                            favoriteName: "Driver",
                          )),
                      // SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DashboardBanner(
                          onTap: () => context
                              .push(Routes.ALLTRIPRIDER),
                          title: Labels.driverDashboard,
                          subTitle: Labels
                              .driverDashboardBannerDiscription,
                          route: Routes.DOCTORDASHBOARD,
                        ),
                      ),
                      //-------------------------------------------------------------
                      // GestureDetector(
                      //   // onTap: () => context
                      //   //     .push(Routes.SHIPPING_REGISTER),
                      //   onTap: () {
                      //     if (context.read<UserCubit>().isLoggedIn) {
                      //       context.push(Routes.SHIPPING_REGISTER);
                      //     } else {
                      //       // context.push(Routes.SHIPPING_REGISTER);
                      //       context.push(Routes.LOGIN);
                      //     }
                      //   },
                      //   child: const Padding(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: 10,
                      //     ),
                      //     child: Text(
                      //       "You can enjoy serving your clients using your car by clicking the register button above.",
                      //       style: TextStyle(
                      //         color: Colors.red,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                     // -------------------------------------------
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: FormField(
                          // validator: (value) {
                          //   return shippingcubit.validation(
                          //       message: "You have to select one sub category!",
                          //       condition:
                          //           shippingcubit.requestModel.subcategoryEntity == null);
                          // },
                          builder: (field) {
                            // log(select.toString());
                            return BlocBuilder<GetCateogryRiderCubit,
                                RiderState>(
                              builder: (context, state) {
                                log(state.toString(), name: "lssss");
                                if (state is SuccessGetCateogyRider) {
                                  // log(isSelect.toString(), name: "lkjdslkjsdlkfjsdf");
                                  // if (!isSelect) {
                                  //   if (widget.selectedId != null) {
                                  //     select = getSelectedSubCategory(
                                  //         categoryes: state.model.subCategories);
                                  //   }
                                  // }
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
                                            name:
                                                "Choose your favorite sub category!",
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
                                                      name:
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
                                      const Text(
                                        "Comfort",
                                        style: TextStyle(fontSize: 17),
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
                                  // const TripJoinGoogleMap(),
                                  const Sizer(height: 20),
                                  // Text('Starting Point', style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
                                  // const StartTextFieldAndFindButon(),
                                  const Sizer(height: 20),
                                  // Text('Destination Point', style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
                                  // const DestinationTextFieldAndFindButon(),
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
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Icon(Icons.flash_on),
                                                  Text(
                                                    "Auto Accept",
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
                                              hint: "Offer your fare",
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
                                                  return "Minimum fare is ${state.model.lowestFare}";
                                                }
                                                return null;
                                              },
                                              hintColor: Colors.grey,
                                              suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          const OfferYourFareWidet(),
                                                    );
                                                  },
                                                  child: const Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.credit_card),
                                                      Sizer(
                                                        width: 6,
                                                      ),
                                                      Text("Cash"),
                                                      Sizer()
                                                    ],
                                                  )),
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
                                                      "Travel time: ~${formatDuration(state.model.duration!.toInt())} , Distance: ${formatDistance(state.model.distance!.toInt())}",
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
                                          label: Labels.premiumRequest,
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
                                              label: Labels.request,
                                              style: Styles.headerText(
                                                  color: Colors.white),
                                              onPressed: () async {
                                                // final overlay =
                                                //     Overlay.of(context);
                                                // final overlayEntry =
                                                //     OverlayEntry(
                                                //   builder: (context) =>
                                                //       Positioned(
                                                //     top: 30,
                                                //     left: 10,
                                                //     right: 10,
                                                //     child: Material(
                                                //       child: AcceptOrDeclineTrip()
                                                //     ),
                                                //   ),
                                                // );

                                                // overlay?.insert(overlayEntry);

                                                // // Remove the overlay after some time or on user action
                                                // Future.delayed(
                                                //     const Duration(seconds: 5),
                                                //     () {
                                                //   overlayEntry.remove();
                                                // });

                                                // context
                                                //     .read<
                                                //         RequestRiderTripCubit>()
                                                //     .request(
                                                //         model:
                                                //             TripRequestModel());

                                                // context
                                                //     .read<LocationSocketCubit>()
                                                //     .sendSubCategoryId(context
                                                //             .read<
                                                //                 RiderTripReelTimeCubit>()
                                                //             .subCategory
                                                //             ?.id ??
                                                //         "");

                                                context
                                                    .read<GetTripInfoCubit>()
                                                    .getTripInfoRequest();
                                                // context
                                                //     .read<RequestRiderTripCubit>()
                                                //     .request(
                                                //         model: TripRequestModel());
                                                // if (widget.formKey.currentState!.validate()) {
                                                //   context.read<CreateTripCubit>().createTrip(
                                                //         model: RequestModel(
                                                //           date:
                                                //               "${date!.year}/${date!.month}/${date!.day}",
                                                //           deliveryPoint: deliveryPoint.text,
                                                //           description: decoration.text,
                                                //           offerPrice: offerPrice.text,
                                                //           // tripImages: tripImages,
                                                //           phone: phone.text,
                                                //           subcategoryEntity: select,
                                                //           receiptPoint: receiptPoint.text,
                                                //           time: "${time!.hour}:${time!.minute}",
                                                //         ),
                                                //       );
                                                // }
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  // Builder(builder: (context) {
                                  //   context.watch<StartingLocationCubit>();
                                  //   context.watch<DestinationLocationCubit>();
                                  //   return Visibility(
                                  //     visible: startingCubit.startingLocation != null &&
                                  //         destinationCubit.destinationLocation != null,
                                  //     // visible: true,
                                  //     child: const TripAndCarInformationV2(),
                                  //   );
                                  // })
                                ],
                              ),
                            );
                          }
                          return CreateTripRider();
                        },
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: DashboardBanner(
                      //   title: 'Driver Dashboard\n',
                      //   subTitle:
                      //       'New trips are waiting you, go to driver dashboard and explore more!',
                      //   route: Routes.RIDERDASHBOARD,
                      //                     ),
                      // )
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
                        // return Container(
                        //   decoration: const BoxDecoration(
                        //     color: Colors.red,
                        //     image: DecorationImage(image: AssetImage("assets/images/map_image.png"), fit: BoxFit.cover)
                        //   ),
                        // );
                      },
                    ),
                  ),
                ),
                const Positioned(
                bottom: 10,
                right: 10,
                left: 10,
                child: DashboardBanner(
                  title: 'Driver Dashboard\n',
                  subTitle:
                      'New trips are waiting you, go to driver dashboard and explore more!',
                  route: Routes.RIDERDASHBOARD,
                )),
              ],
            )
            ),
            // BlocProvider.value(
            //   value: serviceLocator<RiderequestCubit>(),
            //   child: const RideOptionsBottomSheet(),
            // ),
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
        Label(
          text: category.name,
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
        name: model?.subCategoryNameEn ?? "",
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

class OfferYourFareWidet extends StatelessWidget {
  const OfferYourFareWidet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: const Column(
        children: [
          // TextFormField(
          //   textAlign: TextAlign.center,
          //   decoration: InputDecoration(
          //       fillColor: Colors.white,
          //       filled: true,
          //       hintStyle: Styles.headerText(fontSize: 40),
          //       hintText: "EGP 300",
          //       border: const UnderlineInputBorder()),
          // ),
          // const Spacer(),
          // DefaultButton(
          //   width: double.infinity,
          //   label: "Done",
          //   onPressed: () {},
          // )
        ],
      ),
    );
  }
}

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
      //
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
                  "${widget.model.closerDrivers?.length ?? 0} drivers are viewing your request",
                  style: Styles.mediumText(color: Colors.black),
                ),
                const Spacer(),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: Expanded(
                    child: Stack(
                      children: [
                        // Positioned(
                        //   child: Container(
                        //     width: 25,
                        //     height: 25,
                        //     decoration: const BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.red,
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   left: 10,
                        //   child: Container(
                        //     width: 25,
                        //     height: 25,
                        //     decoration: const BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.orange,
                        //     ),
                        //   ),
                        // // ),
                        // Positioned(
                        //   left: 20,
                        //   child: Container(
                        //     width: 25,
                        //     height: 25,
                        //     decoration: const BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.blue,
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   left: 30,
                        //   child: Container(
                        //     width: 25,
                        //     height: 25,
                        //     decoration: const BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.green,
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   left: 40,
                        //   child: Container(
                        //     width: 25,
                        //     height: 25,
                        //     decoration: const BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.green,
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   left: 50,
                        //   child: Container(
                        //     width: 25,
                        //     height: 25,
                        //     decoration: const BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.green,
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   left: 60,
                        //   child: Container(
                        //     width: 25,
                        //     height: 25,
                        //     decoration: const BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.green,
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   left: 70,
                        //   child: Container(
                        //     width: 25,
                        //     height: 25,
                        //     decoration: const BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.red,
                        //     ),
                        //   ),
                        // )

                        ...List.generate(
                          widget.model.closerDrivers?.take(5).length ?? 0,
                          (index) {
                            // log(model.closerDrivers?.take(5).length.toString()??"99999",
                            //     name: "lskdfjlskf");
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
                                  // color: Colors.green,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.model.closerDrivers?[index]
                                              .userData?.userPicture ??
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
                  ),
                )
              ],
            ),
          ),
          // Sizer(h),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Finding drivers...",
                    style: Styles.headerText(
                      color: Colors.black,
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
                                color: const Color(0xFF495563),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "-3",
                                style: Styles.mediumText(
                                  color: const Color(0xFF5E6A78),
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
                            "Your offer",
                            style: Styles.mediumText(color: Colors.grey),
                          ),
                          const Sizer(
                            height: 5,
                          ),
                          Text(
                            "EGP ${(widget.model.trip?.price ?? 0) + (raiseFareCubit.price ?? 0)}",
                            style: Styles.headerText(color: Colors.black),
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
                            "Travel time: ~${formatDuration(widget.model.trip?.duration ?? 0)} , Distance: ${formatDistance(widget.model.trip?.distance ?? 0)}",
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
                          tripId: widget.model.trip?.id ?? "");
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color(0xFF495563),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Raise fare",
                          style: Styles.mediumText(
                            color: const Color(0xFF5E6A78),
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
                            "Payment",
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
                                "EGP ${widget.model.trip?.price} ${widget.model.trip?.paymentMethod}",
                                style: Styles.mediumText(color: Colors.black),
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

class AcceptOrDeclineTrip extends StatelessWidget {
  const AcceptOrDeclineTrip({super.key, required this.model});
  final OfferDataModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (model.data?.offerObject?.comfort ?? false)
                  ? Colors.green
                  : Colors.red,
            ),
            child: Text(
              (model.data?.offerObject?.comfort ?? false)
                  ? "Comfort"
                  : "Not Comfort",
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
                      image: NetworkImage(
                          model.data?.offerObject?.profilePicture ?? ""),
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
                        model.data?.offerObject?.firstName ?? "",
                        style: Styles.mediumText(color: Colors.black),
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Text(
                        "${model.data?.offerObject?.averageRating ?? ""} ",
                        style: Styles.mediumText(color: Colors.black),
                      ),
                      Text(
                        "(${model.data?.offerObject?.allCountTrip} rides)",
                        style:
                            Styles.mediumText(color: Colors.grey, fontSize: 26),
                      ),
                    ],
                  ),
                  Text(
                    model.data?.offerObject?.model ?? "",
                    style: Styles.mediumText(color: Colors.black),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    formatDuration(
                        model.data?.offerObject?.arrivalTimeToClient ?? 0),
                    style: Styles.headerText(color: Colors.black, fontSize: 30),
                  ),
                  Text(
                    formatDistance(model.data?.offerObject?.distance ?? 0),
                    style: Styles.headerText(color: Colors.black, fontSize: 30),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "EGP ${model.data?.offerObject?.priceOffer ?? 0}",
            style: Styles.headerText(color: Colors.black, fontSize: 50),
          ),
          const Sizer(),
          Row(
            children: [
              Flexible(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      "Decline",
                      style: Styles.mediumText(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Sizer(),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    // context.read<OfferCubit>().acceptOffer(
                    //   subCategory: model.data.offerObject.
                    // );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        "Accept",
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


// [lklkkkkkkkkkkkkkkkkkkkkkkjjjjjjjjjjjjj] {
//   status: true, 
//   data: {
//     price: 235.75, 
//     lowestFare: null, 
//     from: شارع القنال 92، حي المعادي 11728، 
//     مصر, to: شارع العيسي ، حي مصر الجديدة 11، مصر, calculate_b: 0, polyline: {coordinates: , type: LineString}}}