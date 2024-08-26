import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/sub_category.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/create_trip_form.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/shipping_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/trip_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card_selected.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/widgets/stateful/maps/map_picker.dart';
import '../../../../ride/RideRequest/domain/entity/address_search_params_entity.dart';

class CreateShippingView extends StatefulWidget {
  const CreateShippingView({super.key, this.selectedId});
  final String? selectedId;
  @override
  State<CreateShippingView> createState() => _CreateShippingViewState();
}

class _CreateShippingViewState extends State<CreateShippingView> {
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showButtonSheetTrip();
    });
  }

  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final shippingcubit = context.read<ShippingCubit>();
    return SharedScaffold(
      // key: scaffoldKey,
      mainCategoryId: 1,
      body: BlocConsumer<CreateTripCubit, ShippingState>(
        listener: (context, state) {
          if (state is SuccessCreateTrip) {
            context.pushReplacementNamed(Routes.HOME);
            showSuccessMessage(context, state.message);
          }
          if (state is FailureShippingState) {
            showErrorMessage(
                context, getFailureMessage(state.failure, context));
          }
          //
          // } else if (state is OTPSent) {
          //
        },
        builder: (context, state) {
          if (state is LoadingShippingState) {
            return const Align(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                ),
              ),
            );
          }
          return Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                      minWidth: MediaQuery.of(context).size.width),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        BlocBuilder<ShippingCubit, ShippingState>(
                          builder: (context, state) {
                            if (state is LoadingShippingState) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              );
                            }
                            if (state is SuccessGetBannerState) {
                              return Column(
                                children: [
                                  ShippingBanner(
                                    model: state.model,
                                  ),
                                  const Sizer(),
                                  // لو هو مسجل
                                  // if (isDriver(state.model))
                                  DashboardBanner(
                                    onTap: () => context
                                        .push(Routes.DASHBOARDDRIVERSCREEN),
                                    title: Labels.driverDashboard,
                                    subTitle:
                                        Labels.driverDashboardBannerDiscription,
                                    route: Routes.DOCTORDASHBOARD,
                                  ),
                                  // لو هو مش مسجل
                                  if ((state.model.subCategories?.first
                                                  .isDriver ??
                                              false) !=
                                          true &&
                                      ((state.model.subCategories?.first
                                                  .isDriver ??
                                              false)) !=
                                          true)
                                    GestureDetector(
                                      onTap: () => context
                                          .push(Routes.SHIPPING_REGISTER),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "You can enjoy serving your clients using your car by clicking the register button above.",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Spacer(),
                        // NotFoundOffeRers(),
                        const RequestOfferCard(),
                        // Spacer(),
                        //             Container(
                        //   padding: EdgeInsets.all(10),
                        //   width: double.infinity,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.only(
                        //       topLeft: Radius.circular(30),
                        //       topRight: Radius.circular(30),
                        //     ),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text("123", style: TextStyle(fontSize: 30, color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.bold),),
                        //       Row(
                        //         children: [
                        //           Container(
                        //             padding: EdgeInsets.symmetric(horizontal: 4),
                        //             decoration: BoxDecoration(
                        //               color: Colors.blue,
                        //               borderRadius: BorderRadius.circular(8)
                        //             ),
                        //             child: Row(
                        //               mainAxisSize: MainAxisSize.min,
                        //               children: [
                        //                 Icon(Icons.history, color: Colors.white,),
                        //                 Text("Pickup: 10-20 min", style: TextStyle(color: Colors.white),)
                        //               ],
                        //             )
                        //           ),
                        //           SizedBox(width: 8,),
                        //           Container(
                        //         padding: EdgeInsets.symmetric(horizontal: 4),
                        //         decoration: BoxDecoration(
                        //           color: Colors.blue,
                        //           borderRadius: BorderRadius.circular(8)
                        //         ),
                        //         child: Row(
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             Icon(Icons.history, color: Colors.white,),
                        //             Text("I", style: TextStyle(color: Colors.white),)
                        //           ],
                        //         )
                        //       )
                        //         ],
                        //       ),

                        //     ],
                        //   ),
                        // ),
                        // CreateTripForm(
                        //   formKey: formKey,
                        //   selectedId: widget.selectedId,
                        // ),
                        // const Gap(100),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool isDriver(BannerModel model) {
    if (model.subCategories!.first.isDriver ?? false) {
      if (model.subCategories!.first.isDriverApproved ?? false) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

// BlocProvider(
//                   create: (context) => ),
  showButtonSheetTrip() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => serviceLocator<TripCubit>()),
            BlocProvider(
                create: (context) => serviceLocator<CallMessageCubit>()),
          ],
          child: TripCardWidget(
            yourRequest: true,
            title: "Your request",
            buttons: false,
            model: AllTripModel(
              phone: 12,
              time: "lskd",
              desc: "lksd",
              price: 10,
            ),
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hint,
      this.prefixIcon,
      this.minLines,
      this.maxLines,
      this.maxLength});
  final String hint;
  final Icon? prefixIcon;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: minLines,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red)),
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: prefixIcon,
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 18,
        ),
      ),
      textAlign: TextAlign.right,
    );
  }
}

class NotFoundOffers extends StatelessWidget {
  const NotFoundOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Your request has been sent. You'll receive offers shortly.",
            style: TextStyle(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}


class RequestOfferCard extends StatelessWidget {
  const RequestOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // ignore: prefer_const_literals_to_create_immutables
                                boxShadow: [
                                  const BoxShadow(color: Colors.black12, blurRadius: 10),
                                ],
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("New Offer", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                      Text("12,300", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),),
                                    ],
                                  ),
                                  const SizedBox(height: 7,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("car model", style: TextStyle(fontSize: 15),),
                                  SizedBox(height: 5,),
                                      Text("request name", style: TextStyle(fontSize: 15),),
                                  SizedBox(height: 5,),
                                  Text("3 Orders", style: TextStyle(fontSize: 15),)
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      const Row(
                                            children: [
                                              Icon(Icons.star, color: Colors.amber,),
                                              Text("4.9"),
                                              Text("(1)", style: TextStyle(color: Colors.grey),),
                                            ],
                                          ),
                                      Text("Premium")
                                    ],
                                  )
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: AppButton(
                                          color: Colors.white,
                                          // height: 50,
                                          // padding: EdgeInsets.symmetric(vertical: 0),
                                          width: double.infinity,
                                          onPressed: () {
                                            
                                          },
                                          style: Styles.mediumText(
                                          fontSize: 18, color: Colors.white),
                                          label: "Decline",
                                          // backgroundColor: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Flexible(
                                        child: AppButton(
                                          // label: Labels.message,
                                      // icon: Icons.message,
                                      backColor: AppColors.PRIMARY_COLOR,
                                      style: Styles.mediumText(
                                          fontSize: 18, color: Colors.white),
                                      onPressed: () {},
                                          label: "Accept",
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  BlocBuilder<CallMessageCubit, ShippingState>(
                          builder: (context, state) {
                            if (state is FailureShippingState) {
                              log(getFailureMessage(state.failure, context),
                                  name: "lskdjflskdjfslkdjfslkdjfslkdjf");
                            }
                            log(state.toString(),
                                name: "lskdjflskdjfslkdjfslkdjfslkdjf");
                            if (state is SuccessGetCallMessageState) {
                              log(state.data.toString(),
                                  name: "lskdjflskdjfslkdjfslkdjfslkdjf");
                              return Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      label: Labels.call,
                                      color: Colors.white,
                                      icon: Icons.call,
                                      backColor: state.data
                                          ? AppColors.PRIMARY_COLOR
                                          : AppColors.DARK_GRAY_COLOR,
                                      onPressed: () {},
                                      style: Styles.mediumText(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                  const Sizer(),
                                  Expanded(
                                    child: AppButton(
                                      label: Labels.message,
                                      icon: Icons.message,
                                      backColor: state.data
                                          ? AppColors.PRIMARY_COLOR
                                          : AppColors.DARK_GRAY_COLOR,
                                      style: Styles.mediumText(
                                          fontSize: 15, color: Colors.white),
                                      onPressed: () {},
                                    ),
                                  ),
                                  const Sizer(),
                                  Expanded(
                                    child: AppButton(
                                      label: Labels.report,
                                      icon: Icons.report,
                                      backColor: Colors.red,
                                      style: Styles.mediumText(
                                          fontSize: 18, color: Colors.white),
                                      onPressed: () {
                                        // tripCubit.report(
                                        //     loadingTripId: widget.model.id ?? "");
                                        // showBottomSheet(
                                        //   context: context,
                                        //   builder: (context) => Padding(
                                        //     padding: const EdgeInsets.all(10),
                                        //     child: ReportView(
                                        //       categoryId:
                                        //           widget.model.categoryId?.id ?? "",
                                        //       id: widget.model.id ?? "",
                                        //       loadingTripId: widget.model.id ?? "",
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      label: Labels.call,
                                      color: Colors.white,
                                      icon: Icons.call,
                                      backColor: AppColors.DARK_GRAY_COLOR,
                                      onPressed: () {
                                        launchUrlString("tel://21213123123");
                                      },
                                      style: Styles.mediumText(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                  const Sizer(),
                                  Expanded(
                                    child: AppButton(
                                      label: Labels.message,
                                      icon: Icons.message,
                                      backColor: AppColors.DARK_GRAY_COLOR,
                                      style: Styles.mediumText(
                                          fontSize: 18, color: Colors.white),
                                      onPressed: () {},
                                    ),
                                  ),
                                  const Sizer(),
                                  Expanded(
                                    child: AppButton(
                                      label: Labels.report,
                                      icon: Icons.report,
                                      backColor: Colors.red,
                                      style: Styles.mediumText(
                                          fontSize: 15, color: Colors.white),
                                      onPressed: () {
                                        showBottomSheet(
                                          context: context,
                                          builder: (context) => const ReportView(
                                            categoryId: "",
                                            id: "",
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                                ],
                              ),
                            ),
            Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: GestureDetector(
                              onTap: () {
                                //هتروح لي صفحه subscription
                                serviceLocator<SubscriptionController>().showActiveSubscriptionAmounts(walletType: WalletTypes.balance);
                              },
                              child: Text(
                                "Subscribe to contact to the driver",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                              ),
                            ))
      ],
    );
  }
}