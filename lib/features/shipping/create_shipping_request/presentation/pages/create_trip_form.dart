import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/select_cateogry_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/sub_category.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card_selected.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
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
        nameEn: model?.subCategoryNameEn ?? "",
        nameAr: model?.subCategoryNameAr ?? "",
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
              log(shippingcubit.requestModel.subcategoryEntity.toString(),
                  name: 'lsjdflsdjflskdf');
              return shippingcubit.validation(
                  message: LocaleKeys.youHaveToSelectOneSubCategory.tr(),
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
                              image: state.model.mainCategory?.cover ?? "",
                              isFavorite: true,
                              total:
                                  state.model.mainCategory?.driverLength ?? 0,
                              cover: state.model.mainCategory?.cover ?? "",
                              banner: state.model.mainCategory?.banner ?? "",
                              subcategories: state.editedCategoryList ??
                                  sortList(state.model.subCategories)!
                                      .map(
                                        (e) => SubCategoryEntity(
                                            id: e.subCategoryId!,
                                            numberOfContent: e.driverCount,
                                            image: e.picture!,
                                            isFavorite: e.isFavorite ?? false,
                                            nameEn: e.subCategoryNameEn ?? '',
                                            nameAr: e.subCategoryNameAr ?? ''),
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
          BlocBuilder<SelectCateogryCubit, RiderState>(
            builder: (context, state) {
              if (state is SuccessSelectCateogryState) {
                if (state.type == 1) {
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
                                  return shippingcubit.validation(
                                      message: LocaleKeys
                                          .youHaveToFillYourReceiptPoint
                                          .tr(),
                                      condition: receiptPoint.text.isEmpty);
                                },
                                currentController: receiptPoint,
                                currentFocusNode: receiptPointFocusNode,
                                hint: LocaleKeys.pickupLocation.tr(),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: DefaultTextFormField(
                                isAuthentcation: true,
                                margin: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    maxWidth: double.infinity),
                                validator: (value) {
                                  return shippingcubit.validation(
                                      message: LocaleKeys
                                          .youHaveToFillYourDeliveryPoint
                                          .tr(),
                                      condition: deliveryPoint.text.isEmpty);
                                },
                                currentController: deliveryPoint,
                                currentFocusNode: deliveryPointFocusNode,
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
                                  return shippingcubit.validation(
                                      message:
                                          LocaleKeys.youHaveToFillYourTime.tr(),
                                      condition: time == null);
                                },
                                onTap: () async {
                                  if (context.isUserLoggedIn) {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now());
                                    if (pickedTime != null) {
                                      time = pickedTime;
                                    }
                                  } else {
                                    context.push(Routes.LOGIN);
                                  }

                                  setState(() {});
                                },
                                readOnly: true,
                                currentController: TextEditingController(),
                                currentFocusNode: FocusNode(),
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
                                  return shippingcubit.validation(
                                      message:
                                          LocaleKeys.youHaveToFillYourDate.tr(),
                                      condition: date == null);
                                },
                                onTap: () async {
                                  if (context.isUserLoggedIn) {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate:
                                          DateTime(DateTime.now().year + 150),
                                    );
                                    date = pickedDate;
                                  } else {
                                    context.push(Routes.LOGIN);
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

                        TextFormField(
                          validator: (value) {
                            final regex = RegExp(r'\d{11}');
                            if (decoration.text.isEmpty) {
                              return LocaleKeys.youHaveToFillYourDescription
                                  .tr();
                            } else {
                              if (regex.hasMatch(value ?? "")) {
                                return null;
                              } else {
                                return LocaleKeys
                                        .Phonenumbercannotbewrittenindescription
                                    .tr();
                              }
                            }
                          },
                          controller: decoration,
                          minLines: 3,
                          maxLines: 3,
                          maxLength: 100,
                          onChanged: (value) {
                            log(value.toString());
                            if (!context.isUserLoggedIn) {
                              context.push(Routes.LOGIN);
                            }
                          },
                          focusNode: decorationFocusNode,
                          style:
                              const TextStyle(color: AppColors.QUANTITY_COLOR),
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
                            hintText: LocaleKeys.cargoDescription.tr(),
                            hintStyle: const TextStyle(
                                color: AppColors.QUANTITY_COLOR),
                            counterText:
                                "", // لإخفاء عداد الأحرف الافتراضي خارج الحقل
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
                            Expanded(
                              child: DefaultTextFormField(
                                isAuthentcation: true,
                                margin: EdgeInsets.zero,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  return shippingcubit.validation(
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
                                  return shippingcubit.validation(
                                    message:
                                        LocaleKeys.youHaveToFillYourPhone.tr(),
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
                          text: LocaleKeys.premiumPackageMoreVisibilityCashback
                              .tr(),
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
                                onPressed: () {},
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
                                  if (context.isUserLoggedIn) {
                                    if (widget.formKey.currentState!
                                        .validate()) {
                                      context
                                          .read<CreateTripCubit>()
                                          .createTrip(
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
                                              time:
                                                  "${time!.hour}:${time!.minute}",
                                            ),
                                          );
                                    }
                                  } else {
                                    context.push(Routes.LOGIN);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
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
                return GestureDetector(

                    //   onTap: () {
                    //   setState(() {
                    //     shippingCubit.sortData(category.subcategories![index].id);
                    //     scrollController.jumpTo(0);
                    //     if (select != null) {
                    //       if (select!.id == category.subcategories![index].id) {
                    //         select = null;
                    //       } else {
                    //         select = category.subcategories![index];
                    //       }
                    //     } else {
                    //       select = category.subcategories![index];
                    //     }
                    //     if (select != null) {
                    //       shippingCubit.seSubCategoryRequest(subCategory: select!);
                    //       context.read<SelectCateogryCubit>().select(
                    //           id: category.subcategories![index].id, type: 1);
                    //     }
                    //   });
                    // },
                    onTap: () {
                  setState(() {
                    List<SubCategoryEntity> workingList =
                        category.subcategories!.map((e) {
                      return SubCategoryEntity(
                        id: e.id,
                        nameAr: e.nameAr,
                        nameEn: e.nameEn,
                        image: e.image,
                        hasAuction: e.hasAuction ?? false,
                        isFavorite: e.isFavorite ?? false,
                        numberOfContent: e.numberOfContent ?? 0,
                      );
                    }).toList();

                    final selectedSubCategory = workingList[index];
                    // workingList.removeAt(index);
                    // workingList.insert(0, selectedSubCategory);

                    List<SubCategoryEntity> originalList =
                        BlocProvider.of<ShippingCubit>(context)
                            .bannerModel
                            .subCategories!
                            .map((e) => SubCategoryEntity(
                                  id: e.subCategoryId ?? "",
                                  nameAr: e.subCategoryNameAr ?? "",
                                  nameEn: e.subCategoryNameEn ?? "",
                                  image: e.picture ?? "",
                                  hasAuction: false,
                                  isFavorite: e.isFavorite ?? false,
                                  numberOfContent: e.driverCount ?? 0,
                                ))
                            .toList();
                    shippingCubit.sortData(
                      selectedSubCategory.id,
                      originalList: originalList,
                    );

                    scrollController.jumpTo(0);

                    if (select != null &&
                        select!.id == selectedSubCategory.id) {
                      select = null;
                    } else {
                      select = selectedSubCategory;
                    }

                    if (select != null) {
                      shippingCubit.seSubCategoryRequest(subCategory: select!);
                      context
                          .read<SelectCateogryCubit>()
                          .select(id: workingList[0].id, type: 1);
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
