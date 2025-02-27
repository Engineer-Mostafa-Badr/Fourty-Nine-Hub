import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import '../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'widgets/add_stops_widget.dart';
import 'widgets/bottom_sheet/custom_bottom_sheet.dart';
import 'widgets/country_dropdown.dart';
import 'widgets/fare_bottom_sheet_widget.dart';
import 'widgets/options_bottomsheet_widget.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class RideHome extends StatefulWidget {
  const RideHome({super.key});

  @override
  State<RideHome> createState() => _RideHomeState();
}

class _RideHomeState extends State<RideHome> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  String? _selectedCategoryType = "ride"; // Initially "ride"
  int? _selectedCategoryIndex = 0; // Initially selecting the first category
  @override
  void initState() {
    super.initState();
    // _country = CountryPickerUtils.getCountryByName('Egypt');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rideCubit = context.read<RideCubit>();
      if (!rideCubit.isClosed) {
        rideCubit.fetchRideCategories(UserCubit.to.state.data?.id ?? "");
        rideCubit.fetchShippingCategories(UserCubit.to.state.data?.id ?? "");
      }
    });
  }

  final ScrollController _scrollController2 = ScrollController();

  void _scrollRight() {
    _scrollController2.animateTo(
      _scrollController2.offset + 100, // مقدار التحريك لليمين
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SharedScaffold(
            mainCategoryId: 2,
            body: NestedAppbar(
              scrollController: _scrollController,
              appBars: const [],
              body: Stack(
                children: [
                  _buildTopImage(),
                  _buildBottomSheet(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopImage() {
    return Stack(
      children: [
        Image.network(
          "https://miro.medium.com/v2/resize:fit:1024/1*lNbCllyMLyiVyGfY-HXHjw.png",
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          fit: BoxFit.cover,
        ),
        GestureDetector(
          onTap: () {
            customBottomSheet(context,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 10,
                    children: [
                      AppButton(
                          radius: 15,
                          label: LocaleKeys.ride.tr(),
                          onPressed: () {
                            context.push(Routes.welcomeRideRegister);
                          },
                          backColor: AppColors.PRIMARY_COLOR,
                          width: double.infinity),
                      AppButton(
                          radius: 15,
                          label: LocaleKeys.shipping.tr(),
                          onPressed: () {},
                          backColor: AppColors.PRIMARY_COLOR,
                          width: double.infinity),
                    ],
                  ),
                ),
                title: '');
          },
          child: Container(
            margin: const EdgeInsets.all(12),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0B1035),
                  Color(0xFF161F68),
                  Color(0xFF1B2781),
                  Color(0xFF1E2B8E),
                  Color(0xFF1F2D95),
                  Color(0xFF0B1035)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Center(
              child: Text(
                LocaleKeys.carTruckRegister.tr(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12.0),
            child: Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClickableWidget(
                    onTap: (){
                      context.push(Routes.RIDEACTIVITY);
                    },
                    child: _tripsWidget(LocaleKeys.activity.tr())),
                ClickableWidget(
                    onTap: (){
                      context.push(Routes.RIDERUNNINGTRIPS);
                    },
                    child: _tripsWidget(LocaleKeys.runningTrips.tr())),
                ClickableWidget(
                    onTap: (){
                      context.push(Routes.RIDEEXPIREDTRIPE);
                    },
                    child: _tripsWidget(LocaleKeys.expiredTrips.tr())),
                const SizedBox(width: 10),
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xffDBD1D1).withOpacity(0.6)),
                    child: Image.asset(
                        'assets/icons/send2.png') //const Icon(Icons.send_rounded),
                    ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor, //Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: BlocBuilder<RideCubit, RideState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                // if (state.isError) {
                //   return const Center(child: Text("Error: \${state.failure}"));
                // }
                // if (!state.isSuccess ||
                //     state.rideCategory == null ||
                //     state.shippingCategory == null) {
                //   return Container();
                // }

                return Column(
                  spacing: 8,
                  children: [
                    _buildCategoryList(
                        "ride", state.rideCategory?.subCategories ?? []),
                    _buildCategoryList(
                        "shipping", state.rideCategory?.subCategories ?? []
                        // "shipping",
                        // state.shippingCategory?.subCategories ?? []
                    ),
                    CountryDropdown(),
                    // CountryPickerDropdown(
                    //   onValuePicked: (value) {},
                    // );
                    //  InkWell(
                    //     onTap: _showCountryPicker,
                    //     child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           const Icon(Icons.keyboard_arrow_down_rounded, size: 15),
                    //           const SizedBox(width: 4),
                    //           ClipRRect(
                    //               borderRadius: BorderRadius.circular(6),
                    //               child: Image.asset(
                    //                   CountryPickerUtils.getFlagImageAssetPath(
                    //                       _country.isoCode),
                    //                   height: 25.0,
                    //                   width: 35.0,
                    //                   fit: BoxFit.fill,
                    //                   package: "country_pickers")),
                    //           const SizedBox(width: 8.0),
                    //           Text(_country.name)
                    //         ])); //CountryDropdown();
                    _customLocationField(LocaleKeys.from.tr(), Colors.green,
                        LocaleKeys.find.tr(), fromController, false),
                    _customLocationField(LocaleKeys.to.tr(), Colors.blue,
                        LocaleKeys.find.tr(), toController, true),
                    _fareField(),
                    Row(
                      spacing: 5,
                      children: [
                        Expanded(
                            flex: 2,
                            child: AppButton(
                                radius: 15,
                                label: LocaleKeys.premiumRequest.tr(),
                                onPressed: () {},
                                backColor: AppColors.SECONDARY_COLOR_DARK2,
                                width: MediaQuery.of(context).size.width)),
                        Expanded(
                            flex: 2,
                            child: AppButton(
                                radius: 15,
                                label: LocaleKeys.request.tr(),
                                onPressed: () {},
                                backColor: AppColors.PRIMARY_COLOR,
                                width: MediaQuery.of(context).size.width)),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tripsWidget(String text) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColors.GREYCARD,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.DARK_BLUE_COLOR)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildCategoryList(String type, List subCategories) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: SizedBox(
            height: 60,
            child: ListView.builder(
              controller: _scrollController2,
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final subCategory = subCategories[index];
                final bool isSelected = _selectedCategoryType == type &&
                    _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedCategoryType == type &&
                          _selectedCategoryIndex == index) {
                        _selectedCategoryType = null;
                        _selectedCategoryIndex = null;
                      } else {
                        _selectedCategoryType = type;
                        _selectedCategoryIndex = 0;
                        subCategories.insert(0, subCategories.removeAt(index));
                      }
                    });
                  },
                  child: _categoryItem(
                      context.isArabic
                          ? subCategory.subCategoryNameAr
                          : subCategory.subCategoryNameEn,
                      subCategory.picture,
                      isSelected),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
              onTap: () {
                _scrollRight();
              },
              child: const Icon(Icons.arrow_forward_ios,
                  size: 18, color: AppColors.SECONDARY_COLOR_DARK)),
        ),
      ],
    );
  }

  Widget _categoryItem(String title, String imageUrl, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.redAccent.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl,
                width: 50, height: 20, fit: BoxFit.fitWidth),
            const SizedBox(height: 5),
            Text(title,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  Widget _customLocationField(String label, Color color, String buttonText,
      TextEditingController controller, bool isTo) {
    return Row(
      children: [
        Expanded(
          child: FormTextField(
            style: Styles.mediumText(color: AppColors.GREY_DARK_COLOR),
            constraints: const BoxConstraints(maxHeight: 52, minHeight: 52),
            fillColor: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(20),
            controller: controller,
            hint: label,
            suffix: Row(
              spacing: 5,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isTo == true)
                  GestureDetector(
                    onTap: () {
                      customBottomSheet(context,
                          child: const AddStopsWidget(), title: 'Add Stops');
                    },
                    child: const Icon(Icons.add, size: 18),
                  ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 52),
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Text(buttonText,
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
            prefix: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                    backgroundColor: color,
                    radius: 10,
                    child: const CircleAvatar(
                        backgroundColor: Colors.white, radius: 5))),
            action: (v) {},
          ),
        ),
      ],
    );
  }

  Widget _fareField() {
    return GestureDetector(
      onTap: () {
        customBottomSheet(context,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: FareBottomSheetWidget(),
            ),
            title: LocaleKeys.offerYourFare.tr());
      },
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.GREYFIELD,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                spacing: 10,
                children: [
                  Text(LocaleKeys.egp.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(LocaleKeys.offerYourFare.tr()),
                  const Spacer(),
                  Image.asset('assets/icons/edit.png'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                customBottomSheet(context,
                    child: const OptionsBottomsheetWidget(),
                    title: LocaleKeys.options.tr());
              },
              child: SizedBox(
                height: 25,
                child: Image.asset('assets/icons/option.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
