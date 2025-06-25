import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/widget/custom_failure_widget.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/profile_instagram_view_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ProfileInstagramView extends StatelessWidget {
  const ProfileInstagramView({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
      builder: (context, state) {
        if (state.isAnyLoading) {
          return const Scaffold(body: CustomLoading());
        }
        if (state.isAnyFailure) {
          return Scaffold(
            body: CustomFailureWidget(
              onPressed: () {
                context
                    .read<ProfileInstagramCubit>()
                    .getUserProfile(userId: userId);
              },
              title: getFailureMessage(
                  state.profileFailure ??
                      state.reelsFailure ??
                      state.suggestFollowFailure ??
                      UnknownFailure(''),
                  context),
            ),
          );
        }

        return CustomScaffold(
          // appBar: AppBar(
          //   title: Label(
          //     text:
          //         '${state.profileData!.firstName} ${state.profileData!.lastName}',
          //     style: Styles.headerText(
          //       fontSize: 40,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          //   leading: IconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: const Icon(Icons.arrow_back_ios_new_outlined),
          //   ),
          // ),
          body: const ProfileInstagramViewBody(),
        );
      },
    );
  }
}
