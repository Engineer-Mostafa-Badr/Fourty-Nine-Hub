import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class AnimatedAcceptButton extends StatefulWidget {
  @override
  _AnimatedAcceptButtonState createState() => _AnimatedAcceptButtonState();
}

class _AnimatedAcceptButtonState extends State<AnimatedAcceptButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 15));

    _animationController.reverse(from: 1.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15), // Match outer border radius
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 98, 5, 8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FractionallySizedBox(
                  widthFactor: _animationController.value,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.PRIMARY_COLOR_DARK,
                    ),
                  ),
                );
              },
            ),
            Center(
                child: Text(
              LocaleKeys.Accept.localize,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Fill color
              ),
            )),
          ],
        ),
      ),
    );
  }
}
