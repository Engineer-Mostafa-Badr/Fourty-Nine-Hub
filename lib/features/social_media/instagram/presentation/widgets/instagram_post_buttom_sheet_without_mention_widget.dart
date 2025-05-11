import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../routes/routes.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import '../cubit/save_post_instagram/save_post_instagram_cubit.dart';

class InstagramPostButtomSheetWithoutMentionWidget extends StatelessWidget {
  const InstagramPostButtomSheetWithoutMentionWidget(
      {super.key, required this.userId, required this.postId});

  final String userId;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Container(
            width: 64,
            height: 3,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          BlocProvider(
            create: (context) => serviceLocator<SavePostInstagramCubit>(),
            child: BlocBuilder<SavePostInstagramCubit, SavePostInstagramState>(
              builder: (context, state) {
                final cubit = context.read<SavePostInstagramCubit>();
                return GestureDetector(
                  onTap: () {
                    cubit.savePostInstagram(postId);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark, size: 24,),
                        const Sizer(),
                        Text(
                          LocaleKeys.save.localize,
                          style: Styles.headerText(fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // const Sizer(),
          GestureDetector(
            onTap: (){
              context.push(Routes.INSTAGRAMPROFILE, extra: userId);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(Icons.person_pin, size: 24,),
                  const Sizer(),
                  Text(
                    LocaleKeys.aboutThisAccount.localize,
                    style: Styles.headerText(fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
          // const Sizer(),
          BlocProvider(
            create: (context) => serviceLocator<ProfileInstagramCubit>(),
            child: BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    context
                        .read<ProfileInstagramCubit>()
                        .unFollowUser(userId);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.person_remove_alt_1, size: 24,),
                        const Sizer(),
                        Text(
                          LocaleKeys.unfollow.localize,
                          style: Styles.headerText(fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // const Sizer(),
          Container(
            padding: const EdgeInsets.symmetric( horizontal: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.instagramHideIcon,
                  width: 24,
                  color: Colors.black,
                ),
                const Sizer(),
                Text(
                  LocaleKeys.hide.localize,
                  style: Styles.headerText(fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          // const Sizer(),
          GestureDetector(
            onTap: (){
              bottomSheet(
                  context: context,
                  widget: ReportView(
                    id: postId,
                    categoryId: '66b77e97bb35968b535dc945',
                  ),);
            },
            child: Container(
              padding: const EdgeInsets.symmetric( horizontal: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.report,
                    color: Colors.red,
                    size: 24,
                  ),
                  const Sizer(),
                  Text(
                    LocaleKeys.report.localize,
                    style: Styles.headerText(
                        fontWeight: FontWeight.w400, color: Colors.red),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
