import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/create_ad_location_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/trip_join_ad_buttons.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/create_ad_widgets/trip_join_bottom_section.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/infoButton.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/form/text_fields/form_text_field.dart';

class TripJoinCreateAdView extends StatefulWidget {
  const TripJoinCreateAdView({super.key});

  @override
  State<TripJoinCreateAdView> createState() => _TripJoinCreateAdViewState();
}

class _TripJoinCreateAdViewState extends State<TripJoinCreateAdView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedBrand;
  String? selectedModel;
  int? selectedSeatNum;
  bool isChecked = false;
  TimeOfDay? time;
  List<String> carBrands = [
    'Alfa Romeo',
    'Aston Martin',
    'Audi',
    'BMW',
    'Baic',
    'Bestune',
    'Brilliance',
    'Buick',
  ];
  List<String> countries = [
    'Egypt',
    'United States',
    'UAE',
    'Jordan',
    'England',
    'France',
  ];
  List<String> carModels = [
    'A1',
    'MZ 40',
    'X3',
  ];
  int seatNum = 1;
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CustomScaffold(
            resizeToAvoidBottomInset: true,
            appBar: HomeAppbar(
              showChat: true,
              isWithBackArrow: false,
              language: true,
              leading: IconButton(
                icon: const Icon(Icons.menu), // The menu icon
                onPressed: () {
                  HandleCashback.setCount('drawerCount', context);
                  _scaffoldKey.currentState?.openDrawer(); // Open the drawer
                },
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0.h),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const WelcomeTextWidget(),
                          Container(
                            height: 442.h,
                          ),
                          DropdownMenu(
                            inputDecorationTheme: InputDecorationTheme(
                              fillColor: AppColors.BG_GRAY_COLOR,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:const BorderSide(color: AppColors.BG_GRAY_COLOR,)
                              )
                            ),
                              menuStyle: MenuStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.BG_GRAY_COLOR),
                              ),
                              width: MediaQuery.of(context).size.width * 0.92,
                              hintText: LocaleKeys.speciality.localize,
                              dropdownMenuEntries: countries
                                  .map((e) => DropdownMenuEntry(
                                      value: e,
                                      label: context.isArabic ? e : e))
                                  .toList(),
                              onSelected: (value) {}),
                          const Sizer(),
                          StartTextFieldAndFindButton(
                            hint: LocaleKeys.from.localize,
                            iconColor: AppColors.CHECK_MARK_COLOR,
                          ),
                          const Sizer(),
                          StartTextFieldAndFindButton(
                            hint: LocaleKeys.to.localize,
                            iconColor: AppColors.LIGHT_BLUE,
                          ),
                          const Sizer(),
                          FormTextField(
                              type: TextInputType.phone,
                              height: 76.h,
                              style: Styles.mediumText(),
                              constraints: const BoxConstraints(
                                  maxHeight: 52, minHeight: 52),
                              fillColor: AppColors.colorGreyLight,
                              borderRadius: BorderRadius.circular(30.h),
                              controller: phoneController,
                              hint: LocaleKeys.phoneNumber.localize,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys
                                      .please_enter_phone_number.localize;
                                }
                                return null;
                              }),
                          const Sizer(),
                          Row(
                            children: [
                              _buildMenuButton(
                                  title: LocaleKeys.vehicleBrand.localize,
                                  items: carBrands,
                                  selectedItem: selectedBrand),
                              const Sizer(),
                              _buildMenuButton(
                                  title: LocaleKeys.vehicleModel.localize,
                                  items: carModels,
                                  selectedItem: selectedModel),
                            ],
                          ),
                          const Sizer(),
                          const TripJoinBottomSection(),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0.h, bottom: 20.h),
                            child: const PremiumAndRequestWidget(),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            )));
  }

  void _showDropdownMenu(
      {required BuildContext context,
      required Offset position,
      required List items,
      }) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final selected = await showMenu<String>(
      color: AppColors.colorGreyLight,
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy,
      ),
      items: items
          .map((brand) => PopupMenuItem<String>(
                value: brand,
                child: Text(brand),
              ))
          .toList(),
    );

    if (selected != null) {
    }
  }

  _buildMenuButton(
      {required String title, required List items, required var selectedItem}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.h),
          color: AppColors.colorGreyLight,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedItem ?? title,
              style: Styles.mediumText(),
            ),
            GestureDetector(
              child:const Icon(Icons.keyboard_arrow_down),
              onTapDown: (details) => _showDropdownMenu(
                  context: context,
                  position: details.globalPosition,
                  items: items,),
            ),
          ],
        ),
      ),
    );
  }
}
