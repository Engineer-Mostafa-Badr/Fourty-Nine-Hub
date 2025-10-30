import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/tube/presentation/cubit/tube_cubit.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../widgets/video_card_widget.dart';

class HomeVideosTubeScreen extends StatefulWidget {
  const HomeVideosTubeScreen({super.key});

  @override
  State<HomeVideosTubeScreen> createState() => _HomeVideosTubeScreenState();
}

class _HomeVideosTubeScreenState extends State<HomeVideosTubeScreen> {
  late final ScrollController _scrollController;
  late final TubeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<TubeCubit>();
    _scrollController = ScrollController();
    /// 🧠 Get userId from UserCubit via service locator
    final userCubit = serviceLocator<UserCubit>();
    final userId = userCubit.isLoggedIn ? userCubit.state.data?.id : null;

    /// 🚀 Load videos with optional userId
    _cubit.loadInitialAllTubeVideos(userId: userId);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _cubit.getAllTubeVideos();
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
        if (_cubit.isTubeVideosInitialLoading &&
            state.status == StateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        final videos = _cubit.allTubeVideos;

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
            onRefresh: _cubit.loadInitialAllTubeVideos,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              itemCount: videos.length + (_cubit.hasMoreTubeVideos ? 1 : 0),
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
                return  VideoCardTube(
                  video: video,
                  videoList: _cubit.allTubeVideos,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

