import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../domain/usecases/update_restaurant_usecase.dart';

class RestaurantStatisticsView extends StatefulWidget {
  const RestaurantStatisticsView({super.key});

  @override
  State<RestaurantStatisticsView> createState() =>
      _RestaurantStatisticsViewState();
}

class _RestaurantStatisticsViewState extends State<RestaurantStatisticsView> {
  String? selectedGovernorateId;
  String? selectedCityId;

  @override
  void initState() {
    super.initState();
    context
        .read<RestaurantDashboardCubit>()
        .getGovernorates(); // Fetch governorates on init
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
      builder: (context, state) {
        return Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("${state.info?.government.toString()}"),
            // Text("${state.info?.city.toString()}"),
            _buildStatisticColumn(
              context.isArabic?'اجمالي الأرباح':LocaleKeys.totalProfit.localize,
              state.statistics?.data.totalRevenue.toString() ?? "N/A",
            ),
            _buildStatisticColumn(
              LocaleKeys.noOfRequests.localize,
              state.statistics?.data.totalOrders.ceil().toString() ?? "N/A",
            ),

            _buildStatisticColumn(
              LocaleKeys.restaurantNumber.localize,
              state.info?.phone?.toString() ?? "N/A",
            ),
            GestureDetector(
              onTap: () => _showUpdateNumberBottomSheet(context, state.info?.phone),
              // Call bottom sheet method
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:AppColors.getRedColor(context),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(10),
                child:   Label(
                  text:LocaleKeys.modify.localize,
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w700,
                      color: AppColors.getReversedTextColor(context)
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,size: 16,color: AppColors.getButtonPrimaryWhiteColor(context),),
                    const Sizer(width: 8,),
                    Label(text: LocaleKeys.location.localize,
                      style: Styles.mediumText(
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                          color: context.isDarkMode ?  AppColors.whiteColor : AppColors.PRIMARY_COLOR

                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Label(text:"${context.isArabic?state.info?.government?.governorateNameAr :state.info?.government?.governorateNameEn ?? ""} ".toArabicNumbers(context),
                      style: Styles.mediumText(
                        fontWeight: FontWeight.w500,
                          color: context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR
                      ),
                    ),
                    Label(text:", ${context.isArabic?state.info?.city?.cityNameAr:state.info?.city?.cityNameEn ?? ""}".toArabicNumbers(context),
                      style: Styles.mediumText(
                        fontWeight: FontWeight.w500,
                          color: context.isDarkMode ?  AppColors.whiteColor : AppColors.PRIMARY_COLOR

                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () => _showModifyBottomSheet(context),
              // Call bottom sheet method
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:AppColors.getRedColor(context),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(10),
                child:   Label(
                  text:LocaleKeys.modify.localize,
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w700,
                    color:AppColors.getReversedTextColor(context)
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  void _showUpdateNumberBottomSheet(BuildContext context, String? currentNumber) {
    final TextEditingController numberController = TextEditingController(
      text: currentNumber ?? '',
    );
    final dashboardCubit = context.read<RestaurantDashboardCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // For bottom padding to work properly
      builder: (context) {
        return Container(
          // margin: const EdgeInsets.only(bottom: 20), // Adds padding at the bottom
          decoration: BoxDecoration(
            color:AppColors.getFindFillColor(context),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Extra space for keyboard
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.phoneNumber.localize,
                    style:  Styles.mediumText(
                      color:AppColors.getRedColor(context),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  NewPhoneNumberTextFormField(
                    currentController: numberController,
                    keyboardType: TextInputType.phone,
                    isRequired: true,
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50, // Fixed height for button
                    child: AppButton(
                      color: AppColors.getReversedTextColor(context),
                      backColor:AppColors.getRedColor(context),
                      style: Styles.mediumText(fontSize: 32,color: AppColors.getReversedTextColor(context)),
                      onPressed: () async {
                        if (numberController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                              backgroundColor: AppColors.getFindFillColor(context),
                              content: Text('Phone number cannot be empty',style: TextStyle(color: AppColors.getTextColor(context)),),
                            ),
                          );
                          return;
                        }

                        // Call the update method
                        await dashboardCubit.updateRestaurant1(
                          params: UpdateRestaurantParams(
                            number: numberController.text,
                          ),
                        );

                        // Refresh data after update
                        await dashboardCubit.getRestaurantInfo();
                        Navigator.pop(context);
                        // if (mounted) Navigator.pop(context);

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             backgroundColor: AppColors.getFindFillColor(context),
                             content: Text('Phone number updated successfully',style: TextStyle(color: AppColors.getTextColor(context))),
                          ),
                        );
                      },
                      label: LocaleKeys.modify.localize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showModifyBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ModifyBottomSheet(
          selectedGovernorateId: selectedGovernorateId,
          selectedCityId: selectedCityId,
        );
      },
    );

    if (result == true) {
      // If modification was successful, refresh restaurant info
      context.read<RestaurantDashboardCubit>().getRestaurantInfo();
    }
  }


  // Build Statistics UI
  Widget _buildStatisticColumn(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16
          ),
        ),
        const Spacer(),
        Text(
          value.toArabicNumbers(context),
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16
          ),
        ),
      ],
    );
  }
}



class ModifyBottomSheet extends StatefulWidget {
  final String? selectedGovernorateId;
  final String? selectedCityId;

  const ModifyBottomSheet({
    Key? key,
    required this.selectedGovernorateId,
    required this.selectedCityId,
  }) : super(key: key);

  @override
  _ModifyBottomSheetState createState() => _ModifyBottomSheetState();
}

class _ModifyBottomSheetState extends State<ModifyBottomSheet> {
  String? _selectedGovernorateId;
  String? _selectedCityId;
  bool _isGovernorateExpanded = false;
  bool _isCityExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedGovernorateId = widget.selectedGovernorateId;
    _selectedCityId = widget.selectedCityId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      serviceLocator<RestaurantDashboardCubit>()..getGovernorates(),
      child: BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:context.isDarkMode ?AppColors.getFindFillColor(context):Colors.white ,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.modifyLocation.localize,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Governorate Selection Custom List
                if (state.governorates != null && state.governorates!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isGovernorateExpanded = !_isGovernorateExpanded;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            // color: AppColors.cD9D9D9,
                            color:context.isDarkMode ? Theme.of(context).scaffoldBackgroundColor : AppColors.cF3F3F3,

                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedGovernorateId != null
                                    ? context.isArabic?state.governorates!.firstWhere((gov) => gov.id == _selectedGovernorateId).nameAr:state.governorates!.firstWhere((gov) => gov.id == _selectedGovernorateId).nameEn
                                    : LocaleKeys.governorate.localize,
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(_isGovernorateExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      if (_isGovernorateExpanded)
                        const SizedBox(height: 4,),
                      if (_isGovernorateExpanded)
                        Container(
                          height: 255, // Fixed size container
                          decoration: BoxDecoration(
                            color:context.isDarkMode ? Theme.of(context).scaffoldBackgroundColor : AppColors.cF3F3F3,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: state.governorates!.map((gov) {
                              return ListTile(
                                title: Label(text:context.isArabic?gov.nameAr:gov.nameEn,
                                  style:  TextStyle(
                                      color:context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedGovernorateId = gov.id;
                                    _selectedCityId = null;
                                    _isGovernorateExpanded = false;
                                    _isCityExpanded = false;
                                  });
                                  context.read<RestaurantDashboardCubit>().getCities(gov.id);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),

                const SizedBox(height: 16),

                // City Selection Custom List
                if (_selectedGovernorateId != null && state.cities != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCityExpanded = !_isCityExpanded;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color:context.isDarkMode ? Theme.of(context).scaffoldBackgroundColor : AppColors.cF3F3F3,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedCityId != null
                                    ? context.isArabic?state.cities!.firstWhere((city) => city.id == _selectedCityId).nameAr:state.cities!.firstWhere((city) => city.id == _selectedCityId).nameEn
                                    :LocaleKeys.selectCity.localize,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Icon(_isCityExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      if (_isCityExpanded)
                        const SizedBox(height: 4,),
                      if (_isCityExpanded)
                        Container(
                          height: 255, // Fixed size container
                          decoration: BoxDecoration(
                            color:context.isDarkMode ? Theme.of(context).scaffoldBackgroundColor : AppColors.cF3F3F3,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: state.cities!.map((city) {
                              return ListTile(
                                title: Label(text:context.isArabic?city.nameAr:city.nameEn,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedCityId = city.id;
                                    _isCityExpanded = false;
                                  });

                                  context.read<RestaurantDashboardCubit>().updateRestaurant1(
                                    params: UpdateRestaurantParams(
                                      city: city.id,
                                      government: _selectedGovernorateId,
                                      subcategoryId: null,
                                      name: null,
                                      number: null,
                                      restaurantMedia: null,
                                    ),
                                  ).then((_) {
                                    if (mounted) {
                                      Navigator.pop(context, true);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),

              ],
            ),
          );
        },
      ),
    );
  }
}



