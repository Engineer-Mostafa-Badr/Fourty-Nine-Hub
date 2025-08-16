import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../common/widgets/stateless/buttons/elevated_button.dart';
import '../../../../common/widgets/stateless/labels/info_text.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/messages/messages.dart';
import '../cubit/create_menu_cubit/create_menu_cubit.dart';
import '../cubit/create_resturant_cubit.dart';
import 'widgets/location/cities_dropdowns.dart';
import 'widgets/location/governorate_dropdown.dart';
import 'widgets/mneu/show_menu.dart';
import 'widgets/name/name_filed.dart';
import 'widgets/photo/license_photo_picker.dart';
import 'widgets/photo/restaurant_photo_picker.dart';
import 'widgets/subcategory.dart';
import 'widgets/submit_button.dart';
import '../../edit_food/presentation/pages/edit_food_view.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../../../helpers/manage_vibration.dart';

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
  final FocusNode nameFocusNode = FocusNode();

  @override
  initState() {
    context.read<CreateRestaurantCubit>().loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    super.dispose();
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
          appBar: const HomeAppbar(
            isWithBackArrow: true,
          ),
          body: BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
              builder: (context, state) {
            if (state is CreateRestaurantLoading) {
              return const Center(
                child: CustomCircularProgressIndicator(),
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
                              ManageVibration.vibrate();
                              setState(() {
                                editFood = false;
                              });
                            },
                            child: Text(
                              widget.from == 'update'
                                  ? LocaleKeys.updateYourRestaurant.localize
                                  : context.isArabic
                                      ? 'مرحباً بك في تسجيل مطعم'
                                      : LocaleKeys
                                          .welcomeToResturantRegisteration
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
                              ManageVibration.vibrate();
                              context.pushNamed(Routes.EditFoodView,
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
                    CreateRestaurantNameField(
                      focusNode: nameFocusNode,
                    ),
                    Sizer(height: 20.h),
                    CreateRestaurantNumberField(restaurantNumber: ''),
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
                                ManageVibration.vibrate();
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
