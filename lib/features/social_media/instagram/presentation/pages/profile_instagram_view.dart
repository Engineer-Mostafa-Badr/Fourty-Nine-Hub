import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/loading/custom_loading.dart';
import '../../../../../core/widget/custom_failure_widget.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import '../widgets/profile_instagram_view_body.dart';
import '../../../../../helpers/manage_vibration.dart';

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
      ManageVibration.vibrate();
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