import 'dart:async';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/header_suggest_reels_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/vedio_suggest_reels_item.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class SuggestReelsFaceBookSection extends StatefulWidget {
  const SuggestReelsFaceBookSection({
    super.key,
    required this.reels,
  });
  final List<Reel> reels;

  @override
  State<SuggestReelsFaceBookSection> createState() =>
      _SuggestReelsFaceBookSectionState();
}

class _SuggestReelsFaceBookSectionState
    extends State<SuggestReelsFaceBookSection> {
  // قائمة تخزين مشغلات الفيديو
  final Map<String, VideoPlayerController> _controllers = {};

  // مؤشر للفيديو النشط حاليًا
  String? _currentlyPlayingId;

  // مؤقت للتبديل بين الفيديوهات
  Timer? _switchTimer;

  // قائمة الفيديوهات المرئية حاليًا
  final List<String> _visibleReels = [];

  @override
  void initState() {
    super.initState();
    // تهيئة مشغلات الفيديو
    _initVideoControllers();
  }

  void _initVideoControllers() {
    for (var reel in widget.reels) {
      print("reel.videoMedia ${reel.videoMedia}");
      final controller =
      VideoPlayerController.networkUrl(Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'))
        ..setVolume(0.0) // تعطيل الصوت
        ..initialize().then((_) {
          if (mounted) setState(() {});
        });

      _controllers[reel.id] = controller;
    }
  }

  @override
  void dispose() {
    // إيقاف المؤقت وتحرير الموارد
    _switchTimer?.cancel();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // تشغيل فيديو معين
  void _playReel(String reelId) {
    // إيقاف الفيديو السابق
    if (_currentlyPlayingId != null && _currentlyPlayingId != reelId) {
      _controllers[_currentlyPlayingId]?.pause();
    }

    // تشغيل الفيديو الحالي
    _currentlyPlayingId = reelId;
    _controllers[reelId]?.seekTo(Duration.zero);
    _controllers[reelId]?.play();

    // إلغاء المؤقت السابق إن وجد
    _switchTimer?.cancel();

    // إعداد مؤقت جديد للتبديل التلقائي بعد ثانيتين
    _switchTimer = Timer(const Duration(seconds: 2), () {
      _switchToNextReel();
    });
  }

  // الانتقال للفيديو التالي
  void _switchToNextReel() {
    if (_visibleReels.isEmpty) return;

    // تحديد موقع الفيديو الحالي
    final currentIndex = _currentlyPlayingId != null
        ? _visibleReels.indexOf(_currentlyPlayingId!)
        : -1;

    // تحديد الفيديو التالي
    final nextIndex = (currentIndex + 1) % _visibleReels.length;
    final nextReelId = _visibleReels[nextIndex];

    // تشغيل الفيديو التالي
    _playReel(nextReelId);
  }

  // تحديث قائمة الفيديوهات المرئية
  void _updateVisibleReels(String reelId, bool isVisible) {
    setState(() {
      if (isVisible && !_visibleReels.contains(reelId)) {
        _visibleReels.add(reelId);

        // إذا كان هذا أول فيديو مرئي، قم بتشغيله
        if (_visibleReels.length == 1 && _currentlyPlayingId == null) {
          _playReel(reelId);
        }
      } else if (!isVisible && _visibleReels.contains(reelId)) {
        _visibleReels.remove(reelId);

        // إذا كان هذا هو الفيديو الذي يتم تشغيله، انتقل للفيديو التالي
        if (_currentlyPlayingId == reelId && _visibleReels.isNotEmpty) {
          _switchToNextReel();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10, top: 10),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                Assets.reelBarPng,
                height: 30,
                // width: 50.w,
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {},
                child: Label(
                  text: LocaleKeys.reels.localize,
                  style: Styles.headerText(
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 340,
          child: ListView.separated(
            itemCount: widget.reels.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final reel = widget.reels[index];
              return VisibilityDetector(
                key: Key(reel.id),
                onVisibilityChanged: (info) {
                  // اعتبار الفيديو مرئي إذا كان ظاهر بنسبة أكثر من 50%
                  final isVisible = info.visibleFraction > 0.5;
                  _updateVisibleReels(reel.id, isVisible);
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: index == 0 ? 20 : 0,
                    end: index == widget.reels.length - 1 ? 20 : 0,
                  ),
                  child: ReelCard(
                    reelUrl: widget.reels[index].caption,
                    controller: _controllers[reel.id],
                    isPlaying: _currentlyPlayingId == reel.id,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 9,
            ),
          ),
        ),
      ],
    );
  }
}
