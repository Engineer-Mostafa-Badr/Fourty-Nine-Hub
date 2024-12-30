import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/entity/navigate_bar_entity.dart';
import '../../../domain/use_case/update_navigate_bar_use_case.dart';

class NavigateBar extends StatefulWidget {
  const NavigateBar({super.key});

  @override
  _NavigateBarState createState() => _NavigateBarState();
}

class _NavigateBarState extends State<NavigateBar> {
  Map<String, bool> _selectedItems = {};
  Map<String, bool> _initFavouriteCategories(NavigateBarEntity preferences) {
    return {
      "Ride": preferences.ride,
      "Loading": preferences.loading,
      "Health": preferences.health,
      "Meal": preferences.meal,
      "Find": preferences.find,
      "Reel": preferences.reel,
      "Spotlight": preferences.spotlight,
      "Meet": preferences.meet,
      "Live": preferences.live,
      "Snap": preferences.snap,
    };
  }

  final List<String> _icons = [
    Assets.homeRide,
    Assets.loadingCar,
    Assets.homeHealth,
    Assets.homeFood,
    Assets.social,
    Assets.homeReel,
    Assets.spotlightIcon,
    Assets.zoomMeeting,
    Assets.live,
    Assets.cameraIcon,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.navigateBar.localize),
      ),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator()..fetchNavigateBar(),
        child: BlocBuilder<CustomPageCubit, CustomPageState>(
          builder: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              if (_selectedItems.isEmpty) {
                _selectedItems = _initFavouriteCategories(state.navigateBar!);
              }
              return ListView.builder(
                itemCount: _selectedItems.length,
                itemBuilder: (context, index) {
                  final categoryName = _selectedItems.keys.elementAt(index);
                  final isSelected = _selectedItems[categoryName]!;
                  return ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      checkColor: Theme.of(context).scaffoldBackgroundColor,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedItems[categoryName] = value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      categoryName,
                      style: Styles.mediumText(
                          fontSize: 65.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor),
                    ),
                    selected: isSelected,
                    trailing:(index == 0 ||index == 1 || index ==2|| index ==3|| index ==5)?Image.asset(_icons[index],height: 40.h,): SvgPicture.asset(
                      _icons[index],
                      height: 40.h,
                    ),
                  );
                },
              );
            } else if (state.status == CustomPageStates.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Center(
                  child: Text(LocaleKeys.failedToLoadCategories.localize));
            }
          },
        ),
      ),
      floatingActionButton: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              showSuccessMessage(
                  context, LocaleKeys.updateSuccessfully.localize);
            }
          },
          builder: (BuildContext context, Object? state) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                final selectedCategories = _selectedItems.entries
                    .where((entry) => entry.value == true)
                    .map((entry) => entry.key)
                    .toList();
                if (selectedCategories.length >= 3 &&
                    selectedCategories.length <= 5) {
                  // Proceed with the selected items
                  context
                      .read<CustomPageCubit>()
                      .updateNavigateBar(NavigateBarParams(
                        ride: _selectedItems["Ride"] ?? false,
                        loading: _selectedItems["Loading"] ?? false,
                        health: _selectedItems["Health"] ?? false,
                        meal: _selectedItems["Meal"] ?? false,
                        find: _selectedItems["Find"] ?? false,
                        reel: _selectedItems["Reel"] ?? false,
                        spotlight: _selectedItems["Spotlight"] ?? false,
                        meet: _selectedItems["Meet"] ?? false,
                        live: _selectedItems["Live"] ?? false,
                        snap: _selectedItems["Snap"] ?? false,
                      ));
                } else {
                  // Show a message if the selection is not valid
                  showSuccessMessage(
                    context,
                    LocaleKeys.atLeast3atMost5items.localize,
                    color: AppColors.SECONDARY_COLOR,
                  );
                }
              },
              child: Icon(
                Icons.check,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
