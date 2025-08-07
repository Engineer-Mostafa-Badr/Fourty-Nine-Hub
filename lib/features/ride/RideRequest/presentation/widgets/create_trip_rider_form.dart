import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/create_trip_ride_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/get_user_login_trip_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/create_trip_request_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/select_cateogry_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card_selected.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../common/widgets/stateful/maps/map_picker.dart';
import '../../../../ride/RideRequest/domain/entity/address_search_params_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class CreateTripRiderForm extends StatefulWidget {
  const CreateTripRiderForm({super.key});

  @override
  State<CreateTripRiderForm> createState() => _CreateTripRiderFormState();
}

class _CreateTripRiderFormState extends State<CreateTripRiderForm> {
  TextEditingController startPointCntroller = TextEditingController();
  FocusNode startPointFocusNode = FocusNode();
  TextEditingController destinationController = TextEditingController();
  FocusNode destinationFocusNode = FocusNode();
  int? numberOfPassenger;
  TextEditingController offerPrice = TextEditingController();
  FocusNode offerPriceFocusNode = FocusNode();
  TextEditingController phone = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();
  TimeOfDay? time;
  DateTime? date;
  SubCategoryEntity? select;
  List<XFile> tripImages = [];
  bool isSelect = false;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var createRequestCubit = context.read<CreateTripRequestRideCubit>();
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 4,
          ),
          BlocConsumer<CreateTripRequestRideCubit, RiderState>(
            listener: (context, state) {
              if (state is SuccessCreateRequestTripRideState) {
                showSuccessMessage(
                    context,
                    LocaleKeys
                        .yourRequestHasBeenSentSuccessfullyWaitingForTheDriverResponse
                        .tr());
                context.read<GetUserLoginTripNoSocketCubit>().get();
              }
              if (state is FailureRiderState) {
                showErrorMessage(
                    context, getFailureMessage(state.failure, context));
              }
            },
            builder: (context, state) {
              if (state is LoadingRiderState) {
                return const Center(
                  child: CustomCircularProgressIndicator(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextFormField(
                            isAuthentcation: true,
                            margin: EdgeInsets.zero,
                            validator: (value) {
                              return createRequestCubit.validation(
                                  message: LocaleKeys
                                      .youHaveToFillYourReceiptPoint
                                      .tr(),
                                  condition: startPointCntroller.text.isEmpty);
                            },
                            currentController: startPointCntroller,
                            currentFocusNode: startPointFocusNode,
                            hint: LocaleKeys.startPoint.tr(),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: DefaultTextFormField(
                            isAuthentcation: true,
                            margin: EdgeInsets.zero,
                            constraints:
                                const BoxConstraints(maxWidth: double.infinity),
                            validator: (value) {
                              return createRequestCubit.validation(
                                  message: LocaleKeys
                                      .youHaveToFillYourDeliveryPoint
                                      .tr(),
                                  condition:
                                      destinationController.text.isEmpty);
                            },
                            currentController: destinationController,
                            currentFocusNode: destinationFocusNode,
                            hint: LocaleKeys.destination.tr(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: DefaultTextFormField(
                            margin: EdgeInsets.zero,
                            validator: (value) {
                              return createRequestCubit.validation(
                                  message:
                                      LocaleKeys.youHaveToFillYourTime.tr(),
                                  condition: time == null);
                            },
                            onTap: () async {
      ManageVibration.vibrate();
                              if (context.isUserLoggedIn) {
                                TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                if (pickedTime != null) {
                                  time = pickedTime;
                                }
                              } else {
                                return pleaseLoginDialog(context);
                                // context.push(Routes.LOGIN);
                              }

                              setState(() {});
                            },
                            readOnly: true,
                            currentController: TextEditingController(),
                            hint: time != null
                                ? "${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}"
                                : LocaleKeys.pickupTime.tr(),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: DefaultTextFormField(
                            isAuthentcation: true,
                            margin: EdgeInsets.zero,
                            validator: (value) {
                              return createRequestCubit.validation(
                                  message:
                                      LocaleKeys.youHaveToFillYourDate.tr(),
                                  condition: date == null);
                            },
                            onTap: () async {
      ManageVibration.vibrate();
                              if (context.isUserLoggedIn) {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 150),
                                );
                                date = pickedDate;
                              } else {
                                return pleaseLoginDialog(context);

                                // context.push(Routes.LOGIN);
                              }

                              setState(() {});
                            },
                            readOnly: true,
                            currentController: TextEditingController(),
                            // currentFocusNode: FocusNode(),
                            // hint: "نقطة الاستلام",
                            hint: date != null
                                ? "${date!.year}/${date!.month}/${date!.day}"
                                : LocaleKeys.pickupDate.tr(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    FormField(
                      validator: (value) {
                        return createRequestCubit.validation(
                            message: LocaleKeys
                                .youHaveToFillYourNumberOfPassenger
                                .tr(),
                            condition: numberOfPassenger == null);
                      },
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 48,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: context.isDarkMode
                                      ? AppColors.QUANTITY_COLOR
                                      : Colors.white,
                                  border: Border.all(
                                      color: field.hasError
                                          ? Colors.red
                                          : Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButton(
                                value: numberOfPassenger,
                                items: const [
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text("1"),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text("2"),
                                  ),
                                  DropdownMenuItem(
                                    value: 3,
                                    child: Text("3"),
                                  ),
                                  DropdownMenuItem(
                                    value: 4,
                                    child: Text("4"),
                                  ),
                                  DropdownMenuItem(
                                    value: 5,
                                    child: Text("5"),
                                  ),
                                  DropdownMenuItem(
                                    value: 6,
                                    child: Text("6"),
                                  ),
                                  DropdownMenuItem(
                                    value: 7,
                                    child: Text("7"),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    numberOfPassenger = value;
                                  });
                                },
                                dropdownColor: Colors.white,
                                icon: Container(),
                                underline: Container(),
                                hint: Text(
                                  LocaleKeys.numberOfPassenger.tr(),
                                  style: const TextStyle(
                                      color: AppColors.QUANTITY_COLOR,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                            if (field.hasError)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Text(
                                      field.errorText ?? "",
                                      style: const TextStyle(
                                          color: Color(0xFFB3261E),
                                          fontSize: 11),
                                    ),
                                  )
                                ],
                              )
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DefaultTextFormField(
                            isAuthentcation: true,
                            margin: EdgeInsets.zero,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              return createRequestCubit.validation(
                                  message: LocaleKeys
                                      .youHaveToFillYourOfferPrice
                                      .tr(),
                                  condition: offerPrice.text.isEmpty);
                            },
                            currentController: offerPrice,
                            currentFocusNode: offerPriceFocusNode,

                            // hint: "نقطة الاستلام",
                            hint: LocaleKeys.offerPrice.tr(),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: DefaultTextFormField(
                            isAuthentcation: true,
                            style: Styles.smallText(),
                            margin: EdgeInsets.zero,
                            validator: (value) {
                              return createRequestCubit.validation(
                                message: LocaleKeys.youHaveToFillYourPhone.tr(),
                                condition: phone.text.isEmpty,
                              );
                            },
                            currentController: phone,
                            currentFocusNode: phoneFocusNode,
                            // hint: "نقطة الاستلام",
                            hint: LocaleKeys.phone.tr(),
                            keyboardType: TextInputType.phone,
                          ),
                        )
                      ],
                    ),

                    // const CustomTextField(hint: "المحمول"),

                    const SizedBox(
                      height: 4,
                    ),
                    AppInfoText(
                      text: LocaleKeys
                          .theApplicationDoesNotDeductAnyPercentageFromTheServiceProvider
                          .tr(),
                    ),
                    const SizedBox(height: 4),
                    AppInfoText(
                      text:
                          LocaleKeys.premiumPackageMoreVisibilityCashback.tr(),
                    ),
                    const SizedBox(height: 4),

                    AppInfoText(
                      text: LocaleKeys.freeCancellation.tr(),
                    ),
                    const SizedBox(height: 4),
                    // const Gap(50),
                    Row(
                      children: [
                        Flexible(
                          child: AppButton(
                            height: 40,
                            label: LocaleKeys.premiumRequest.tr(),
                            style: Styles.headerText(color: Colors.white),
                            onPressed: () {
      ManageVibration.vibrate();
                              if (context.isUserLoggedIn) {
                                if (formKey.currentState!.validate()) {
                                  createRequestCubit.createRequestPremium(
                                    model: CreateTripRideRequestModel(
                                        categoryId: context
                                            .read<RiderTripReelTimeCubit>()
                                            .subCategory
                                            ?.id,
                                        fromTitle: startPointCntroller.text,
                                        passangers: numberOfPassenger,
                                        phone: phone.text,
                                        price: double.parse(offerPrice.text),
                                        time:
                                            "${DateFormat(DateFormat.YEAR_MONTH_DAY).format(date!)}:${time?.hour}:${time?.minute}",
                                        toTitle: destinationController.text,
                                        desc: ""),
                                  );
                                }
                              } else {
                                return pleaseLoginDialog(context);

                                // context.push(Routes.LOGIN);
                              }
                            },
                          ),
                        ),
                        // const Gap(6),
                        const SizedBox(width: 6),
                        Flexible(
                          child: AppButton(
                            height: 40,
                            backColor: const Color(0xFF0B1135),
                            label: LocaleKeys.request.tr(),
                            style: Styles.headerText(color: Colors.white),
                            onPressed: () async {
      ManageVibration.vibrate();
                              if (context.isUserLoggedIn) {
                                if (formKey.currentState!.validate()) {
                                  createRequestCubit.request(
                                    model: CreateTripRideRequestModel(
                                        categoryId: context
                                            .read<RiderTripReelTimeCubit>()
                                            .subCategory
                                            ?.id,
                                        fromTitle: startPointCntroller.text,
                                        passangers: numberOfPassenger,
                                        phone: phone.text,
                                        price: double.parse(offerPrice.text),
                                        time:
                                            "${DateFormat(DateFormat.YEAR_MONTH_DAY).format(date!)}:${time?.hour}:${time?.minute}",
                                        toTitle: destinationController.text,
                                        desc: ""),
                                  );
                                }
                              } else {
                                return pleaseLoginDialog(context);

                                // context.push(Routes.LOGIN);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildMapWidget({
    required BuildContext context,
  }) {
    final controller = context.read<CreateShippingRequestCubit>();
    return BlocBuilder<CreateShippingRequestCubit, CreateShippingRequestState>(
      builder: (context, state) {
        return MapPicker(
          lat: state.fromAddress?.lat,
          lng: state.fromAddress?.lng,
          onAddressPicked: (AddressSearchParamsEntity v) =>
              controller.selectPickUpLocation(item: v),
        );
      },
    );
  }

  Widget _buildMainCategoriesWidget({
    required MainCategoryEntity category,
  }) {
    final shippingCubit = context.read<ShippingCubit>();
    ScrollController scrollController = ScrollController();
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
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(onTap: () {
      ManageVibration.vibrate();
                  setState(() {
                    shippingCubit.sortData(category.subcategories![index].id);
                    scrollController.jumpTo(0);
                    if (select != null) {
                      if (select!.id == category.subcategories![index].id) {
                        select = null;
                      } else {
                        select = category.subcategories![index];
                      }
                    } else {
                      select = category.subcategories![index];
                    }
                    if (select != null) {
                      shippingCubit.seSubCategoryRequest(subCategory: select!);
                      context.read<SelectCateogryCubit>().select(
                          id: category.subcategories![index].id, type: 1);
                    }
                  });
                }, child: BlocBuilder<SelectCateogryCubit, RiderState>(
                  builder: (context, state) {
                    if (state is SuccessSelectCateogryState) {
                      if (state.type == 1) {
                        return SubcategoryCardSelected(
                          isSmallCard: true,
                          selected: select == null
                              ? false
                              : select!.id == category.subcategories![index].id,
                          mainCategory: category,
                          item: category.subcategories![index],
                          onChanged: (value) {
                            setState(() {
                              if (select != null) {
                                if (select!.id ==
                                    category.subcategories![index].id) {
                                  select = null;
                                }
                              } else {
                                select = category.subcategories![index];
                              }
                              if (select != null) {
                                shippingCubit.seSubCategoryRequest(
                                    subCategory: select!);
                                context
                                    .read<RiderTripReelTimeCubit>()
                                    .removeCateogry();
                              }
                            });
                          },
                        );
                      } else {
                        return SubcategoryCardSelected(
                          isSmallCard: true,
                          selected: false,
                          mainCategory: category,
                          item: category.subcategories![index],
                          onChanged: (value) {
                            setState(() {
                              if (select != null) {
                                if (select!.id ==
                                    category.subcategories![index].id) {
                                  select = null;
                                }
                              } else {
                                select = category.subcategories![index];
                              }
                              if (select != null) {
                                shippingCubit.seSubCategoryRequest(
                                    subCategory: select!);
                                context
                                    .read<RiderTripReelTimeCubit>()
                                    .removeCateogry();
                              }
                            });
                          },
                        );
                      }
                    } else {
                      return SubcategoryCardSelected(
                        isSmallCard: true,
                        selected: select == null
                            ? false
                            : select!.id == category.subcategories![index].id,
                        mainCategory: category,
                        item: category.subcategories![index],
                        onChanged: (value) {
                          setState(() {
                            if (select != null) {
                              if (select!.id ==
                                  category.subcategories![index].id) {
                                select = null;
                              }
                            } else {
                              select = category.subcategories![index];
                            }
                            if (select != null) {
                              shippingCubit.seSubCategoryRequest(
                                  subCategory: select!);
                            }
                          });
                        },
                      );
                    }
                  },
                ));
              },
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: category.subcategories?.length ?? 0,
            ),
          )
      ],
    );
  }
}