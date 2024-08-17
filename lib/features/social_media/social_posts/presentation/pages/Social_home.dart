import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_facebook_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
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
      child: SharedScaffold(
          backgroundColor: Colors.white,
          mainCategoryId: 2,
          body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
              builder: (context, state) {
            return context.read<UserCubit>().isLoggedIn
                ? NestedAppbar(appBars: [
                    const SliverAppBar(
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      floating: true,
                      // pinned: true,
                      flexibleSpace: CreatePostBanner(),
                    ),
                    SliverAppBar(
                      backgroundColor: Colors.white,
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
                              style: Styles.headerText(color: Colors.blue))),
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
              child: Icon(i==0?Icons.home:Icons.person,color: i==0?Colors.blue:AppColors.DARK_GRAY_COLOR,)
          ),
        ),
      ),
    ));
  }

}
