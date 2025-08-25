import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class _DownloadRequest {
  final List<String> urls;
  final String cacheDirPath;
  final SendPort replyPort;
  _DownloadRequest(this.urls, this.cacheDirPath, this.replyPort);
}

class CachedResult {
  final Map<String, String> urlToPath;
  CachedResult(this.urlToPath);
}

Future<CachedResult> cacheVideosInIsolate(List<String> urls) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_cacheIsolateEntry, receivePort.sendPort);
  final SendPort isolateSendPort = await receivePort.first as SendPort;

  final Directory baseDir = await getTemporaryDirectory();
  final Directory cacheDir =
      Directory(p.join(baseDir.path, 'reels_video_cache'));
  if (!await cacheDir.exists()) {
    await cacheDir.create(recursive: true);
  }

  final responsePort = ReceivePort();
  isolateSendPort
      .send(_DownloadRequest(urls, cacheDir.path, responsePort.sendPort));
  return await responsePort.first as CachedResult;
}

Future<void> _cacheIsolateEntry(SendPort mainSendPort) async {
  final port = ReceivePort();
  mainSendPort.send(port.sendPort);

  final LinkedHashMap<String, String> memoryIndex = LinkedHashMap();
  final dio = Dio(BaseOptions(
    receiveTimeout: const Duration(seconds: 30),
    connectTimeout: const Duration(seconds: 10),
  ));

  await for (final message in port) {
    if (message is _DownloadRequest) {
      final Map<String, String> result = {};
      final Directory cacheDir = Directory(message.cacheDirPath);

      for (final url in message.urls) {
        if (memoryIndex.containsKey(url)) {
          result[url] = memoryIndex[url]!;
          continue;
        }

        final fileName = _safeFileNameFromUrl(url);
        final destPath = p.join(cacheDir.path, fileName);
        final file = File(destPath);

        if (await file.exists()) {
          result[url] = destPath;
          memoryIndex[url] = destPath;
          _touch(memoryIndex, url);
          continue;
        }

        try {
          await dio.download(url, destPath);
          result[url] = destPath;
          memoryIndex[url] = destPath;
          _touch(memoryIndex, url);
        } catch (_) {
          result[url] = url; // fallback
        }
      }

      message.replyPort.send(CachedResult(result));
    }
  }
}

void _touch(LinkedHashMap<String, String> lru, String key) {
  final value = lru.remove(key);
  if (value != null) lru[key] = value;
}

String _safeFileNameFromUrl(String url) {
  final uri = Uri.tryParse(url);
  final last = uri?.pathSegments.isNotEmpty == true
      ? uri!.pathSegments.last
      : 'video.mp4';
  final sanitized = last.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  final hash = url.hashCode.toUnsigned(20).toRadixString(16);
  final ext =
      p.extension(sanitized).isNotEmpty ? p.extension(sanitized) : '.mp4';
  final base = p.basenameWithoutExtension(sanitized);
  return '${base}_$hash$ext';
}
