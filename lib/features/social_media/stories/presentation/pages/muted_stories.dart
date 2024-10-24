import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/more_stories.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Muted Stories', style: Styles.headerText()),
      ),
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
                    //       child: CircularProgressIndicator.adaptive());
                    // }

                    final userStory =
                        state.mutedStoriesResponse!.data.stories[index];

                    return InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: serviceLocator<StoryCubit>(),
                              child: StoryViewScreen(
                                stories: state.users??[],
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey[300]!, width: 1),
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(userStory.user!.profilePictureUrl!),
                          backgroundColor: Colors.grey[300],
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
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert,
                              color: Colors.black, size: 35),
                          onSelected: (String value) async {
                            if (value == 'report') {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return SizedBox(
                                    height: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom >
                                            0
                                        ? 0.8.sh
                                        : 0.6.sh,
                                    child: ReportView(
                                      id: userStory.user!.id!,
                                      categoryId: '668e7b4be8cfec5bcc752af9',
                                    ),
                                  );
                                },
                              );
                            } else if (value == 'Un Mute') {
                              context.read<StoryCubit>().muteUserStories(
                                    context: context,
                                    userId: userStory.user!.id ?? '',
                                  );
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'report',
                                child: Row(
                                  children: [
                                    Icon(Icons.report,
                                        color: AppColors.PRIMARY_COLOR_DARK),
                                    SizedBox(width: 10),
                                    Text('Report',
                                        textScaler: TextScaler.noScaling),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Un Mute',
                                child: Row(
                                  children: [
                                    Icon(Icons.notifications_off_outlined,
                                        color: AppColors.PRIMARY_COLOR),
                                    SizedBox(width: 10),
                                    Text('Un Mute',
                                        textScaler: TextScaler.noScaling),
                                  ],
                                ),
                              ),
                            ];
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
