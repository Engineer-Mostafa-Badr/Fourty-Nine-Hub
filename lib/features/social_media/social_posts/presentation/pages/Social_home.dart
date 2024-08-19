import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_facebook_body.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/post_details_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_people_you_may_know.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_comments.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../res/style/app_colors.dart';
import '../widgets/posts/create_post_banner.dart';

class SocialHomeView extends StatefulWidget {
  final String userId;
  const SocialHomeView({super.key, required this.userId});

  @override
  State<SocialHomeView> createState() => _SocialHomeViewState();
}

class _SocialHomeViewState extends State<SocialHomeView> with SingleTickerProviderStateMixin{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar:  const HomeAppbar(
            isWithBackArrow: true,
          ),
          drawer: const DrawerWidget(),
          bottomNavigationBar: const BottomNavigator(
            mainCategory: 2,
            index: 2,
          ),
          floatingActionButton: const FloatingButton(
            changeView: 2,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
              builder: (context, state) {
            return context.read<UserCubit>().isLoggedIn
                ? NestedAppbar(
                appBars: [
                     SliverAppBar(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      automaticallyImplyLeading: false,
                      floating: true,
                      // pinned: true,
                      flexibleSpace: const CreatePostBanner(),
                    ),
                    SliverAppBar(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      automaticallyImplyLeading: false,
                      // floating: true,
                      pinned: true,
                      flexibleSpace: _buildTabBar(),
                    )
                  ], body: const FacebookBody())
                : Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () => context.push(Routes.LOGIN),
                          child: Label(
                              text: 'Login',
                              style: Styles.headerText())),
                      Label(
                          text: ', To continue in using chat services',
                          style: Styles.headerText()),
                    ],
                  ));
          })),
    );
  }

  Widget _buildTabBar() {
    final user = context.read<UserCubit>().state.data;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(2, (i) => GestureDetector(
          onTap: (){
            if(i==1){
              context.push(Routes.OTHERSACCOUNT,extra: user?.id);
            }
          },
          child: Container(
            decoration: i==0?const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.blue,width: 2))
            ):null,
              child: Icon(i==0?Icons.home:Icons.person,color: i==0?Colors.blue:Theme.of(context).primaryColor,)
          ),
        ),
      ),
    ));
  }

}
