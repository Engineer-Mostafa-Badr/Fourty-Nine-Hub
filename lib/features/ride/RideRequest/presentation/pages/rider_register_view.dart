import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/screens/ride_no_socket_parts_screen.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/screens/ride_socket_parts_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/ride_register_socket_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/rider_register_no_socket_screen.dart';
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
  bool smoker = false;
  bool isSelectCategory = false;
  @override
  Widget build(BuildContext context) {
    final registerRider = context.read<RegisterRiderCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: Form(
        key: context.read<RegisterRiderCubit>().socketFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        context.isArabic
                            ? "مرحبًا بكم في تسجيل توصيلة"
                            : "Welcome to Ride Register",
                        style: Styles.headerText(
                          fontSize: 40,
                          color: AppColors.PRIMARY_COLOR_DARK,
                        ),
                      ),
                    ),
                    const Sizer(),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: context.isDarkMode
                              ? AppColors.UNSELECTED_DARK_GRAY_COLOR
                              : Colors.white,
                          boxShadow: context.isDarkMode
                              ? []
                              : [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 30)
                                ]),
                      child: Center(
                        child: BlocBuilder<GetCateogryRiderCubit, RiderState>(
                          builder: (context, state) {
                            if (state is SuccessGetCateogyRider) {
                              // return Container(
                              //   child: StaggeredGrid.count(
                              //     crossAxisCount: 2,
                              //     children: state.model.subCategories!.map(
                              //       (e) => SubCategoryRideCard(model: e,),
                              //     ).toList(),
                              //   ),
                              // );
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
                                        message: context.isArabic
                                            ? "اختر الفئة الفرعية المفضلة لديك!"
                                            : "Choose your favorite sub category!",
                                        condition: validatie(registerRider),
                                      );
                                    },
                                    builder: (field) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              if (!isSelectCategory) {
                                                return ViewRideCategory(
                                                    onChanged: () {
                                                      setState(() {
                                                        selectRegisterType(
                                                            context.read<
                                                                RegisterRiderCubit>());
                                                        log(
                                                            isSelectCategory
                                                                .toString(),
                                                            name:
                                                                "isSelectCategory");
                                                        isSelectCategory =
                                                            !isSelectCategory;
                                                      });
                                                    },
                                                    list: state.model
                                                            .subCategories ??
                                                        [],
                                                    containsList: state.model
                                                            .subCategories ??
                                                        []);
                                              } else {
                                                if (registerRider
                                                    .SELECTED_NO_SOCKET_SUBCATEGORY_IDS
                                                    .isNotEmpty) {
                                                  return ViewRideCategory(
                                                      onChanged: () {
                                                        setState(() {
                                                          log("SELECTED_NO_SOCKET_SUBCATEGORY_IDS");
                                                          selectRegisterType(
                                                              context.read<
                                                                  RegisterRiderCubit>());
                                                          isSelectCategory =
                                                              true;
                                                        });
                                                      },
                                                      list: parsSubCategory(
                                                          subCategorys: state
                                                                  .model
                                                                  .subCategories ??
                                                              [],
                                                          subCategorysIds:
                                                              registerRider
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
                                                          selectRegisterType(
                                                              context.read<
                                                                  RegisterRiderCubit>());

                                                          if (registerRider
                                                              .SELECTED_RICH_VALID_SUBCATEGORY_IDS
                                                              .isEmpty) {
                                                          } else {
                                                            isSelectCategory =
                                                                true;
                                                          }

                                                          log(
                                                              registerRider
                                                                  .selectedSubCategoryList
                                                                  .toString(),
                                                              name:
                                                                  "lskdjflskdjflskdjf");
                                                        });
                                                      },
                                                      list: parsSubCategory(
                                                          subCategorys: state
                                                                  .model
                                                                  .subCategories ??
                                                              [],
                                                          subCategorysIds:
                                                              registerRider
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
                                                          selectRegisterType(
                                                              context.read<
                                                                  RegisterRiderCubit>());
                                                          isSelectCategory =
                                                              true;
                                                        });
                                                      },
                                                      list: parsSubCategory(
                                                          subCategorys: state
                                                                  .model
                                                                  .subCategories ??
                                                              [],
                                                          subCategorysIds:
                                                              registerRider
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
                                                          selectRegisterType(
                                                              context.read<
                                                                  RegisterRiderCubit>());
                                                          isSelectCategory =
                                                              true;
                                                        });
                                                      },
                                                      list: parsSubCategory(
                                                          subCategorys: state
                                                                  .model
                                                                  .subCategories ??
                                                              [],
                                                          subCategorysIds:
                                                              registerRider
                                                                  .SOCKET_CATEGORY_IDS),
                                                      containsList: registerRider
                                                          .SELECTED_SOCKET_CATEGORY_IDS);
                                                } else {
                                                  return ViewRideCategory(
                                                      onChanged: () {
                                                        setState(() {
                                                          selectRegisterType(
                                                              context.read<
                                                                  RegisterRiderCubit>());
                                                          isSelectCategory =
                                                              true;
                                                        });
                                                      },
                                                      list: state.model
                                                              .subCategories ??
                                                          [],
                                                      containsList: state.model
                                                              .subCategories ??
                                                          []);
                                                }
                                              }
                                            },
                                          ),
                                          if (field.hasError)
                                            Column(
                                              children: [
                                                const Sizer(),
                                                Text(
                                                  field.errorText.toString(),
                                                  style: Styles.mediumText(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                        ],
                                      );
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
                    ),
                    const Sizer(
                      height: 30,
                    ),
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

  validatie(RegisterRiderCubit registerRider) {
    log(registerRider.selectedSubCategoryList.toString());
    log(registerRider.selectedSubCategoryNoSocket.toString());
    if (registerRider.selectedSubCategoryList.isNotEmpty) {
      return false;
    } else {
      if (registerRider.selectedSubCategoryNoSocket == null) {
        return true;
      } else {
        return false;
      }
    }
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
      return const RideNoSocketPartsScreen();
      return RiderRegisterNoSocketScreen(
        formKey: context.read<RegisterRiderCubit>().socketFormKey,
      );
    } else {
      log("RiderRegisterScandScreen");
      return Column(
        children: [
          const RideSocketPartsScreen(),
          RideRegisterSocketScreen(
        formKey: context.read<RegisterRiderCubit>().socketFormKey,
      )
        ],
      );
      return RideRegisterSocketScreen(
        formKey: context.read<RegisterRiderCubit>().socketFormKey,
      );
    }
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
      crossAxisCount: 1,
      children: [
        ...List.generate(
          widget.list.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.list[index].picture ?? ""))),
                  ),
                  const Sizer(),
                  Text((context.isArabic
                          ? widget.list[index].subCategoryNameAr
                          : widget.list[index].subCategoryNameEn) ??
                      ""),
                  const Spacer(),
                  Checkbox(
                    value: registerRider.selectedSubCategoryList
                        .contains(widget.list[index]),
                    onChanged: (value) {
                      log(widget.list[index].subCategoryId.toString());
                      widget.onChanged();
                      context
                          .read<RegisterRiderCubit>()
                          .selectSubCategory(subCategory: widget.list[index]);
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
