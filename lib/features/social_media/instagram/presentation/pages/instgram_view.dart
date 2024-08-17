import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_global_posts.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../social_posts/presentation/pages/my_account_view.dart';

class InstagramView extends StatelessWidget {
  const InstagramView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar:  const HomeAppbar(
            isWithBackArrow: true,
          ),
          drawer: const DrawerWidget(),
          floatingActionButton: const FloatingButton(
            changeView: 3,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const BottomNavigator(
            mainCategory: 3,
            index: 2,
          ),
          body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
              builder: (context, state) {
                return context.read<UserCubit>().isLoggedIn
                    ? Column(
                  children: [
                    const TabBar(tabs: [
                      Tab(
                        icon: Icon(Icons.grid_4x4_outlined),
                      ),
                      Tab(
                        icon: Icon(Icons.person),
                      ),
                    ]),
                    Expanded(
                      child: TabBarView(children: [
                        _buildInstagramWidget(),
                        const MyAccountView(),
                      ]),
                    )
                  ],
                )
                    : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () => context.push(Routes.LOGIN),
                            child: Label(
                                text: 'Login',
                                style: Styles.headerText(color: Colors.blue))),
                        Label(
                            text: ', To continue in using chat services',
                            style: Styles.headerText()),
                      ],
                    ));
              })




      ),
    );
  }

  Widget _buildInstagramWidget() {
    return const InstagramGlobalPosts();
  }


}
