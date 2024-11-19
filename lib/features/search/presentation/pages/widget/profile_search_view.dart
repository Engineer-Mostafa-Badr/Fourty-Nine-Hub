import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/search/domain/entity/user_search_entity.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class ProfileSearchView extends StatelessWidget {
  const ProfileSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (BuildContext context, state) {
          final controller = context.read<SearchCubit>();
          if (controller.searchController.text.isNotEmpty) {
            return PagedListView<int, UserSearchEntity>(
              pagingController: controller.searchPagingUserController,
              builderDelegate: PagedChildBuilderDelegate<UserSearchEntity>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Center(
                    child: Text(
                      LocaleKeys.noData.localize,
                      style: Styles.mediumText(),
                    ),
                  );
                },
                itemBuilder: (context, item, index) {
                  return InkWell(
                      onTap: () {
                        context.push(Routes.OTHERSACCOUNT, extra: item.id);
                      },
                      child: buildItem(item));
                },
                noMoreItemsIndicatorBuilder: (context) => Container(),
                firstPageProgressIndicatorBuilder: (context) =>
                    const CupertinoActivityIndicator(),
                newPageProgressIndicatorBuilder: (context) =>
                    const CupertinoActivityIndicator(),
              ),
            );
          }

          return const Center(
            child: Text('No results found.'),
          );
        },
      ),
    );
  }

  Widget buildItem(UserSearchEntity model) => Padding(
        padding: EdgeInsets.only(
          bottom: 15.h,
        ),
        child: Row(
          children: [
            Container(
              height: 65.h,
              width: 65.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(model.image ?? Assets.logo),
                ),
              ),
            ),
            const Sizer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(text: '${model.firstName} ${model.lastName}'),
                Label(
                  text: 'Friend',
                  style: Styles.smallText(
                    color: AppColors.GREY_NORMAL_COLOR,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward,
              color: AppColors.GREY_NORMAL_COLOR,
            )
          ],
        ),
      );
}
