import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../../carpool/add_new_route/presentation/widgets/dynamic_map_test.dart';
import '../widgets/car_circle_widget.dart';
import '../widgets/info_column_widget.dart';
import '../widgets/map_section.dart';
import 'widgets/available_trips_widget.dart';
import 'widgets/settings_widget.dart';
import 'widgets/truk_bus_widget.dart';

class RideModeScreen extends StatefulWidget {
  final String modeType;
  const RideModeScreen({super.key, required this.modeType});

  @override
  State<RideModeScreen> createState() => _RideModeScreenState();
}

class _RideModeScreenState extends State<RideModeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  List<String> images = [
    Assets.redCar,
    Assets.blackCar,
    Assets.redCar,
    Assets.blackCar,
    Assets.redCar,
    Assets.blackCar,
    Assets.redCar,
    Assets.blackCar,
  ];
  List<String> titles = [
    "Women",
    "Captain",
    "Women",
    "Captain",
    "Women",
    "Captain",
    "Women",
    "Captain",
  ];
  List<String> columnTitle = [
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
    "142 Street 53",
  ];
  List<String> columnDate = [
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
    "Feb 13 - 12:41 PM",
  ];
  List<String> columnPrice = [
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
    "150 EGP",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SharedScaffold(
          mainCategoryId: 2,
          isWithBackArrow: false,
          body: NestedAppbar(
            scrollController: _scrollController,
            appBars: const [],
            body: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Row(
                        spacing: 8,
                        children: [
                          const Icon(Icons.arrow_back),
                          Text(
                              widget.modeType == 'ride'
                                  ? LocaleKeys.rideMode.tr()
                                  : widget.modeType == 'truk'
                                      ? LocaleKeys.trukMode.tr()
                                      : LocaleKeys.busMode.tr(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTabItem(0, LocaleKeys.availableTrips.tr()),
                        if (widget.modeType == 'ride')
                          _buildTabItem(1, LocaleKeys.runningTrips.tr()),
                        _buildTabItem(2, LocaleKeys.pastTrips.tr()),
                        if (widget.modeType != 'ride')
                          _buildTabItem(4, 'Loading Request'),
                        _buildFilterIcon(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_selectedIndex == 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.separated(
                            itemBuilder: (context, index) =>
                                widget.modeType == 'ride'
                                    ? const AvailableTripsWidget(
                                        isWithAnotherPrice: true,
                                      )
                                    : const TrukBusWidget(),
                            itemCount: columnDate.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 15)),
                      ),
                    )
                  else if (_selectedIndex == 1)
                    Expanded(
                        child: DynamicMapWithPolyline(
                            url: getMapUrl(context, type: "mapBox"),
                            apiKey: getApiKey(context, type: "mapBox")))
                  else if (_selectedIndex == 2)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    context.push(
                                        Routes.rideDashboardDetailsScreen,
                                        extra: widget.modeType);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CarContainer(
                                            title: titles[index],
                                            image: images[index]),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        PriceColumn(
                                            title: columnTitle[index],
                                            date: columnDate[index],
                                            price: columnPrice[index]),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            Container(
                                              alignment:
                                                  AlignmentDirectional.topEnd,
                                              height: 55,
                                              width: 55,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(Assets
                                                          .personalImage))),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                decoration: BoxDecoration(
                                                    color: AppColors
                                                        .colorGreyLight,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  spacing: 1,
                                                  children: [
                                                    Icon(Icons.star,
                                                        size: 12,
                                                        color: AppColors
                                                            .YELLOW_COLOR),
                                                    Text('3.8',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Text('Ahmed',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            itemCount: columnDate.length),
                      ),
                    )
                  else if (_selectedIndex == 3)
                    Expanded(child: SettingsWidget(modeType: widget.modeType))
                  else if (_selectedIndex == 4)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.separated(
                            itemBuilder: (context, index) =>
                                const TrukBusWidget(
                                    modeType: 'bus', isWithAnotherPrice: true),
                            itemCount: 2,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 15)),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    return Expanded(
      flex: 3,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: _selectedIndex == index
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREYBG,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: _selectedIndex == index
                    ? AppColors.whiteColor
                    : AppColors.black,
                fontSize: 10,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterIcon() {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = 3;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          decoration: BoxDecoration(
            color: _selectedIndex == 3
                ? AppColors.PRIMARY_COLOR
                : AppColors.GREYBG,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(
            Assets.option,
            color: _selectedIndex == 3 ? AppColors.whiteColor : AppColors.black,
          ),
        ),
      ),
    );
  }
}
