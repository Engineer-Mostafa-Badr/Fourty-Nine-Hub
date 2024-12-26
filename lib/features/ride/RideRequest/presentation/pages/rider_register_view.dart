import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/rider_register_one.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/rider_register_scand_screen.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/sub_category.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RiderRegisterView extends StatefulWidget {
  const RiderRegisterView({super.key});

  @override
  State<RiderRegisterView> createState() => _RiderRegisterViewState();
}

class _RiderRegisterViewState extends State<RiderRegisterView> {
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode idNumberFocusNode = FocusNode();
  FocusNode plateNumberFocusNode = FocusNode();
  FocusNode vehicleModelFocusNode = FocusNode();
  FocusNode vehicleBrandFocusNode = FocusNode();
  FocusNode vehicleColorFocusNode = FocusNode();

  FocusNode pricingPerKmFocusNode = FocusNode();
  FocusNode vehicleTypeFocusNode = FocusNode();
  FocusNode vehicleYearFocusNode = FocusNode();
  FocusNode model = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController pricingPerKmController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController vehicleYearController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool smoker = false;
  bool isSelectCategory = false;
  @override
  Widget build(BuildContext context) {
    final registerRider = context.read<RegisterRiderCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: BlocConsumer<RegisterRiderCubit, RiderState>(
            listener: (context, state) {
              if (state is SuccessRegisterRiderState) {
                showSuccessMessage(context, state.message);
                context.pushReplacementNamed(Routes.RIDE);
              }
              if (state is FailureRiderState) {
                showErrorMessage(
                    context, getFailureMessage(state.failure, context));
              }
              // if (state is SuccessRegisterState) {

              // }
            },
            builder: (context, state) {
              if (state is LoadingRiderState) {
                return const Align(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // const Gap(30),
                    Text(
                      "Welcome to Ride Register",
                      style: Styles.headerText(
                        fontSize: 40,
                        color: AppColors.PRIMARY_COLOR_DARK,
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // const Gap(40),
                    Center(
                      child: BlocBuilder<GetCateogryRiderCubit, RiderState>(
                        builder: (context, state) {
                          if (state is SuccessGetCateogyRider) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gap(8),
                                const SizedBox(
                                  height: 8,
                                ),
                                FormField(
                                  validator: (value) {
                                    log(value.toString());
                                    return registerRider.validation(
                                      message: LocaleKeys
                                          .chooseYourFavoriteSubCategory
                                          .tr(),
                                      condition:
                                          registerRider.model.subcategoryId ==
                                              null,
                                    );
                                  },
                                  builder: (field) {
                                    if (!isSelectCategory) {
                                      return ViewRideCategory(
                                          onChanged: () {
                                            setState(() {
                                              selectRegisterType(context
                                                  .read<RegisterRiderCubit>());
                                              log(isSelectCategory.toString(),
                                                  name: "isSelectCategory");
                                              isSelectCategory =
                                                  !isSelectCategory;
                                            });
                                          },
                                          list: state.model.subCategories ?? [],
                                          containsList:
                                              state.model.subCategories ?? []);
                                    } else {
                                      if (registerRider
                                          .SELECTED_NO_SOCKET_SUBCATEGORY_IDS
                                          .isNotEmpty) {
                                        return ViewRideCategory(
                                            onChanged: () {
                                              setState(() {
                                                log("SELECTED_NO_SOCKET_SUBCATEGORY_IDS");
                                                selectRegisterType(context.read<
                                                    RegisterRiderCubit>());
                                                isSelectCategory = true;
                                              });
                                            },
                                            list: parsSubCategory(
                                                subCategorys:
                                                    state.model.subCategories ??
                                                        [],
                                                subCategorysIds: registerRider
                                                    .NO_SOCKET_SUBCATEGORY_IDS),
                                            containsList: registerRider
                                                .SELECTED_NO_SOCKET_SUBCATEGORY_IDS);
                                      }
                                      if (registerRider
                                          .SELECTED_RICH_VALID_SUBCATEGORY_IDS
                                          .isNotEmpty) {
                                        return ViewRideCategory(
                                            onChanged: () {
                                              setState(() {
                                                log("SELECTED_RICH_VALID_SUBCATEGORY_IDS");
                                                selectRegisterType(context.read<
                                                    RegisterRiderCubit>());

                                                if (registerRider
                                                    .SELECTED_RICH_VALID_SUBCATEGORY_IDS
                                                    .isEmpty) {
                                                } else {
                                                  isSelectCategory = true;
                                                }

                                                log(
                                                    registerRider
                                                        .selectedSubCategoryList
                                                        .toString(),
                                                    name: "lskdjflskdjflskdjf");
                                              });
                                            },
                                            list: parsSubCategory(
                                                subCategorys:
                                                    state.model.subCategories ??
                                                        [],
                                                subCategorysIds: registerRider
                                                    .RICH_VALID_SUBCATEGORY_IDS),
                                            containsList: registerRider
                                                .selectedSubCategoryList);
                                      }
                                      if (registerRider
                                          .SELECTED_WOMEN_SUBCATEGORY_IDS
                                          .isNotEmpty) {
                                        return ViewRideCategory(
                                            onChanged: () {
                                              log("SELECTED_WOMEN_SUBCATEGORY_IDS");
                                              setState(() {
                                                selectRegisterType(context.read<
                                                    RegisterRiderCubit>());
                                                isSelectCategory = true;
                                              });
                                            },
                                            list: parsSubCategory(
                                                subCategorys:
                                                    state.model.subCategories ??
                                                        [],
                                                subCategorysIds: registerRider
                                                    .WOMEN_SUBCATEGORY_IDS),
                                            containsList: registerRider
                                                .SELECTED_RICH_VALID_SUBCATEGORY_IDS);
                                      } else if (registerRider
                                          .SELECTED_SOCKET_CATEGORY_IDS
                                          .isNotEmpty) {
                                        log("SELECTED_SOCKET_CATEGORY_IDS");
                                        return ViewRideCategory(
                                            onChanged: () {
                                              log("SELECTED_SOCKET_CATEGORY_IDS");
                                              setState(() {
                                                selectRegisterType(context.read<
                                                    RegisterRiderCubit>());
                                                isSelectCategory = true;
                                              });
                                            },
                                            list: parsSubCategory(
                                                subCategorys:
                                                    state.model.subCategories ??
                                                        [],
                                                subCategorysIds: registerRider
                                                    .SOCKET_CATEGORY_IDS),
                                            containsList: registerRider
                                                .SELECTED_SOCKET_CATEGORY_IDS);
                                      } else {
                                        return ViewRideCategory(
                                            onChanged: () {
                                              setState(() {
                                                selectRegisterType(context.read<
                                                    RegisterRiderCubit>());
                                                isSelectCategory = true;
                                              });
                                            },
                                            list:
                                                state.model.subCategories ?? [],
                                            containsList:
                                                state.model.subCategories ??
                                                    []);
                                      }
                                    }

                                    // return Column(
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //     DropdownMenu<SubCategoryEntity>(
                                    //       inputDecorationTheme:
                                    //           InputDecorationTheme(
                                    //         hintStyle: const TextStyle(
                                    //             fontSize: 16,
                                    //             color: AppColors.PRIMARY_COLOR,
                                    //             fontWeight: FontWeight.w600),
                                    //         border: OutlineInputBorder(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(10),
                                    //             borderSide: BorderSide(
                                    //                 color: field.hasError
                                    //                     ? Colors.red
                                    //                     : Colors.grey)),
                                    //         errorBorder: OutlineInputBorder(
                                    //           borderRadius:
                                    //               BorderRadius.circular(10),
                                    //           borderSide: BorderSide(
                                    //             color: field.hasError
                                    //                 ? Colors.red
                                    //                 : Colors.black,
                                    //           ),
                                    //         ),
                                    //         enabledBorder: OutlineInputBorder(
                                    //           borderRadius:
                                    //               BorderRadius.circular(10),
                                    //           borderSide: BorderSide(
                                    //             color: field.hasError
                                    //                 ? Colors.red
                                    //                 : Colors.black,
                                    //           ),
                                    //         ),
                                    //         focusedBorder: OutlineInputBorder(
                                    //           borderRadius:
                                    //               BorderRadius.circular(10),
                                    //           borderSide: BorderSide(
                                    //             color: field.hasError
                                    //                 ? Colors.red
                                    //                 : Colors.black,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       width: MediaQuery.of(context)
                                    //               .size
                                    //               .width *
                                    //           0.95,
                                    //       hintText: LocaleKeys.subCategory.tr(),
                                    //       dropdownMenuEntries:
                                    //           state.model.subCategories!
                                    //               .map(
                                    //                 (e) => SubCategoryEntity(
                                    //                     id: e.subCategoryId!,
                                    //                     image: e.picture ?? "",
                                    //                     isFavorite: false,
                                    //                     nameEn:
                                    //                         e.subCategoryNameEn ??
                                    //                             "",
                                    //                     nameAr:
                                    //                         e.subCategoryNameAr ??
                                    //                             ""),
                                    //               )
                                    //               .map(
                                    //                 (e) => DropdownMenuEntry<
                                    //                     SubCategoryEntity>(
                                    //                   value: e,
                                    //                   label: e.nameEn,
                                    //                 ),
                                    //               )
                                    //               .toList(),
                                    //       onSelected: (value) {
                                    //         setState(() {
                                    //           registerRider.model
                                    //               .subcategoryId = value!.id;
                                    //           // if (context.isUserLoggedIn) {
                                    //           //   if (value != null) {
                                    //           // registerRider.model
                                    //           //     .subcategoryId = value.id;
                                    //           //     // shippingcubit.selectSubCategory(
                                    //           //     //     subCategory: value);
                                    //           //     // field.didChange(
                                    //           //     //     value); // تحديث حالة الفاليديشن
                                    //           //   }
                                    //           // } else {
                                    //           //   context.push(Routes.LOGIN);
                                    //           // }
                                    //         });
                                    //       },
                                    //     ),
                                    //     const SizedBox(
                                    //       height: 8,
                                    //     ),
                                    //     if (field.hasError)
                                    //       Padding(
                                    //         padding: const EdgeInsets.symmetric(
                                    //           horizontal: 15,
                                    //         ),
                                    //         child: Text(
                                    //           field.errorText ?? "",
                                    //           style: Styles.mediumText(
                                    //             color: Colors.red,
                                    //           ),
                                    //         ),
                                    //       )
                                    //   ],
                                    // );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    // RiderRegisterOne(
                    //   formKey: formKey,
                    // ),
                    // RiderRegisterScandScreen(
                    //   formKey: formKey,
                    // ),
                    selectRegisterType(registerRider),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<SubCategory> parsSubCategory(
      {required List<SubCategory> subCategorys,
      required List subCategorysIds}) {
    List<SubCategory> subCategorysParsing = [];
    for (var item in subCategorys) {
      if (subCategorysIds.contains(item.subCategoryId)) {
        subCategorysParsing.add(item);
      }
    }
    log(subCategorysParsing.toString());
    return subCategorysParsing;
  }

  selectRegisterType(RegisterRiderCubit registerCubit) {
    if (registerCubit.SELECTED_NO_SOCKET_SUBCATEGORY_IDS.isNotEmpty) {
      log("RiderRegisterOne");
      return RiderRegisterScandScreen(
        formKey: formKey,
      );
    } else {
      log("RiderRegisterScandScreen");
      return RiderRegisterOne(
        formKey: formKey,
      );
    }
    // if (registerCubit.model.subcategoryId == "62c8ba9f8e28a58a3edf57eb" ||
    //     registerCubit.model.subcategoryId == "62c8baa08e28a58a3edf57ed" ||
    //     registerCubit.model.subcategoryId == "62c8baa18e28a58a3edf57ef" ||
    //     registerCubit.model.subcategoryId == "62c8baa28e28a58a3edf57f1" ||
    //     registerCubit.model.subcategoryId == "62c8baa38e28a58a3edf57f3" ||
    //     registerCubit.model.subcategoryId == "62ea012a69ea29c91dfc3917" ||
    //     registerCubit.model.subcategoryId == "6698736fdaa111da2d775627") {
    //   log("one");
    //   return RiderRegisterOne(
    //     formKey: formKey,
    //   );
    // } else {
    //   log("tow");
    //   return RiderRegisterScandScreen(
    //     formKey: formKey,
    //   );
    // }
  }
}

class ViewRideCategory extends StatefulWidget {
  const ViewRideCategory(
      {super.key,
      required this.list,
      required this.containsList,
      required this.onChanged});
  final List<SubCategory> list;
  final List<SubCategory> containsList;
  final void Function() onChanged;
  @override
  State<ViewRideCategory> createState() => _ViewRideCategoryState();
}

class _ViewRideCategoryState extends State<ViewRideCategory> {
  @override
  Widget build(BuildContext context) {
    var registerRider = context.read<RegisterRiderCubit>();
    return StaggeredGrid.count(
      crossAxisCount: 2,
      children: [
        ...List.generate(
          widget.list.length,
          (index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(widget.list[index].subCategoryNameEn ?? ""),
                Checkbox(
                  value: registerRider.selectedSubCategoryList
                      .contains(widget.list[index]),
                  onChanged: (value) {
                    widget.onChanged();
                    context
                        .read<RegisterRiderCubit>()
                        .selectSubCategory(subCategory: widget.list[index]);
                    setState(() {});
                  },
                )
              ],
            );
          },
        )
      ],
    );
  }
}
