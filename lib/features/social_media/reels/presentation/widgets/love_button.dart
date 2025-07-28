import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../data/models/new_reels_model.dart';
import '../controllers/preload_cubit/preload_bloc.dart';

class LoveButton extends StatefulWidget {
  final String count;
  final bool isReversed;
  final MainAxisAlignment mainAxisAlignment;
  final TextStyle? countTextStyle;
  final Reel reel;

  const LoveButton({
    super.key,
    required this.count,
    this.isReversed = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.countTextStyle,
    required this.reel,
  });

  @override
  State<LoveButton> createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton>
    with SingleTickerProviderStateMixin {
  bool isLoved = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.8)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween:
            Tween(begin: 1.8, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _colorAnimation = ColorTween(begin: Colors.white, end: Colors.red)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleLove() {
    if (!serviceLocator<UserCubit>().isLoggedIn) {
      context.read<PreloadBloc>().pauseTheVideo();
      context.push(Routes.LOGIN);
    } else {
      setState(() {
        isLoved = !isLoved;
      });

      _controller.forward(from: 0);
      _handleLikeAction(context);
    }
  }

  Future<void> _handleLikeAction(BuildContext context) async {
    final ReelsCubit cubit = context.read<ReelsCubit>();
    log("Like button pressed");

    try {
      await cubit.likeReel(widget.reel.id).then((_) {
        final response = cubit.state.likeReelResponse;
        if (response?.message == "Reel liked successfully") {
          widget.reel.likeCount++;
        } else if (response?.message == "Reel unlike successfully") {
          widget.reel.likeCount--;
        }
      });

      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error liking reel: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = MediaQuery.of(context).size.width * 0.08;

    return GestureDetector(
      onTap: toggleLove,
      child: Column(
        mainAxisAlignment: widget.mainAxisAlignment,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Icon(
                  Icons.favorite,
                  color: isLoved ? _colorAnimation.value : Colors.white,
                  size: 28
                  //  iconSize,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
            child: Text(
              widget.count,
              style: widget.countTextStyle ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
