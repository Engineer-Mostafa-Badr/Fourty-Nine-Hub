import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/search/domain/entity/user_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';



class ProfileSearchView extends StatefulWidget {
  const ProfileSearchView({Key? key}) : super(key: key);

  @override
  State<ProfileSearchView> createState() => _ProfileSearchViewState();
}
class _ProfileSearchViewState extends State<ProfileSearchView> {
  late final ScrollController _scrollController;
  late final SearchCubit _cubit;
  static const _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SearchCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() async {
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= max - _scrollThreshold &&
        !_cubit.isLoadingUsersSearchMore &&
        _cubit.hasMoreUsersSearchData) {
      final prefs = await SharedPreferences.getInstance();
      final filter = prefs.getString('filter') ?? '';
      final params = SearchParams(
        search: _cubit.searchController.text.trim(),
        filter: filter,
        params: PaginationParams(page: _cubit.usersSearchPage),
      );
      _cubit.getPaginatedUserSearch(params: params);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      child: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (prev, curr) =>
        prev.userSearch != curr.userSearch || prev.status != curr.status,
        builder: (context, state) {
          // If no search has been initiated, show "No Data"
          if (_cubit.searchController.text.trim().isEmpty) {
            return Center(
              child: Text(
                LocaleKeys.noData.localize,
                style: Styles.mediumText(),
              ),
            );
          }

          // Loading during search
          if (state.status == SearchStates.loading ) {
            return const Center(child: CircularProgressIndicator());
          }

          // Display list + loader at bottom
          return ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _cubit.usersSearch.length + (_cubit.isLoadingUsersSearchMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _cubit.usersSearch.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final user = _cubit.usersSearch[index];
              return InkWell(
                onTap: () {
                  context.push(Routes.OTHERSACCOUNT, extra: user.id);
                },

                  child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    spacing: 8,
                    children: [
                      ImageFromInternet(image: user.image!,
                        height: 65,
                        width: 65,
                        isCircle: true,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.firstName} ${user.lastName}',
                              style: Styles.mediumText(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              '@${user.username}',
                              style:Styles.mediumText(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}




