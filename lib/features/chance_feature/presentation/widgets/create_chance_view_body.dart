import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/controller/cubit/chance_cubit.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/controller/cubit/chance_states.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/add_image_widget.dart';

import '../../../../common/models/public/pagination_params.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locales.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import '../../../account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import '../../domain/entity/main_category_drop_entity.dart';
import '../../domain/use_case/create_chance_ad_use_case.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class CreateChanceViewBody extends StatefulWidget {
  const CreateChanceViewBody({super.key});

  @override
  State<CreateChanceViewBody> createState() => _CreateChanceViewBodyState();
}

class _CreateChanceViewBodyState extends State<CreateChanceViewBody> {
  var titleController = TextEditingController();

  var desController = TextEditingController();

  var priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedCategory;
  String? selectedSubCategory;
  List<MainCategoryDropEntity> categories = [];
  List<MainCategoryWalletEntity> subCategories = [];
  bool isCategoryLoading = true;
  bool isSubCategoryLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    final categories = await context
        .read<ChanceCubit>()
        .fetchMainCategoryChance(paginationParams: PaginationParams(page: 1));
    setState(() {
      this.categories = categories;
      isCategoryLoading = false;
    });
  }

  void _fetchSubCategories(String categoryId) async {
    setState(() {
      isSubCategoryLoading = true;
    });
    final subCategories = await context
        .read<WalletCubit>()
        .fetchSubCategoryWallet(
            id: categoryId, paginationParams: PaginationParams(page: 1));
    setState(() {
      this.subCategories = subCategories;
      isSubCategoryLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChanceCubit, ChanceState>(
      listener: (BuildContext context, state) {
        // Only show success message when the ad is created, not when uploading images
        if (state.status == ChanceStates.createSuccess) {
          showSuccessMessage(context, 'Create Chance Ad Successfully');
          titleController.clear();
          desController.clear();
          priceController.clear();
          setState(() {
            selectedCategory = null;
            selectedSubCategory = null;
          });
        }
      },
      builder: (BuildContext context, Object? state) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        boxShadow: AppColors.SHADOW_LIGHT,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.payAtLeast1.localize,
                          textAlign: TextAlign.center,
                          style: Styles.headerText(
                              color: AppColors.SECONDARY_COLOR),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          LocaleKeys.oneUserWillR.localize,
                          textAlign: TextAlign.center,
                          style: Styles.mediumText(),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          LocaleKeys.moreSubscriptionMore.localize,
                          textAlign: TextAlign.center,
                          style: Styles.mediumText(
                              color: AppColors.CHECK_MARK_COLOR,
                              fontSize: 65.sp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    children: [
                      // Category Dropdown
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          hint: Text(
                            selectedCategory ??
                                LocaleKeys.selectCategory.localize,
                            style: TextStyle(
                              fontSize: 30.sp,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          // menuWidth: double.infinity,
                          menuMaxHeight: 200,
                          dropdownColor: Theme.of(context).primaryColor,
                          value: selectedCategory,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          icon: Icon(Icons.arrow_drop_down,
                              size: 50.sp,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          items: isCategoryLoading
                              ? [
                                  DropdownMenuItem(
                                    value: null,
                                    child: Label(
                                      text: LocaleKeys.selectCategory.localize,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ]
                              : categories.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category.id,
                                    child: Text(
                                      context.locale == Locales.english
                                          ? category.nameEn
                                          : category.nameAr,
                                      style: TextStyle(
                                        fontSize: 30.sp,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          onChanged: (newCategoryId) {
                            setState(() {
                              selectedCategory = newCategoryId;
                              selectedSubCategory = null;
                            });
                            if (newCategoryId != null) {
                              _fetchSubCategories(newCategoryId);
                            }
                          },
                        ),
                      ),
                      // Subcategory Dropdown (only show when a category is selected)
                      if (selectedCategory != null) ...[
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: DropdownButton<String>(
                            hint: Text(
                              selectedSubCategory ??
                                  LocaleKeys.selectSubCategory.localize,
                              style: TextStyle(
                                fontSize: 30.sp,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                            underline: const SizedBox.shrink(),
                            // menuWidth: double.infinity,
                            menuMaxHeight: 200,
                            dropdownColor: Theme.of(context).primaryColor,
                            value: selectedSubCategory,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down,
                                size: 50.sp,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            items: isSubCategoryLoading
                                ? [
                                    DropdownMenuItem(
                                        value: null,
                                        child: Label(
                                          text: LocaleKeys
                                              .selectSubCategory.localize,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ))
                                  ]
                                : subCategories.map((subCategory) {
                                    return DropdownMenuItem<String>(
                                      value: subCategory.id,
                                      child: Text(
                                        context.locale == Locales.english
                                            ? subCategory.nameEn
                                            : subCategory.nameAr,
                                        style: TextStyle(
                                          fontSize: 30.sp,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            onChanged: (newSubCategoryId) {
                              setState(() {
                                selectedSubCategory = newSubCategoryId;
                              });
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const AddImageWidget(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    LocaleKeys.title.localize,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    controller: titleController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.title),
                      hintText: LocaleKeys.enterTitle.localize,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.desc.localize,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description ';
                      }
                      return null;
                    },
                    controller: desController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.description),
                      hintText: LocaleKeys.enterDescription.localize,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.price.localize,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Price';
                      }
                      return null;
                    },
                    controller: priceController,
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.attach_money),
                      hintText: LocaleKeys.enterPrice.localize,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {},
                    keyboardType:
                        TextInputType.number, // To show numeric keyboard
                  ),
                  SizedBox(height: 60.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ManageVibration.vibrate();
                        if (_formKey.currentState!.validate()) {
                          if (selectedCategory != null &&
                              selectedSubCategory != null) {
                            // Get uploaded image IDs from state
                            final cubit = context.read<ChanceCubit>();
                            final mediaIds = cubit.state.uploadedImageIds;

                            // Use new API
                            cubit.createChanceAd(CreateChanceAdParams(
                              mainCategoryId: selectedCategory!,
                              subCategoryId: selectedSubCategory!,
                              title: titleController.text,
                              price: double.parse(priceController.text),
                              description: desController.text,
                              mediaIds: mediaIds.isNotEmpty
                                  ? mediaIds
                                  : [
                                      '669262c894fa0441718b74c9'
                                    ], // fallback to default image
                            ));
                          } else {
                            showErrorMessage(context,
                                'Please Enter Main Category and Sub Category');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 25.h),
                        backgroundColor: AppColors.PRIMARY_COLOR,
                      ),
                      child: Text(
                        LocaleKeys.CreateChance.localize,
                        style: Styles.mediumText(
                          color: Colors.white,
                          fontSize: 55.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
