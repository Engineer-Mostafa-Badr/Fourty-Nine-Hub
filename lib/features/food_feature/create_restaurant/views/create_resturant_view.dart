import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
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
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../common/widgets/stateless/labels/label.dart';

class CreateRestaurantForm extends StatefulWidget {
  final String? from;
  final String? restaurantId;

  CreateRestaurantForm({super.key, this.from, this.restaurantId});

  @override
  State<CreateRestaurantForm> createState() => _CreateRestaurantFormState();
}

class _CreateRestaurantFormState extends State<CreateRestaurantForm> {
  bool editFood = false;

  @override
  Widget build(BuildContext context) {
    print(widget.from.toString() + 'sdkvjbskdvblkn');
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
      child: Scaffold(
        appBar: const HomeAppbar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        editFood = false;
                      });
                    },
                    child: Label(
                      text: widget.from == 'update'
                          ? 'Update your Restaurant'
                          : LocaleKeys.welcomeToResturantRegisteration.tr(),
                      style:
                          Styles.headerText(color: AppColors.SECONDARY_COLOR),
                    ),
                  ),
                  const Spacer(),
                  ElevatedAppButton(
                    label: 'Edit Food',
                    onPressed: () {
                      setState(() {
                        editFood = true;
                      });
                    },
                    textStyle: Styles.mediumText(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Sizer(height: 20.h),
              const CreateResturantSubcategoryDropdown(),
              Sizer(height: 20.h),
              const CreateRestaurantNameField(),
              Sizer(height: 20.h),
              const CreateRestaurantNumberField(),
              Sizer(height: 20.h),
              const CreateRestaurantProfilePhotoPicker(),
              Sizer(height: 20.h),
              if (widget.from != 'update')
                const CreateRestaurantLicensePhotoPicker(),
              Sizer(height: 20.h),
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

              /// mneu
              if (widget.from != 'update')
                BlocProvider(
                  create: (_) => RestaurantMenuCubit(serviceLocator()),
                  child: ShowMneu(from: 'update'),
                ),
              Sizer(height: 20.h),

              AppInfoText(
                  text: LocaleKeys
                      .theApplicationDoesNotDeductAnyPercentageFromTheServiceProvider
                      .tr()),
              Sizer(height: 20.h),
              AppInfoText(
                  text: LocaleKeys.youWillGetEGP3650PerYearIfYouSubscribeDaily
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
                              .updateRestaurant1(context, widget.restaurantId);
                          if (res == 'success') {
                            Navigator.pop(context);
                          }
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
        ),
      ),
    );
  }
}
