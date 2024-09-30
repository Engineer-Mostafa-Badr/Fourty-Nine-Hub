import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../components/gift_mp4_player.dart';
import 'zego_gift_item.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/zego_uikit.dart';

part 'gift_cache.dart';
part 'gift_playlist.dart';
part 'gift_protocol.dart';

class ZegoGiftManager with GiftCache, GiftPlayList, GiftProtocol {
  static final ZegoGiftManager _singleton = ZegoGiftManager._internal();
  factory ZegoGiftManager() => _singleton;
  ZegoGiftManager._internal();
}
