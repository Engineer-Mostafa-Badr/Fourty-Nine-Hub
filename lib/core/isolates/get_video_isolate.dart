import 'dart:developer';
import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import '../../features/social_media/reels/presentation/controllers/preload_cubit/preload_bloc.dart';
import '../../features/social_media/reels/presentation/shared/constants.dart';

Future createIsolate(int index) async {
  // Set loading to true
  currentContext.read<PreloadBloc>().setLoading(true);

  ReceivePort mainReceivePort = ReceivePort();

  Isolate.spawn<SendPort>(getVideosTask, mainReceivePort.sendPort);

  SendPort isolateSendPort = await mainReceivePort.first;

  ReceivePort isolateResponseReceivePort = ReceivePort();

  isolateSendPort.send([index, isolateResponseReceivePort.sendPort]);

  final isolateResponse = await isolateResponseReceivePort.first;
  final urls = isolateResponse;

  // Update new urls
  if (currentContext.mounted) {
    currentContext.read<PreloadBloc>().updateUrls(urls);
  }
}

void getVideosTask(SendPort mySendPort) async {
  ReceivePort isolateReceivePort = ReceivePort();

  mySendPort.send(isolateReceivePort.sendPort);

  await for (var message in isolateReceivePort) {
    if (message is List) {
      final int index = message[0];

      final SendPort isolateResponseSendPort = message[1];

      final List<String> urls = await getReelVideos(
        id: index + kPreloadLimit,
      );

      isolateResponseSendPort.send(urls);
    }
  }
}

Future<List<String>> getReelVideos({int id = 0}) async {
  await serviceLocator<ReelsCubit>()
      .fetchReels()
      .then((value) => log(
          'reels are fetched ${currentContext.read<ReelsCubit>().state.globalReels ?? []}'))
      .catchError((e) {
    log('error occurred $e');
  });
  final videos = serviceLocator<ReelsCubit>().state.globalReels!;
  // No more videos
  if ((id >= videos.length)) {
    return [];
  }

  await Future.delayed(const Duration(milliseconds: kLatency));

  if ((id + kNextLimit >= videos.length)) {
    return videos.map((e) => e.videoMedia).toList().sublist(id, videos.length);
  }

  return videos.map((e) => e.videoMedia).toList().sublist(id, id + kNextLimit);
}
