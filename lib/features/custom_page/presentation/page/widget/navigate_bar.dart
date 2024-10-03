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
import '../../../domain/use_case/update_navigate_bar_use_case.dart';

class NavigateBar extends StatefulWidget {
  const NavigateBar({super.key});

  @override
  _NavigateBarState createState() => _NavigateBarState();
}

class _NavigateBarState extends State<NavigateBar> {
  Set<int> _selectedItems = {};
  final List<String> _items = [
    LocaleKeys.ride.localize,
    LocaleKeys.ship.localize,
    LocaleKeys.health.localize,
    LocaleKeys.meal.localize,
    LocaleKeys.find.localize,
    LocaleKeys.chat.localize,
    LocaleKeys.reel.localize,
    LocaleKeys.tweet.localize,
    LocaleKeys.spotlight.localize,
    LocaleKeys.meet.localize,
    LocaleKeys.live.localize,
    LocaleKeys.snap.localize,
  ];

  final List<String> _icons = [
    Assets.ride,
    Assets.shipping,
    Assets.health,
    Assets.food,
    Assets.social,
    Assets.message,
    Assets.reels,
    Assets.twitter,
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
            return ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                String currentItem = _items[index];

                return ListTile(
                  leading: Checkbox(
                    value: _selectedItems.contains(index),
                    checkColor: Theme.of(context).scaffoldBackgroundColor,
                    activeColor: Theme.of(context).primaryColor,
                    // Red if true, white if false
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (_selectedItems.length < 5) {
                            _selectedItems.add(index);
                          }
                        } else {
                          _selectedItems.remove(index);
                        }
                      });
                    },
                  ),
                  title: Text(
                    currentItem,
                    style: Styles.mediumText(
                        fontSize: 65.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor),
                  ),
                  trailing: SvgPicture.asset(
                    _icons[index],
                    height: 40.h,
                  ),
                  selected: _selectedItems.contains(index),
                );
              },
            );
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
                if (_selectedItems.length >= 3 && _selectedItems.length <= 5) {
                  // Proceed with the selected items
                  context
                      .read<CustomPageCubit>()
                      .updateNavigateBar(NavigateBarParams(
                        ride: _selectedItems.contains(_items.indexOf('Ride')),
                        loading:
                            _selectedItems.contains(_items.indexOf('Loading')),
                        health:
                            _selectedItems.contains(_items.indexOf('Auction')),
                        meal: _selectedItems.contains(_items.indexOf('Meal')),
                        find: _selectedItems.contains(_items.indexOf('Find')),
                        chat: _selectedItems.contains(_items.indexOf('Chat')),
                        reel: _selectedItems.contains(_items.indexOf('Reel')),
                        tweet: _selectedItems.contains(_items.indexOf('Tweet')),
                        spotlight: _selectedItems
                            .contains(_items.indexOf('Spotlight')),
                        meet: _selectedItems.contains(_items.indexOf('Meet')),
                        live: _selectedItems.contains(_items.indexOf('Live')),
                        snap: _selectedItems.contains(_items.indexOf('Snap')),
                      ));
                  print('Selected Items: ${_selectedItems.toList()}');
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
