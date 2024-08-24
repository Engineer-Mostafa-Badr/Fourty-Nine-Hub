import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/location/cities_dropdowns.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/location/governorate_dropdown.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/mneu/show_menu.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/name/name_filed.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/photo/license_photo_picker.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/photo/restaurant_photo_picker.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/subcategory.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/register_resturant/submit_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';

class CreateResturantView extends StatelessWidget {
  const CreateResturantView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRestaurantCubit, CreateRestaurantState>(
      listener: (context, state) {
        switch (state) {
          case CreateResturantLoading _:
            showLoadingDialog(context);
            break;
          case CreateResturantCloseLoading _:
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
              Label(
                  text: LocaleKeys.welcomeToResturantRegisteration.localize,
                  style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
              const Sizer(height: 20),
              const CreateResturantSubcategoryDropdown(),
              const Sizer(height: 20),
              const CreateRestaurantNameField(),
              const Sizer(height: 20),
              const CreateRestaurantProfilePhotoPicker(),
              const Sizer(height: 20),
              const CreateRestaurantLicensePhotoPicker(),
              const Sizer(height: 20),
              CreateRestaurantGovernorateDropdown(
                onSelected: (value) {
                  if (value != null) {
                    context
                        .read<CreateRestaurantCubit>()
                        .selectGovernorate(value);
                  }
                },
              ),
              const Sizer(height: 20),
              const CreateRestaurantCitiesDropdowns(),
              const Sizer(height: 20),

              /// mneu
              BlocProvider(
                create: (_) => RestaurantMenuCubit(),
                child: ShowMneu(),
              ),
              const Sizer(height: 20),

              AppInfoText(
                  text: LocaleKeys
                      .theApplicationDoesNotDeductAnyPercentageFromTheServiceProvider
                      .localize),
              const Sizer(height: 20),
              AppInfoText(
                  text: LocaleKeys
                      .youWillGetEGP3650PerYearIfYouSubscribeDaily.localize),
              const Sizer(height: 20),
              const CreateRestaurantSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
