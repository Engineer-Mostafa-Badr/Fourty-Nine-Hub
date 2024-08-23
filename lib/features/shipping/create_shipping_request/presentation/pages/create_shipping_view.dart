import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/shipping_banner.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card_selected.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/widgets/stateful/maps/map_picker.dart';
import '../../../../ride/RideRequest/domain/entity/address_search_params_entity.dart';

class CreateShippingView extends StatefulWidget {
  const CreateShippingView({super.key});
  @override
  State<CreateShippingView> createState() => _CreateShippingViewState();
}

class _CreateShippingViewState extends State<CreateShippingView> {
  TextEditingController receiptPoint = TextEditingController();
  TextEditingController deliveryPoint = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController decoration = TextEditingController();
  TextEditingController offerPrice = TextEditingController();
  TextEditingController phone = TextEditingController();
  TimeOfDay? time;
  DateTime? date;
  SubCategoryEntity? select;
  List<XFile> tripImages = [];
  @override
  Widget build(BuildContext context) {
    final shippingcubit = context.read<ShippingCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: BlocConsumer<CreateTripCubit, ShippingState>(
        listener: (context, state) {
          if (state is SuccessCreateTrip) {
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
                child: Column(
                  children: [
                    BlocBuilder<ShippingCubit, ShippingState>(
                      builder: (context, state) {
                        if (state is SuccessGetBannerState) {
                          return ShippingBanner(
                            model: state.model,
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    const Sizer(),
                    // لو هو مسجل
                    if(serviceLocator<CacheService>().getDriverId() != null)
                    DashboardBanner(
                      onTap: () => context.push(Routes.DRIVERREQUESTS),
                      title: Labels.driverDashboard,
                      subTitle: Labels.driverDashboardBannerDiscription,
                      route: Routes.DOCTORDASHBOARD,
                    ),
                    // لو هو مش مسجل
                    if(serviceLocator<CacheService>().getDriverId() == null)
                    GestureDetector(
                      onTap: () => context.push(Routes.SHIPPING_REGISTER),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: const Text(
                          "You can enjoy serving your clients using your car by clicking the above register button.",
                          style: TextStyle(
                            color: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FormField(
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition:
                                shippingcubit.requestModel.subcategoryEntity ==
                                    null);
                      },
                      builder: (field) {
                        return BlocBuilder<ShippingCubit, ShippingState>(
                          builder: (context, state) {
                            if (state is SuccessGetBannerState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildMainCategoriesWidget(
                                    category: MainCategoryEntity(
                                        id: state.model.mainCategory
                                                ?.mainCategoryId ??
                                            "",
                                        name:
                                            state.model.mainCategory?.nameEn ??
                                                "",
                                        image:
                                            state.model.mainCategory?.cover ??
                                                "",
                                        isFavorite: true,
                                        total: state.model.mainCategory
                                                ?.driverLength ??
                                            0,
                                        cover:
                                            state.model.mainCategory?.cover ??
                                                "",
                                        banner:
                                            state.model.mainCategory?.banner ??
                                                "",
                                        subcategories: state
                                            .model.subCategories!
                                            .map(
                                              (e) => SubCategoryEntity(
                                                  id: e.subCategoryId!,
                                                  numberOfContent:
                                                      e.driverCount,
                                                  image: e.picture!,
                                                  isFavorite:
                                                      e.isFavorite ?? false,
                                                  name: e.subCategoryNameEn!),
                                            )
                                            .toList()),
                                  ),
                                  if (field.hasError)
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          field.errorText ?? "",
                                          style: Styles.mediumText(
                                              color: Colors.red),
                                        ),
                                      ],
                                    )
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DefaultTextFormField(
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition: receiptPoint.text.isEmpty);
                      },
                      currentController: receiptPoint,
                      currentFocusNode: FocusNode(),
                      hint: Labels.receiptPoint,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition: deliveryPoint.text.isEmpty);
                      },
                      currentController: deliveryPoint,
                      currentFocusNode: FocusNode(),
                      hint: Labels.deliveryPoint,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition: time == null);
                      },
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (pickedTime != null) {
                          time = pickedTime;
                        }
                        setState(() {});
                      },
                      readOnly: true,
                      currentController: TextEditingController(),
                      currentFocusNode: FocusNode(),
                      // hint: "نقطة الاستلام",
                      hint: time != null
                          ? "${time!.hour}:${time!.minute}"
                          : Labels.time,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition: date == null);
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 150),
                        );
                        if (pickedDate != null) {
                          date = pickedDate;
                        }
                        setState(() {});
                      },
                      readOnly: true,
                      currentController: TextEditingController(),
                      currentFocusNode: FocusNode(),
                      // hint: "نقطة الاستلام",
                      hint: date != null
                          ? "${date!.year}/${date!.month}/${date!.day}"
                          : "Date",
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    TextFormField(
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition: decoration.text.isEmpty);
                      },
                      controller: decoration,
                      minLines: 6,
                      maxLines: 6,
                      maxLength: 100,
                      focusNode: FocusNode(),
                      style: const TextStyle(color: AppColors.QUANTITY_COLOR),
                      decoration: InputDecoration(
                        fillColor: AppColors.AUTH_CONTAINER_COLOR,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: Labels.description,
                        hintStyle:
                            const TextStyle(color: AppColors.QUANTITY_COLOR),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        runSpacing: 20,
                        spacing: 20,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runAlignment: WrapAlignment.start,
                        
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var pickedImages =
                                  await ImagePicker().pickMultiImage();
                              if (pickedImages.isNotEmpty) {
                                tripImages = pickedImages;
                              }
                              setState(() {});
                            },
                            child: Container(
                              // margin: EdgeInsets.symmetric(horizontal: 20),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                          ...List.generate(
                            tripImages.length,
                            (index) {
                              return Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(
                                          File(tripImages[index].path),
                                        ),
                                        fit: BoxFit.cover),
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      tripImages.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                )),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // const CustomTextField(hint: "عرض سعر"),
                    DefaultTextFormField(
                      // isRequired: true,
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition: offerPrice.text.isEmpty);
                      },
                      currentController: offerPrice,
                      currentFocusNode: FocusNode(),

                      // hint: "نقطة الاستلام",
                      hint: Labels.offerPrice,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // const CustomTextField(hint: "المحمول"),
                    DefaultTextFormField(
                      validator: (value) {
                        return shippingcubit.validation(
                          message: "This field is required.",
                          condition: phone.text.isEmpty,
                        );
                      },
                      currentController: phone,
                      currentFocusNode: FocusNode(),
                      // hint: "نقطة الاستلام",
                      hint: Labels.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const AppInfoText(
                      text: Labels.theApplicationDoesNot,
                    ),
                    const SizedBox(height: 30),
                    const AppInfoText(
                      text: Labels.thePremiumPackageGivesYou,
                    ),
                    const SizedBox(height: 30),

                    const AppInfoText(
                      text: Labels.freeCancellation,
                    ),
                    const SizedBox(height: 50),
                    // const Gap(50),
                    Row(
                      children: [
                        Flexible(
                          child: AppButton(
                            height: 60,
                            label: Labels.premiumRequest,
                            style: Styles.headerText(color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                        // const Gap(6),
                        const SizedBox(width: 6),
                        Flexible(
                          child: AppButton(
                            height: 60,
                            backColor: const Color(0xFF0B1135),
                            label: Labels.request,
                            style: Styles.headerText(color: Colors.white),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                context.read<CreateTripCubit>().createTrip(
                                      model: RequestModel(
                                        date:
                                            "${date!.year}/${date!.month}/${date!.day}",
                                        deliveryPoint: deliveryPoint.text,
                                        description: decoration.text,
                                        offerPrice: offerPrice.text,
                                        tripImages: tripImages,
                                        phone: phone.text,
                                        subcategoryEntity: select,
                                        receiptPoint: receiptPoint.text,
                                        time: "${time!.hour}:${time!.minute}",
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    // const Gap(100),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: category.name,
          style: Styles.headerText(),
        ),
        if (category.subcategories?.isNotEmpty ?? false)
          SizedBox(
            height: kToolbarHeight * 3,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (select != null) {
                        if (select!.id == category.subcategories![index].id) {
                          select = null;
                        }
                      } else {
                        select = category.subcategories![index];
                      }
                      if (select != null) {
                        shippingCubit.seSubCategoryRequest(
                            subCategory: select!);
                      }
                      log(select.toString());
                    });
                  },
                  child: SubcategoryCardSelected(
                    selected: select == null
                        ? false
                        : select!.id == category.subcategories![index].id,
                    mainCategory: category,
                    item: category.subcategories![index],
                    onChanged: (value) {
                      setState(() {
                        if (select != null) {
                          if (select!.id == category.subcategories![index].id) {
                            select = null;
                          }
                        } else {
                          select = category.subcategories![index];
                        }
                        if (select != null) {
                          shippingCubit.seSubCategoryRequest(
                              subCategory: select!);
                        }
                        log(select.toString());
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
