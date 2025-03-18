
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/custom_floating_action_button.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/edit_page_cubit/edit_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';

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
  final List<String> _icons = [
    Assets.rideIcon,
    Assets.loading,
    Assets.healthIcon,
    Assets.meal,
    Assets.find,
    Assets.reel,
    Assets.spotlight,
    Assets.meet,
    Assets.liveIcon,
    Assets.snap,
  ];

  Map<String, bool> _initFavouriteCategories(NavigateBarEntity preferences) {
    return {
      "Ride": preferences.ride.enabled,
      "Loading": preferences.loading.enabled,
      "Health": preferences.health.enabled,
      "Meal": preferences.meal.enabled,
      "Find": preferences.find.enabled,
      "Reel": preferences.reel.enabled,
      "Spotlight": preferences.spotlight.enabled,
      "Meet": preferences.meet.enabled,
      "Live": preferences.live.enabled,
      "Snap": preferences.snap.enabled,
    };
  }

  List<String> _getLocalizedNames(NavigateBarEntity preferences) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return [
      isArabic ? preferences.ride.nameAr : preferences.ride.nameEn,
      isArabic ? preferences.loading.nameAr : preferences.loading.nameEn,
      isArabic ? preferences.health.nameAr : preferences.health.nameEn,
      isArabic ? preferences.meal.nameAr : preferences.meal.nameEn,
      isArabic ? preferences.find.nameAr : preferences.find.nameEn,
      isArabic ? preferences.reel.nameAr : preferences.reel.nameEn,
      isArabic ? preferences.spotlight.nameAr : preferences.spotlight.nameEn,
      isArabic ? preferences.meet.nameAr : preferences.meet.nameEn,
      isArabic ? preferences.live.nameAr : preferences.live.nameEn,
      isArabic ? preferences.snap.nameAr : preferences.snap.nameEn,
    ];
  }

  ScrollController scrollController = ScrollController();
  bool _isScrollingDown = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _setupScrollController();
  }

  void _setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          setState(() {
            _isScrollingDown = true;
          });
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isScrollingDown) {
          setState(() {
            _isScrollingDown = false;
          });
        }
      }
    });

    // context
    //     .read<NotificationSocketIoCubit>()
    //     .notificationListener(languageCode: 'en');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator()..fetchNavigateBar(),
        child: BlocBuilder<CustomPageCubit, CustomPageState>(
          builder: (BuildContext context, state) {
            if (state.status == CustomPageStates.success) {
              if (_selectedItems.isEmpty) {
                _selectedItems = _initFavouriteCategories(state.navigateBar!);
              }
              final localizedNames = _getLocalizedNames(state.navigateBar!);

              return Column(
                children: [
                  ListTile(
                    subtitle: Text(LocaleKeys.navigateBarDescription.localize),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _selectedItems.length,
                      itemBuilder: (context, index) {
                        final categoryName = localizedNames[index];
                        final isSelected =
                            _selectedItems.values.elementAt(index);
                        return ListTile(
                          leading: Checkbox(
                            shape: const CircleBorder(),
                            value: isSelected,
                            checkColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool? value) {
                              setState(() {
                                _selectedItems[_selectedItems.keys
                                    .elementAt(index)] = value ?? false;
                              });
                            },
                          ),
                          title: Text(
                            categoryName,
                            style: Styles.mediumText(
                              fontSize: 65.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          selected: isSelected,
                          trailing: Image.asset(
                                  _icons[index],
                                  height: 40.h,
                                ),
                        );
                      },
                    ),
                  ),
                ],
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
      floatingActionButton: _isScrollingDown
          ? null
          : BlocProvider<CustomPageCubit>(
              create: (BuildContext context) => serviceLocator(),
              child: BlocConsumer<CustomPageCubit, CustomPageState>(
                listener: (BuildContext context, state) {
                  if (state.status == CustomPageStates.success) {
                    showSuccessMessage(
                        context, LocaleKeys.updateSuccessfully.localize);
                    BlocProvider.of<EditPageCubit>(context).changePage(
                        BlocProvider.of<EditPageCubit>(context).currentIndex +
                            1);
                  }
                },
                builder: (BuildContext context, Object? state) {
                  return CustomFloatingActionButton(onPressed:  () {
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
                  },text: LocaleKeys.next.localize,);
                  return CustomElevatedButton(
                    child: Text(
                      LocaleKeys.next.localize,
                      style: const TextStyle(color: AppColors.whiteColor),
                    ),
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
                  );
                },
              ),
            ),
    );
  }
}
