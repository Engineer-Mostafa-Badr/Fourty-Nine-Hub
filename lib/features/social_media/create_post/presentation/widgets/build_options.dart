import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/feeling_entity.dart';
import '../../domain/entities/post_user_entity.dart';
import '../cubit/create_post_cubit.dart';
import '../pages/select_activity_view.dart';
import '../pages/select_feeling_view.dart';
import 'build_search_friends.dart';
import '../../../../../res/style/styles.dart';

class BuildOptions extends StatelessWidget {
  const BuildOptions({super.key, required this.controller, required this.social});
  final CreatePostCubit controller;
  final String social;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  InkWell(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async => await controller.uploadPhoto(context: context),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image,
                          color: Colors.green,
                          size: 30,
                        ),
                        const Sizer(),
                        Text(
                          LocaleKeys.photo.localize,
                          style: Styles.mediumText(
                              fontSize: 34, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  if (social != 'twitter') ...[
                    const Divider(),
                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        bottomSheet(
                            isScrollControlled: true,
                            context: context,
                            widget: SelectActivity(
                              activities: state.activities ?? [],
                              onSelected: (ActivityEntity item) => context
                                  .read<CreatePostCubit>()
                                  .selectActivity(item: item),
                            ));
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_activity,
                            color: Colors.blue,
                            size: 30,
                          ),
                          const Sizer(),
                          Text(
                            LocaleKeys.activity.localize,
                            style: Styles.mediumText(
                                fontSize: 34, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                  if (social != 'twitter') ...[
                    const Divider(),
                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        bottomSheet(
                            isScrollControlled: true,
                            context: context,
                            widget: SelectFeelingView(
                              feelings: state.feelings ?? [],
                              onSelected: (FeelingEntity item) => context
                                  .read<CreatePostCubit>()
                                  .selectedFeeling(item: item),
                            ));
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.orangeAccent,
                            size: 30,
                          ),
                          const Sizer(),
                          Text(
                            LocaleKeys.feeling.localize,
                            style: Styles.mediumText(
                                fontSize: 65.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                  if (social != 'twitter') ...[
                    const Divider(),
                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => BuildSearchFriends(
                              onSelectUser: (PostUserEntity user) {
                                controller.selectUsers(user);
                                // context.pop(true);
                              },
                              controller: controller,
                            ));
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.people,
                            color: Colors.grey,
                            size: 30,
                          ),
                          const Sizer(),
                          Text(
                            LocaleKeys.tagPeople.localize,
                            style: Styles.mediumText(
                                fontSize: 34, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ]),
          );
        });
  }
}
