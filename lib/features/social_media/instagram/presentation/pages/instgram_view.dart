import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_global_posts.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_posts.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class InstagramView extends StatefulWidget {
  final bool hideAppBar;

  const InstagramView(
      {super.key, this.hideAppBar = false}); // Default: show AppBar

  @override
  State<InstagramView> createState() => _InstagramViewState();
}

class _InstagramViewState extends State<InstagramView> {
  ScrollController scrollController = ScrollController();
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();

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
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
          builder: (context, state) {
            return context.read<UserCubit>().isLoggedIn
                ? Column(
                    children: [
                      _buildTabBar(context),
                      Expanded(
                        child:
                            InstagramPosts(scrollController: scrollController),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildTabBar(context),
                      Expanded(
                          child: InstagramGlobalPosts(
                              scrollController: scrollController)),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          2,
          (i) => GestureDetector(
            onTap: () {
              if (i == 1) {
                print(context.read<UserCubit>().token);
                !context.read<UserCubit>().isTokenAttached
                    ? context.push(Routes.LOGIN)
                    : context.push(Routes.INSTAGRAMPROFILE, extra: user?.id);
              }
            },
            child: Container(
              decoration: i == 0
                  ? const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: AppColors.PRIMARY_COLOR_DARK, width: 2),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  Icon(
                    i == 0 ? Icons.grid_4x4_outlined : Icons.person,
                    color: i == 0
                        ? context.isDarkMode
                            ? AppColors.PRIMARY_COLOR_DARK
                            : AppColors.PRIMARY_COLOR
                        : Colors.grey,
                    size: 40.w,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Label(text: i == 0 ? 'Home' : 'Profile',style: Styles.headerText(color: i == 0
                      ? context.isDarkMode
                      ? AppColors.PRIMARY_COLOR_DARK
                      : AppColors.PRIMARY_COLOR
                      : Colors.grey,fontSize: 30),)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
