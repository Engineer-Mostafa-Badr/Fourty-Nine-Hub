// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/messages/messages.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';
import '../../../account_taps/account/presentation/cubit/managers/favourite_categories_cubit.dart';
import '../../../account_taps/account/presentation/cubit/managers/favourite_subcategories_cubit.dart';
import '../../../account_taps/account/presentation/pages/favourite_category_view.dart';
import '../../../account_taps/account/presentation/pages/favourite_subcategory_view.dart';
import '../../../notifications/presentation/widgets/icon_with_view_count.dart';

class FavouriteScreensView extends StatefulWidget {
  const FavouriteScreensView({super.key});

  @override
  State<FavouriteScreensView> createState() => _FavouriteScreensViewState();
}

int index = 0;
List<String> titles = [
  LocaleKeys.favouriteCategories.localize,
  LocaleKeys.favouriteSubCategories.localize,
];

class _FavouriteScreensViewState extends State<FavouriteScreensView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavouriteCategoryCubit>(
          create: (_) => serviceLocator()..loadData(),
        ),
        BlocProvider<FavouriteSubCategoryCubit>(
          create: (_) => serviceLocator(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FavouriteCategoryCubit, FavouriteCategoryState>(
            listener: (context, state) {
              if (state.status == StateStatus.error) {
                showErrorMessage(context, state.failure as String);
              }
            },
          ),
        ],
        child: DefaultTabController(
          length: 2,
          child: CustomScaffold(
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(30),
                child: HomeAppbar(
                  color: Colors.red,
                  inNotifications: true,
                  isWithBackArrow: true,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: titles[index],
                      style: Styles.headerText(),
                    ),
                    const Sizer(),
                    TabBar(
                      onTap: (value) {
                        index = value;
                        setState(() {});
                      },
                      indicatorColor: Colors.transparent,
                      tabs: [
                        CustomNotificationWidget(
                          icon: SvgPicture.asset(
                            Assets.saveIcon,
                            height: 30,
                          ),
                          unreadCount: 0,
                        ),
                        CustomNotificationWidget(
                          icon: SvgPicture.asset(
                            Assets.starRedIcon,
                            height: 30,
                          ),
                          unreadCount: 0,
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          GestureDetector(
                            onHorizontalDragStart: (_) {},
                            onHorizontalDragEnd: (_) {},
                            child: const FavouriteCategoryView(),
                          ),
                          GestureDetector(
                            onHorizontalDragStart: (_) {},
                            onHorizontalDragEnd: (_) {},
                            child: const FavSubCategoryView(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
