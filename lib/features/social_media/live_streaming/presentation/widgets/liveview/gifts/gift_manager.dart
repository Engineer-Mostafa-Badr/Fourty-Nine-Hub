import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../components/components.dart';
import 'zego_gift_item.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:zego_uikit/zego_uikit.dart';
part 'gift_cache.dart';
part 'gift_playlist.dart';
part 'gift_protocol.dart';

class ZegoGiftManager with GiftCache, GiftPlayList, GiftProtocol {
  static final ZegoGiftManager _singleton = ZegoGiftManager._internal();
  factory ZegoGiftManager() => _singleton;
  ZegoGiftManager._internal();
}
