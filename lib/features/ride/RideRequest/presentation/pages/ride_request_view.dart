import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_trip_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/location_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/request_rider_trip_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/rider_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/sub_category.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card_selected.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
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
    // TODO: implement initState
    super.initState();
    // context.read<>()
  }

  @override
  Widget build(BuildContext context) {
    var getTripInfoCubit = context.read<GetTripInfoCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: SingleChildScrollView(
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
                      GestureDetector(
                        // onTap: () => context
                        //     .push(Routes.SHIPPING_REGISTER),
                        onTap: () {
                          if (context.read<UserCubit>().isLoggedIn) {
                            context.push(Routes.SHIPPING_REGISTER);
                          } else {
                            // context.push(Routes.SHIPPING_REGISTER);
                            context.push(Routes.LOGIN);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Text(
                            "You can enjoy serving your clients using your car by clicking the register button above.",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
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
                                      Flexible(
                                        child: AppButton(
                                          height: 40,
                                          backColor: const Color(0xFF0B1135),
                                          label: Labels.request,
                                          style: Styles.headerText(
                                              color: Colors.white),
                                          onPressed: () async {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  width: double.infinity,
                                                  // 
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      topRight:
                                                          Radius.circular(30),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(20),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text("5 drivers are viewing your request", style: Styles.mediumText(color: Colors.black),),
                                                            const Spacer(),
                                                            Expanded(
                                                              child: Stack(
                                                                children: [
                                                                  Positioned(
                                                                    child: Container(
                                                                      width: 25,
                                                                      height: 25,
                                                                      decoration: const BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    left: 10,
                                                                    child: Container(
                                                                      width: 25,
                                                                      height: 25,
                                                                      decoration: const BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.orange,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    left: 20,
                                                                    child: Container(
                                                                      width: 25,
                                                                      height: 25,
                                                                      decoration: const BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.blue,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    left: 30,
                                                                    child: Container(
                                                                      width: 25,
                                                                      height: 25,
                                                                      decoration: const BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.green,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      topRight:
                                                          Radius.circular(30),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text("Finding drivers...", style: Styles.headerText(color: Colors.black,),),
                                                      const Sizer(),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              height: 60,
                                                              width: double.infinity,
                                                              decoration: BoxDecoration(
                                                                color: const Color(0xFF495563),
                                                                borderRadius: BorderRadius.circular(10)
                                                              ),
                                                              child: Center(
                                                                child: Text("+3", style: Styles.mediumText(color: const Color(0xFF5E6A78), fontSize: 38,),),
                                                              ),
                                                            ),
                                                          ),
                                                          const Sizer(),
                                                          const Sizer(),
                                                          Column(
                                                            children: [
                                                              Text("Your offer", style: Styles.mediumText(color: Colors.grey),),
                                                              const Sizer(height: 5,),
                                                              Text("EGP 30", style: Styles.headerText(color: Colors.black),),
                                                            ],
                                                          ),
                                                          const Sizer(),
                                                          const Sizer(),
                                                          Flexible(
                                                            child: Container(
                                                              height: 60,
                                                              width: double.infinity,
                                                              decoration: BoxDecoration(
                                                                color: AppColors.PRIMARY_COLOR,
                                                                borderRadius: BorderRadius.circular(10)
                                                              ),
                                                              child: Center(
                                                                child: Text("+3", style: Styles.mediumText(color: Colors.white, fontSize: 38),),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const Sizer(),
                                                      const Sizer(),
                                                      Container(
                                                      padding:
                                                      const EdgeInsets.symmetric(horizontal: 15),
                                                      width: double.infinity,
                                                      height: 46,
                                                      decoration: BoxDecoration(
                                                          color: const Color(0xFF0E4669),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  13)),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.info_outline,
                                                            color: Colors.white,
                                                          ),
                                                          const Sizer(),
                                                          Flexible(
                                                            child: Text(
                                                              "Travel time: ~${2} , Distance: 3km",
                                                              style: Styles.mediumText(
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                  color: Colors.white),
                                                            ),
                                                          ),
                                                          const Sizer(),
                                                        ],
                                                      ),
                                                    ),
                                                    const Sizer(),
                                                    Container(
                                                              height: 60,
                                                              width: double.infinity,
                                                              decoration: BoxDecoration(
                                                                color: const Color(0xFF495563),
                                                                borderRadius: BorderRadius.circular(10)
                                                              ),
                                                              child: Center(
                                                                child: Text("Raise fare", style: Styles.mediumText(color: const Color(0xFF5E6A78), fontSize: 38,),),
                                                              ),
                                                            ),
                                            const Sizer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Payment", style: Styles.mediumText(color: const Color(0xFFA1A4AF)),),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.credit_card, color: Colors.black,),
                                                        Text("EGP 77 Cash", style: Styles.mediumText(color: Colors.black),),
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
                                              },
                                            );
                                            // context
                                            //     .read<GetTripInfoCubit>()
                                            //     .getTripInfoRequest();
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
                          return Container();
                        },
                      )
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
            // const Expanded(
            //     child: Stack(
            //   children: [
            //     // Positioned.fill(
            //     //   child: BlocProvider(
            //     //     create: (BuildContext context) =>
            //     //         serviceLocator<RiderequestCubit>(),
            //     //     child: BlocBuilder<RiderequestCubit, RiderequestState>(
            //     //       builder: (context, state) {
            //     //         final rideCubit = context.read<RiderequestCubit>();
            //     //         if (state.fromAddress != null &&
            //     //             state.toAddress != null) {
            //     //           return MapPicker(
            //     //             lat: state.fromAddress?.lat,
            //     //             lng: state.fromAddress?.lng,
            //     //             destLat: state.toAddress?.lat,
            //     //             destLng: state.toAddress?.lng,
            //     //           );
            //     //         }
            //     //         return MapPicker(
            //     //           lat: state.fromAddress?.lat,
            //     //           lng: state.fromAddress?.lng,
            //     //           onAddressPicked: (AddressSearchParamsEntity v) =>
            //     //               rideCubit.selectPickUpLocation(item: v),
            //     //         );
            //     //         // return Container(
            //     //         //   decoration: const BoxDecoration(
            //     //         //     color: Colors.red,
            //     //         //     image: DecorationImage(image: AssetImage("assets/images/map_image.png"), fit: BoxFit.cover)
            //     //         //   ),
            //     //         // );
            //     //       },
            //     //     ),
            //     //   ),
            //     // ),
            //     // const Positioned(
            //     // bottom: 10,
            //     // right: 10,
            //     // left: 10,
            //     // child: DashboardBanner(
            //     //   title: 'Driver Dashboard\n',
            //     //   subTitle:
            //     //       'New trips are waiting you, go to driver dashboard and explore more!',
            //     //   route: Routes.RIDERDASHBOARD,
            //     // )),
            //   ],
            // )
            // ),
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
            height: kToolbarHeight * 3,
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
                      context
                          .read<LocationSocketCubit>()
                          .sendSubCategoryId(category.subcategories![index].id);
                      context
                          .read<LocationSocketCubit>()
                          .updateDriverLocationOn();
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
                    onChanged: (value) {
                      setState(() {
                        riderCubit
                            .selectCateogry(category.subcategories![index]);
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
