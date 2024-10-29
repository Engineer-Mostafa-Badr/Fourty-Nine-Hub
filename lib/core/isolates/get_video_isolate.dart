import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import '../../features/social_media/reels/presentation/controllers/preload_cubit/preload_bloc.dart';
import '../../features/social_media/reels/presentation/controllers/preload_cubit/preload_events.dart';
import '../../features/social_media/reels/presentation/shared/constants.dart';
import '../../routes/pages.dart';

Future createIsolate(int index) async {
  // Set loading to true
  BlocProvider.of<PreloadBloc>(
          AppPages.router.configuration.navigatorKey.currentContext!,
          listen: false)
      .add(SetLoading());

  ReceivePort mainReceivePort = ReceivePort();

  Isolate.spawn<SendPort>(getVideosTask, mainReceivePort.sendPort);

  SendPort isolateSendPort = await mainReceivePort.first;

  ReceivePort isolateResponseReceivePort = ReceivePort();

  isolateSendPort.send([index, isolateResponseReceivePort.sendPort]);

  final isolateResponse = await isolateResponseReceivePort.first;
  final _urls = isolateResponse;

  // Update new urls
  BlocProvider.of<PreloadBloc>(
          AppPages.router.configuration.navigatorKey.currentContext!,
          listen: false)
      .add(UpdateUrls(_urls));
}

void getVideosTask(SendPort mySendPort) async {
  ReceivePort isolateReceivePort = ReceivePort();

  mySendPort.send(isolateReceivePort.sendPort);

  await for (var message in isolateReceivePort) {
    if (message is List) {
      final int index = message[0];

      final SendPort isolateResponseSendPort = message[1];

      final List<String> _urls = await getReelVideos(
        id: index + kPreloadLimit,
      );

      isolateResponseSendPort.send(_urls);
    }
  }
}

Future<List<String>> getReelVideos({int id = 0}) async {
  final videos = currentContext.read<ReelsCubit>().state.globalReels!;
  // No more videos
  if ((id >= videos.length)) {
    return [];
  }

  await Future.delayed(const Duration(seconds: kLatency));

  if ((id + kNextLimit >= videos.length)) {
    return videos.map((e) => e.videoMedia).toList().sublist(id, videos.length);
  }

  return videos.map((e) => e.videoMedia).toList().sublist(id, id + kNextLimit);
}
