import 'dart:developer';
import 'dart:isolate';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import '../../features/social_media/reels/presentation/controllers/preload_cubit/preload_bloc.dart';
import '../../features/social_media/reels/presentation/shared/constants.dart';

Future preloadVideos(int index) async {
  // Set loading to true
  currentContext.read<PreloadBloc>().setLoading(true);

  final List<String> allUrls = [];


  while (true) {
    final urlsBatch = await createIsolate(index);
    if (urlsBatch.isEmpty) {
      // Break if no more videos are available
      break;
    }
    allUrls.addAll(urlsBatch);
    index += kNextLimit; // Move to the next batch index
  }

  // Update the state with all preloaded URLs
  if (currentContext.mounted) {
    currentContext.read<PreloadBloc>().updateUrls(allUrls);
  }

  // Set loading to false after completion
  currentContext.read<PreloadBloc>().setLoading(false);
}

Future<List<String>> createIsolate(int index) async {
  ReceivePort mainReceivePort = ReceivePort();

  // Spawn an isolate to fetch the video URLs
  await Isolate.spawn<SendPort>(getVideosTask, mainReceivePort.sendPort);

  SendPort isolateSendPort = await mainReceivePort.first;

  // Create a response port for isolate communication
  ReceivePort isolateResponseReceivePort = ReceivePort();

  // Send index and response port to the isolate
  isolateSendPort.send([index, isolateResponseReceivePort.sendPort]);

  // Wait for the isolate to return the video URLs
  final isolateResponse = await isolateResponseReceivePort.first as List<String>;
  return isolateResponse;
}

void getVideosTask(SendPort mySendPort) async {
  ReceivePort isolateReceivePort = ReceivePort();

  // Send back the isolate's port to the main thread
  mySendPort.send(isolateReceivePort.sendPort);

  await for (var message in isolateReceivePort) {
    if (message is List) {
      final int index = message[0];
      final SendPort isolateResponseSendPort = message[1];

      // Fetch the video URLs for the given index
      final List<String> urls = await getReelVideos(id: index);
      isolateResponseSendPort.send(urls);
    }
  }
}

Future<List<String>> getReelVideos({int id = 0}) async {
  // Fetch videos using ReelsCubit

  final videos = serviceLocator<ReelsCubit>().state.globalReels;
  log('Total videos available: ${videos.length}');

  // No more videos to load if index exceeds the list length
  if (id >= videos.length) {
    return [];
  }

  await Future.delayed(const Duration(milliseconds: kLatency));

  // Adjust the end of the sublist based on available videos
  final int endIndex = (id + kNextLimit) < videos.length ? (id + kNextLimit) : videos.length;
  log('end index: $endIndex');
  return videos.map((e) => e.videoMedia).toList().sublist(id, endIndex);
}
