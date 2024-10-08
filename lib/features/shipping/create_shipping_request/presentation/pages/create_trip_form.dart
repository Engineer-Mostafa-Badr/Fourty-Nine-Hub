
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/sub_category.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card_selected.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/widgets/stateful/maps/map_picker.dart';
import '../../../../ride/RideRequest/domain/entity/address_search_params_entity.dart';

class CreateTripForm extends StatefulWidget {
  const CreateTripForm({super.key, this.selectedId, required this.formKey});
  final String? selectedId;
  final GlobalKey<FormState> formKey;
  @override
  State<CreateTripForm> createState() => _CreateTripFormState();
}

class _CreateTripFormState extends State<CreateTripForm> {
  TextEditingController receiptPoint = TextEditingController();
  FocusNode receiptPointFocusNode = FocusNode();
  TextEditingController deliveryPoint = TextEditingController();
  FocusNode deliveryPointFocusNode = FocusNode();
  TextEditingController decoration = TextEditingController();
  FocusNode decorationFocusNode = FocusNode();
  TextEditingController offerPrice = TextEditingController();
  FocusNode offerPriceFocusNode = FocusNode();
  TextEditingController phone = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();
  TimeOfDay? time;
  DateTime? date;
  SubCategoryEntity? select;
  List<XFile> tripImages = [];
  SubCategoryEntity? getSelectedSubCategory(
      {required List<SubCategory>? categoryes}) {
    SubCategory? model = categoryes?.firstWhere(
      (element) => widget.selectedId == element.subCategoryId,
    );
    isSelect = true;
    return SubCategoryEntity(
        id: model?.subCategoryId ?? "",
        name: model?.subCategoryNameEn ?? "",
        image: model?.picture ?? "",
        isFavorite: model?.isFavorite ?? false);
  }

  List<SubCategory>? sortList(List<SubCategory>? list) {
    if (widget.selectedId != null) {
      int index =
          list!.indexWhere((model) => model.subCategoryId == widget.selectedId);
      if (index != -1) {
        return list.sublist(index) + list.sublist(0, index);
      }
      return list;
    } else {
      return list;
    }
  }

  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    final shippingcubit = context.read<ShippingCubit>();
    return Container(
      child: Column(
        children: [
          FormField(
            validator: (value) {
              return shippingcubit.validation(
                  message: "You have to select one sub category!".tr(),
                  condition:
                      shippingcubit.requestModel.subcategoryEntity == null);
            },
            builder: (field) {
              return BlocBuilder<ShippingCubit, ShippingState>(
                builder: (context, state) {
                  if (state is SuccessGetBannerState) {
                    if (!isSelect) {
                      if (widget.selectedId != null) {
                        select = getSelectedSubCategory(
                            categoryes: state.model.subCategories);
                      }
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMainCategoriesWidget(
                          category: MainCategoryEntity(
                              nameEn: state.model.mainCategory?.nameEn,
                              id: state.model.mainCategory?.mainCategoryId ??
                                  "",
                              name: "Choose your favorite sub category!".tr(),
                              image: state.model.mainCategory?.cover ?? "",
                              isFavorite: true,
                              total:
                                  state.model.mainCategory?.driverLength ?? 0,
                              cover: state.model.mainCategory?.cover ?? "",
                              banner: state.model.mainCategory?.banner ?? "",
                              subcategories:
                                  sortList(state.model.subCategories)!
                                      .map(
                                        (e) => SubCategoryEntity(
                                            id: e.subCategoryId!,
                                            numberOfContent: e.driverCount,
                                            image: e.picture!,
                                            isFavorite: e.isFavorite ?? false,
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  field.errorText ?? "",
                                  style: Styles.mediumText(color: Colors.red),
                                ),
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
            height: 4,
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DefaultTextFormField(
                        validator: (value) {
                          return shippingcubit.validation(
                              message:
                                  "You have to fill your receipt point!".tr(),
                              condition: receiptPoint.text.isEmpty);
                        },
                        currentController: receiptPoint,
                        currentFocusNode: receiptPointFocusNode,
                        hint: Labels.receiptPoint,
                      ),
                    ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    Expanded(
                      child: DefaultTextFormField(
                        constraints:
                            const BoxConstraints(maxWidth: double.infinity),
                        validator: (value) {
                          return shippingcubit.validation(
                              message:
                                  "You have to fill your devlivery point!".tr(),
                              condition: deliveryPoint.text.isEmpty);
                        },
                        currentController: deliveryPoint,
                        currentFocusNode: deliveryPointFocusNode,
                        hint: Labels.deliveryPoint,
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
                        validator: (value) {
                          return shippingcubit.validation(
                              message: "You have to fill your time!".tr(),
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
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: DefaultTextFormField(
                        validator: (value) {
                          return shippingcubit.validation(
                              message: "You have to fill your date!".tr(),
                              condition: date == null);
                        },
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 150),
                          );
                          date = pickedDate;
                          setState(() {});
                        },
                        readOnly: true,
                        currentController: TextEditingController(),
                        // currentFocusNode: FocusNode(),
                        // hint: "نقطة الاستلام",
                        hint: date != null
                            ? "${date!.year}/${date!.month}/${date!.day}"
                            : "Pickup Date".tr(),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),

                TextFormField(
                  validator: (value) {
                    return shippingcubit.validation(
                        message: "You have to fill your description!".tr(),
                        condition: decoration.text.isEmpty);
                  },
                  controller: decoration,
                  minLines: 3,
                  maxLines: 3,
                  maxLength: 100,
                  focusNode: decorationFocusNode,
                  style: const TextStyle(color: AppColors.QUANTITY_COLOR),
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.red),
                    fillColor: AppColors.AUTH_CONTAINER_COLOR,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: Labels.description,
                    hintStyle: const TextStyle(color: AppColors.QUANTITY_COLOR),
                    counterText: "", // لإخفاء عداد الأحرف الافتراضي خارج الحقل
                  ),
                  buildCounter: (
                    BuildContext context, {
                    required int currentLength,
                    required bool isFocused,
                    required int? maxLength,
                  }) {
                    return Text(
                      '$currentLength/$maxLength',
                      style: TextStyle(
                        color: currentLength > maxLength!
                            ? Colors.red
                            : AppColors.QUANTITY_COLOR,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Flexible(
                      child: DefaultTextFormField(
                        validator: (value) {
                          return shippingcubit.validation(
                              message:
                                  "You have to fill your offer price!".tr(),
                              condition: offerPrice.text.isEmpty);
                        },
                        currentController: offerPrice,
                        currentFocusNode: offerPriceFocusNode,

                        // hint: "نقطة الاستلام",
                        hint: Labels.offerPrice,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: DefaultTextFormField(
                        validator: (value) {
                          return shippingcubit.validation(
                            message: "You have to fill your phone!".tr(),
                            condition: phone.text.isEmpty,
                          );
                        },
                        currentController: phone,
                        currentFocusNode: phoneFocusNode,
                        // hint: "نقطة الاستلام",
                        hint: Labels.phone,
                        keyboardType: TextInputType.phone,
                      ),
                    )
                  ],
                ),

                // const CustomTextField(hint: "المحمول"),

                const SizedBox(
                  height: 4,
                ),
                const AppInfoText(
                  text: Labels.theApplicationDoesNot,
                ),
                const SizedBox(height: 4),
                const AppInfoText(
                  text: Labels.thePremiumPackageGivesYou,
                ),
                const SizedBox(height: 4),

                const AppInfoText(
                  text: Labels.freeCancellation,
                ),
                const SizedBox(height: 4),
                // const Gap(50),
                Row(
                  children: [
                    Flexible(
                      child: AppButton(
                        height: 40,
                        label: Labels.premiumRequest,
                        style: Styles.headerText(color: Colors.white),
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
                        style: Styles.headerText(color: Colors.white),
                        onPressed: () async {
                          if (widget.formKey.currentState!.validate()) {
                            context.read<CreateTripCubit>().createTrip(
                                  model: RequestModel(
                                    date:
                                        "${date!.year}/${date!.month}/${date!.day}",
                                    deliveryPoint: deliveryPoint.text,
                                    description: decoration.text,
                                    offerPrice: offerPrice.text,
                                    // tripImages: tripImages,
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
              ],
            ),
          ),
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
        Label(
          text: category.name,
          style: Styles.headerText(fontWeight: FontWeight.w400),
        ),
        if (category.subcategories?.isNotEmpty ?? false)
          SizedBox(
            height: kToolbarHeight * 3,
            child: ListView.separated(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
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
