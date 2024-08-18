import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
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
  // Time time;
  SubCategoryEntity? select;
  @override
  Widget build(BuildContext context) {
    final shippingcubit = context.read<ShippingCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: Form(
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
                 const DashboardBanner(
                  title: Labels.driverDashboard,
                  subTitle: Labels.driverDashboardBannerDiscription,
                  route: Routes.DOCTORDASHBOARD,
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
                          log(
                              state.model.subCategories!.first.subCategoryId
                                  .toString(),
                              name: "SubCategory");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMainCategoriesWidget(
                                category: MainCategoryEntity(
                                    id: state.model.mainCategory
                                            ?.mainCategoryId ??
                                        "",
                                    name:
                                        state.model.mainCategory?.nameEn ?? "",
                                    image:
                                        state.model.mainCategory?.cover ?? "",
                                    isFavorite: false,
                                    total: state
                                            .model.mainCategory?.driverLength ??
                                        0,
                                    cover:
                                        state.model.mainCategory?.cover ?? "",
                                    banner:
                                        state.model.mainCategory?.banner ?? "",
                                    subcategories: state.model.subCategories!
                                        .map(
                                          (e) => SubCategoryEntity(
                                              id: e.subCategoryId!,
                                              image: e.picture!,
                                              isFavorite: false,
                                              name: e.subCategoryNameEn!),
                                        )
                                        .toList()),
                              ),
                              if (field.hasError)
                                Column(
                                  children: [
                                    const SizedBox(height: 8,),
                                    Text(
                                      field.errorText ?? "",
                                      style:
                                          Styles.mediumText(color: Colors.red),
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
                        condition:
                            shippingcubit.model.licenseExpiryDate == null);
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
                        condition:
                            shippingcubit.model.licenseExpiryDate == null);
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
                        condition:
                            shippingcubit.model.licenseExpiryDate == null);
                  },
                  onTap: () {},
                  readOnly: true,
                  currentController: TextEditingController(),
                  currentFocusNode: FocusNode(),
                  // hint: "نقطة الاستلام",
                  hint: Labels.time,
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  validator: (value) {
                    return shippingcubit.validation(
                        message: "This field is required.",
                        condition:
                            shippingcubit.model.licenseExpiryDate == null);
                  },
                  controller: decoration,
                  minLines: 6,
                  maxLines: 6,
                  maxLength: 100,
                  style: const TextStyle(
                    color: AppColors.QUANTITY_COLOR
                  ),
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
                      hintStyle: const TextStyle(fontSize: 12,color: AppColors.QUANTITY_COLOR)),
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
                        condition:
                            shippingcubit.model.licenseExpiryDate == null);
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
                        condition:
                            shippingcubit.model.licenseExpiryDate == null);
                  },
                  currentController: phone,
                  currentFocusNode: FocusNode(),
                  // hint: "نقطة الاستلام",
                  hint: Labels.phone,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Image.asset(
                      Assets.logo,
                      width: 25,
                      height: 25,
                    )),
                    const SizedBox(width: 10),
                     const Flexible(
                        flex: 3,
                        child: Text(Labels.theApplicationDoesNot,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 30),
                // const Gap(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Image.asset(
                      Assets.logo,
                      width: 25,
                      height: 25,
                    )),
                const SizedBox(width: 10),

                    // const Gap(10),
                    const Flexible(
                        flex: 3,
                        child: Text(
                          Labels.thePremiumPackageGivesYou,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                const SizedBox(height: 30),
                // const Gap(30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Image.asset(
                      Assets.logo,
                      width: 25,
                      height: 25,
                    )),
                    // const Gap(10),
                const SizedBox(width: 10),
                    const Flexible(
                      flex: 3,
                      child: Text(
                        Labels.freeCancellation,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
                          onPressed: () {}),
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
                            // String token = ApiConsumer().attachToken(token)
    // log(token, name: "Token");

                            // if (formKey.currentState!.validate()) {}
                          }),
                    ),
                  ],
                ),
                // const Gap(100),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
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
                        select = category.subcategories![index];
                        if (select != null) {
                          shippingCubit.seSubCategoryRequest(
                              subCategory: select!);
                        }
                      });
                    },
                    child: SubcategoryCardSelected(
                        selected: select == null
                            ? false
                            : select!.id == category.subcategories![index].id,
                        mainCategory: category,
                        item: category.subcategories![index]),
                  );
                },
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: category.subcategories?.length ?? 0),
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
