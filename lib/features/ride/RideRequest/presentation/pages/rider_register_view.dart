import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/rider_register_one.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/rider_register_scand_screen.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

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
                            log(state.toString(),
                                name: "llllllllllllllllllllll");

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
                                      message:
                                          "Choose your favorite Sub Category!",
                                      condition:
                                          registerRider.model.subcategoryId ==
                                              null,
                                    );
                                  },
                                  builder: (field) {
                                    // field.dispose();
                                    // field.activate
                                    // log(field.hasError.toString(),
                                    //     name: "field");
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownMenu<SubCategoryEntity>(
                                          inputDecorationTheme:
                                              InputDecorationTheme(
                                            hintStyle: const TextStyle(
                                                fontSize: 16,
                                                color: AppColors.PRIMARY_COLOR,
                                                fontWeight: FontWeight.w600),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: field.hasError
                                                        ? Colors.red
                                                        : Colors.grey)),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: field.hasError
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: field.hasError
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: field.hasError
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          hintText: "Sub Category",
                                          dropdownMenuEntries: state
                                              .model.subCategories!
                                              .map(
                                                (e) => SubCategoryEntity(
                                                  id: e.subCategoryId!,
                                                  image: e.picture ?? "",
                                                  isFavorite: false,
                                                  nameEn:
                                                      e.subCategoryNameEn ?? "",
                                                nameAr:
                                                      e.subCategoryNameAr ?? "",
                                                ),
                                              )
                                              .map(
                                                (e) => DropdownMenuEntry<
                                                    SubCategoryEntity>(
                                                  value: e,
                                                  label: context.isArabic?e.nameAr:e.nameEn,
                                                ),
                                              )
                                              .toList(),
                                          onSelected: (value) {
                                            setState(() {
                                              if (value != null) {
                                                registerRider.model
                                                    .subcategoryId = value.id;
                                                // shippingcubit.selectSubCategory(
                                                //     subCategory: value);
                                                // field.didChange(
                                                //     value); // تحديث حالة الفاليديشن
                                              }
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        if (field.hasError)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Text(
                                              field.errorText ?? "",
                                              style: Styles.mediumText(
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
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

  selectRegisterType(RegisterRiderCubit registerCubit) {
    log(registerCubit.model.subcategoryId.toString(), name: "lllddkkdkdkdkdkd");
    if (registerCubit.model.subcategoryId == "62c8ba9f8e28a58a3edf57eb" ||
        registerCubit.model.subcategoryId == "62ea012a69ea29c91dfc3917" ||
        registerCubit.model.subcategoryId == "6698736fdaa111da2d775627" ||
        registerCubit.model.subcategoryId == "62c8baa28e28a58a3edf57f1" ||
        registerCubit.model.subcategoryId == "62c8baa38e28a58a3edf57f3" ||
        registerCubit.model.subcategoryId == "62c8ba9e8e28a58a3edf57e9") {
      log("one");
      return RiderRegisterOne(
        formKey: formKey,
      );
    } else {
      log("tow");
      return RiderRegisterScandScreen(
        formKey: formKey,
      );
    }
  }
}
