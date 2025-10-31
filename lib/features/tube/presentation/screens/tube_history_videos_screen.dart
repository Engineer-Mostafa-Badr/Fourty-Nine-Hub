import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/tube/presentation/cubit/tube_cubit.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../widgets/video_card_widget.dart';

class MyHistoryTubeVideos extends StatefulWidget {
  const MyHistoryTubeVideos({super.key});

  @override
  State<MyHistoryTubeVideos> createState() => _MyHistoryTubeVideosState();
}

class _MyHistoryTubeVideosState extends State<MyHistoryTubeVideos> {
  late final ScrollController _scrollController;
  late final TubeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<TubeCubit>();
    _scrollController = ScrollController();

    /// 🚀 Load my videos (gets userId internally from UserCubit)
    _cubit.loadInitialHistoryTubeVideos();

    /// 📜 Pagination listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _cubit.getMyTubeVideos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TubeCubit, TubeState>(
      builder: (context, state) {
        if (_cubit.isHistoryTubeVideosInitialLoading &&
            state.status == StateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        final videos = _cubit.historyTubeVideos;

        if (videos.isEmpty) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'No videos yet',
                style: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        return Container(
          color: Colors.black,
          child: RefreshIndicator(
            color: Colors.red,
            backgroundColor: const Color(0xFF0F0F0F),
            onRefresh: _cubit.loadInitialMyTubeVideos,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              itemCount: videos.length + (_cubit.hasMoreHistoryTubeVideos ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= videos.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    ),
                  );
                }
                final video = videos[index];
                return VideoCardTube(
                  video: video,
                  videoList: _cubit.historyTubeVideos,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
