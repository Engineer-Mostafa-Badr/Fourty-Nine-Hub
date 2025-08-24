import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/floating_action_button_star.dart';

class BeStarFloatingButton extends StatelessWidget {
  final bool showButton;
  final bool isLoggedIn;

  const BeStarFloatingButton({
    super.key,
    required this.showButton,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) return const SizedBox.shrink();

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: showButton ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: showButton ? 1.0 : 0.0,
        child: const FloatingActionButtonStar(),
      ),
    );
  }
}