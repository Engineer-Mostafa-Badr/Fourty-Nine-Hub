import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/build_twitter_document_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_global_posts.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class TwitterView extends StatefulWidget {
  const TwitterView({super.key});
  @override
  State<TwitterView> createState() => _TwitterViewState();
}

class _TwitterViewState extends State<TwitterView> {
  @override
  void initState() {
    context.read<TwitterCubit>().loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SharedScaffold(
          mainCategoryId: 2,
          body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
              builder: (context, state) {
                UserEntity? userData = state.data;
            return context.read<UserCubit>().isLoggedIn
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTwitterTitle(),
                    const BuildTwitterDocumentCard(),
                    Expanded(child: TwitterGlobalPosts(userData: userData!,)),
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
          }),
        ),
        PositionedDirectional(
          bottom: 70,
          end: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () => context.push(Routes.CREATEPOST, extra: 'twitter'),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTwitterTitle(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Label(
        text: 'Tweets',
        style: Styles.headerText(),
      ),
    );
  }

}
