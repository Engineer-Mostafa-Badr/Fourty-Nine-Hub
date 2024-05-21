import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../common/functions/helper/randome_color.dart';
import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/styles.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../res/style/app_colors.dart';
import '../widgets/main/Mazad_card.dart';

class MazadatView extends StatelessWidget {
  const MazadatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: const BottomNavigator(
        mainCategory: 1,
        index: 2,
      ),
      floatingActionButton: const FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          _buildHorizontalCategories(context: context),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: [
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: MazadCard(),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: MazadCard(),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: MazadCard(),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: MazadCard(
                        isHoriz: true,
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: MazadCard(
                        isHoriz: true,
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: MazadCard(
                        isHoriz: true,
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: MazadCard(
                        isHoriz: false,
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: MazadCard(),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: MazadCard(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Tile({required int index}) {
    return Container(
      color: getRandomColor(),
      child: Center(
        child: Label(text: index.toString(), style: Styles.mediumText()),
      ),
    );
  }

  Widget _buildHorizontalCategories({
    required BuildContext context,
  }) {
    return SizedBox(
      height: kToolbarHeight * .5,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              bottomSheet(context: context, widget: Scaffold());
            },
            child: Container(
              height: kToolbarHeight * .5,
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.PRIMARY_COLOR),
                  color: AppColors.PRIMARY_COLOR),
              child: const Icon(
                Icons.sort,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: index == 0
                          ? null
                          : Border.all(color: AppColors.LIGHT_GRAY_COLOR),
                      color: index == 0
                          ? AppColors.PRIMARY_COLOR
                          : AppColors.LIGHT_GRAY_COLOR),
                  child: Center(
                    child: Label(
                        text: 'Goods',
                        style: Styles.mediumText(
                            color: index == 0 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500)),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Sizer(
                width: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
