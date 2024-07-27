import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/social_posts_cubit.dart';

class MyAccountView extends StatelessWidget {
  const MyAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstagramCubit, InstagramState>(
      listener: (context, state) {},
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: ListView(
              children: [
                _buildAccountHeaderView(),
                // TODO build content
                TabBar(tabs: [
                  Tab(
                    icon: Icon(Icons.grid_view_rounded),
                  ),
                  Tab(
                    icon: Icon(Icons.video_library),
                  ),
                  Tab(
                    icon: Icon(Icons.account_box),
                  ),
                ]),
                SizedBox(
                  height: kToolbarHeight * 4,
                  child: TabBarView(children: [
                    Center(
                      child: Label(
                          text: 'There is no items',
                          style: Styles.mediumText()),
                    ),
                    Center(
                      child: Label(
                          text: 'There is no items',
                          style: Styles.mediumText()),
                    ),
                    Center(
                      child: Label(
                          text: 'There is no items',
                          style: Styles.mediumText()),
                    ),
                  ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountHeaderView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: kToolbarHeight * 1.5,
                    width: kToolbarHeight * 1.5,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              NetworkImage(UIConst.profilePlaceHolder),
                        )),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.SECONDARY_COLOR,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.add,
                                  size: 16,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Label(
                      text: 'Mody Gamal',
                      style: Styles.mediumText(fontWeight: FontWeight.bold)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.LIGHT_GRAY_COLOR),
                    child: Label(text: '@ gemy.49', style: Styles.smallText()),
                  ),
                ],
              )),
              Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      _buildAccountCounterItem(label: 'posts', value: '34'),
                      _buildAccountCounterItem(label: 'follower', value: '169'),
                      _buildAccountCounterItem(label: 'Friend', value: '366'),
                      _buildAccountCounterItem(label: 'View', value: '10K'),
                    ],
                  )),
            ],
          ),
          Label(
              text: '49Hub owner, welcome to your fav. app',
              style: Styles.mediumText()),
          const Sizer(),
          Row(
            children: [
              Expanded(
                  child: AppButton(label: 'Edit Profile', onPressed: () {})),
              const Sizer(),
              Expanded(
                  child: AppButton(label: 'Share Profile', onPressed: () {})),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAccountCounterItem({
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Label(text: value, style: Styles.headerText()),
          Label(text: label, style: Styles.smallText())
        ],
      ),
    );
  }
}
