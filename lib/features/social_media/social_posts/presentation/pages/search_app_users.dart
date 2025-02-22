import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/user_image.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class SearchAppUsers extends StatefulWidget {
  const SearchAppUsers({super.key});

  @override
  State<SearchAppUsers> createState() => _SearchAppUsersState();
}

class _SearchAppUsersState extends State<SearchAppUsers> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: BlocProvider(
        create: (_) => serviceLocator<SocialPostsCubit>(),
        child: BlocBuilder<SocialPostsCubit, SocialPostsState>(
            builder: (context, state) {
          final controller = context.read<SocialPostsCubit>();
          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: const Icon(Icons.arrow_back)),
                    const Sizer(),
                    Expanded(
                      child: Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (v) {
                            if (v.isNotEmpty) {
                              controller.loadSearchUsers(v);
                            } else {
                              controller.usersPagingController.itemList = [];
                            }
                          },
                          decoration: InputDecoration(
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.h),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60.r),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60.r),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60.r),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60.r),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            hintStyle: Styles.mediumText(),
                            hintText: LocaleKeys.searchWithName.localize,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Sizer(),
                if (controller.usersPagingController.itemList != null)
                  Expanded(
                      child: _buildListUsersWidget(
                          controller: controller.usersPagingController))
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildListUsersWidget({
    required PagingController<int, UserFriendEntity> controller,
  }) {
    return PagedListView(
      pagingController: controller,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      builderDelegate: PagedChildBuilderDelegate<UserFriendEntity>(
          noItemsFoundIndicatorBuilder: (context) {
            print(controller.itemList?.length);
            return Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Center(
                  child: Text(
                    "No Users",
                    style: Styles.mediumText(),
                  ),
                ));
          },
          itemBuilder: (context, item, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: InkWell(
                onTap: () => context.push(Routes.OTHERSACCOUNT, extra: item.id),
                child: Row(
                  children: [
                    UserProfileImage(
                      accountId: 0,
                      imageURL: item.image,
                      userId: '',
                      fromProfile: true,
                    ),
                    const Sizer(),
                    Expanded(
                        child:
                            Label(text: "${item.firstName}\t${item.lastName}")),
                  ],
                ),
              ),
            );
          },
          noMoreItemsIndicatorBuilder: (context) => Container(),
          firstPageProgressIndicatorBuilder: (context) => Container(
              margin: const EdgeInsets.only(top: 150),
              child: const CupertinoActivityIndicator()),
          newPageProgressIndicatorBuilder: (context) =>
              const CupertinoActivityIndicator()),
    );
  }
}
