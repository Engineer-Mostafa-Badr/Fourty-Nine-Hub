import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/location/cities_dropdowns.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/location/governorate_dropdown.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/mneu/show_menu.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/name/name_filed.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/photo/license_photo_picker.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/photo/restaurant_photo_picker.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/subcategory.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/submit_button.dart';
import 'package:fourtyninehub/features/food_feature/edit_food/presentation/pages/edit_food_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widget/custom_scaffold.dart';

class CreateRestaurantForm extends StatefulWidget {
  final String? from;
  final String? restaurantId;
  final String? subcategoryId;

  const CreateRestaurantForm(
      {super.key, this.from, this.restaurantId, this.subcategoryId});

  @override
  State<CreateRestaurantForm> createState() => _CreateRestaurantFormState();
}

class _CreateRestaurantFormState extends State<CreateRestaurantForm> {
  bool editFood = false;

  @override
  initState() {
    context.read<CreateRestaurantCubit>().loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.from}sdkvjbskdvblkn');
    return BlocListener<CreateRestaurantCubit, CreateRestaurantState>(
      listener: (context, state) {
        switch (state) {
          case CreateResturantLoading _:
            showLoadingDialog(context);
            break;
          case CreateRestaurantCloseLoading _:
            Navigator.pop(context);
            break;
          case CreateResturantError _:
            showErrorMessage(context, state.message);
            break;
          case CreateRestaurantSuccess _:
            showSuccessMessage(context, state.message);
            break;
          default:
            break;
        }
      },
      child: CustomScaffold(
          appBar: const HomeAppbar(isWithBackArrow: true,),
          body: BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
              builder: (context, state) {
            if (state is CreateRestaurantLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                editFood = false;
                              });
                            },
                            child: Text(
                              widget.from == 'update'
                                  ? LocaleKeys.updateYourRestaurant.localize
                                  : context.isArabic?'مرحباً بك في تسجيل مطعم':LocaleKeys.welcomeToResturantRegisteration
                                      .tr(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.headerText(
                                  color: AppColors.getRedColor(context)),
                            ),
                          ),
                        ),
                        if (widget.from == 'update')
                          ElevatedAppButton(
                            label: LocaleKeys.editFood.localize,
                            onPressed: () {
                              context.push(Routes.EditFoodView,
                                  extra: EditFoodParams(
                                      restaurantId: widget.restaurantId ?? '',
                                      subCategoryId:
                                          widget.subcategoryId ?? ''));
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => BlocProvider.value(
                              //         value: serviceLocator<RestaurantDetailsCubit>(),
                              //         child:
                              //             EditFoodView(payload: widget.restaurantId!),
                              //       ),
                              //     ));
                              setState(() {
                                editFood = true;
                              });
                            },
                            textStyle: Styles.mediumText(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                      ],
                    ),
                    Sizer(height: 32.h),
                    const CreateResturantSubcategoryDropdown(),
                    Sizer(height: 20.h),
                    const CreateRestaurantNameField(),
                    Sizer(height: 20.h),
                     CreateRestaurantNumberField(restaurantNumber: '' ),
                    Sizer(height: 20.h),
                    CreateRestaurantProfilePhotoPicker(
                      subcategoryId: widget.subcategoryId,
                    ),
                    Sizer(height: 20.h),
                    if (widget.from != 'update')
                      const CreateRestaurantLicensePhotoPicker(),
                    Sizer(height: 30.h),
                    CreateRestaurantGovernorateDropdown(
                      onSelected: (value) {
                        if (value != null) {
                          context
                              .read<CreateRestaurantCubit>()
                              .selectGovernorate(value);
                        }
                      },
                    ),
                    Sizer(height: 20.h),
                    const CreateRestaurantCitiesDropdowns(),
                    Sizer(height: 20.h),
                    /// menu
                    if (widget.from != 'update')
                      BlocProvider(
                        create: (_) => RestaurantMenuCubit(serviceLocator()),
                        child: ShowMneu(),
                      ),
                    Sizer(height: 20.h),

                    AppInfoText(
                        text: LocaleKeys
                            .theApplicationDoesNotDeductAnyPercentageFromTheServiceProvider
                            .tr()),
                    Sizer(height: 20.h),
                    AppInfoText(
                        text: LocaleKeys
                            .youWillGetEGP3650PerYearIfYouSubscribeDaily
                            .tr()),
                    Sizer(height: 20.h),
                    if (widget.from == 'update')
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedAppButton(
                              onPressed: () async {
                                var res = await context
                                    .read<CreateRestaurantCubit>()
                                    .updateRestaurant1(context);
                                // if (res == 'success') {
                                //   Navigator.pop(context);
                                // }
                              },
                              label: LocaleKeys.update.tr(),
                              textStyle: Styles.headerText(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    else
                      const CreateRestaurantSubmitButton(),
                  ],
                ),
              );
            }
          })),
    );
  }
}
