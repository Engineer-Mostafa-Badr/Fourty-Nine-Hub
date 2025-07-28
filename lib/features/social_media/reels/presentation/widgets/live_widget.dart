import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';
import '../../data/models/new_reels_model.dart';
import 'sound_option_bottom_sheet.dart';

class LiveWidget extends StatefulWidget {
  const LiveWidget({super.key});

  @override
  State<LiveWidget> createState() => _LiveWidgetState();
}

class _LiveWidgetState extends State<LiveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استخدم أبعاد الشاشة عشان تخلي المقاسات ريسبونسيف
    final screenWidth = MediaQuery.of(context).size.width;
    final baseSize = screenWidth * 0.15; // حجم الدائرة الأساسي
    final iconSize = baseSize * 0.1;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: baseSize,
            height: baseSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: baseSize * 0.06, color: Colors.pink),
            ),
            padding: EdgeInsets.all(baseSize * 0.06),
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                margin: EdgeInsets.all(baseSize * 0.06),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(Assets.maleUser),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // النقطة البيضاء في المنتصف
          Positioned(
            child: CircleAvatar(
              radius: iconSize,
              backgroundColor: Colors.white,
            ),
          ),

          // كلمة LIVE
          Positioned(
            bottom: -iconSize * 2.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: iconSize * 1.2,
                  vertical: iconSize * 0.6,
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A rotating circular button widget for audio interaction
class RotatingCircularButton extends StatelessWidget {
  final Reel reel;
  final AnimationController rotationController;

  const RotatingCircularButton({
    super.key,
    required this.reel,
    required this.rotationController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = size.width * 0.10; // حجم نسبي للشاشة

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: ClipOval(
        child: RotationTransition(
          turns: rotationController,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: reel.audio.audioPicture.isEmpty
                  ? Colors.black
                  : Colors.transparent,
              image: reel.audio.audioPicture.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(reel.audio.audioPicture),
                      fit: BoxFit.cover,
                      onError: (_, __) {},
                    )
                  : null,
            ),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor:
                      context.isDarkMode ? Colors.grey[900] : Colors.white,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  builder: (context) {
                    return RotatingBottomSheet(size: size);
                  },
                );
              },
              child: SizedBox(
                width: buttonSize,
                height: buttonSize,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            reel.user.profilePictureSignedUrl ??
                                'https://i.pravatar.cc/150?img=3', // Default image if null
                          ),
                        ),
                      ),
                      // Icon(
                      //   FontAwesomeIcons.music,
                      //   size: buttonSize * 0.45,
                      //   color: Colors.white,
                      //   shadows: const [
                      //     Shadow(
                      //       offset: Offset(1.0, 1.0),
                      //       blurRadius: 1.0,
                      //       color: Colors.black,
                      //     ),
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RotatingBottomSheet extends StatelessWidget {
  const RotatingBottomSheet({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 32.h),
        SvgPicture.asset(
          Assets.dividerIcon,
          color: context.isDarkMode ? Colors.white : Colors.black,
        ),
        SizedBox(height: 50.h),
        SoundOptionBottomSheet(
          onTap: () {
            Navigator.pop(context);
            context.pushNamed(Routes.UseSoundScreen);
          },
          icon: Assets.useSoundIcon,
          title: context.isArabic ? 'استخدم هذا الصوت' : 'Use this sound',
        ),
        SoundOptionBottomSheet(
          onTap: () {},
          icon: Assets.collabIcon,
          title: context.isArabic ? 'تعاون' : 'Collab',
        ),
        SoundOptionBottomSheet(
          onTap: () {},
          icon: Assets.layoutIcon,
          title: context.isArabic ? 'تَخطِيط' : 'Layout',
        ),
        SoundOptionBottomSheet(
          onTap: () {},
          icon: Assets.mix,
          title: context.isArabic ? 'تجميعة مقاطع' : 'Mix Reel',
        ),
      ],
    );
  }
}
