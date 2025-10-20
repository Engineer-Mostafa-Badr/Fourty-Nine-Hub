import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../cubit/stories_cubit.dart';
import 'more_stories.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../helpers/manage_vibration.dart';

class MutedStories extends StatefulWidget {
  const MutedStories({super.key});

  @override
  State<MutedStories> createState() => _MutedStoriesState();
}

class _MutedStoriesState extends State<MutedStories> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchMutedStories(); // Initial fetch
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMutedStories(loadMore: true);
    }
  }

  void _fetchMutedStories({bool loadMore = false}) {
    if (loadMore) {
      _currentPage++;
    }

    context.read<StoryCubit>().getMutedStories(
          limit: _limit,
          page: _currentPage,
          loadMore: loadMore,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StoryCubit>().state;

    return CustomScaffold(
      appBar: BackAppBar(
        label: context.isArabic ? "القصص المعطلة" : 'Muted Stories',
      ),
      enableCustomAppBar: true,
      body: state.mutedStoriesResponse != null
          ? Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  itemCount: state.mutedStoriesResponse!.data.stories.length,
                  itemBuilder: (context, index) {
                    // if (index ==
                    //     state.mutedStoriesResponse!.data.stories.length) {
                    //   // Show loading indicator while fetching more data
                    //
                    //   return const Center(
                    //       child: CustomCircularProgressIndicator());
                    // }

                    final userStory =
                        state.mutedStoriesResponse!.data.stories[index];

                    return InkWell(
                      onTap: () async {
      ManageVibration.vibrate();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: serviceLocator<StoryCubit>(),
                              child: StoryViewScreen(
                                stories: state.users ?? [],
                                mutedStories:
                                    state.mutedStoriesResponse!.data.stories,
                                initialUserIndex: index,
                              ),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        tileColor: Colors.white,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(15),
                        //   side: BorderSide(color: Colors.grey[300]!, width: 1),
                        // ),
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                userStory.user!.profilePictureUrl!),
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                        title: Text(
                          capitalizeAndSplit2Only(
                              "${userStory.user!.firstName} ${userStory.user!.lastName}"),
                          style: Styles.headerText(),
                        ),
                        subtitle: Text(
                          getTimeAgo(context,
                              userStory.stories!.last.createdAt.toString()),
                          style: Styles.mediumText(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          : const Center(child: CustomCircularProgressIndicator()),
    );
  }
}