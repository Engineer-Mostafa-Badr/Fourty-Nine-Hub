
import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class ToggleIconButton extends StatefulWidget {
  const ToggleIconButton({super.key});

  @override
  ToggleIconButtonState createState() => ToggleIconButtonState();
}

class ToggleIconButtonState extends State<ToggleIconButton> {
  bool _isEnabled = false;

  void _toggleIcon() {
    setState(() {
      _isEnabled = !_isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isEnabled ? Icons.toggle_on : Icons.toggle_off,
        color: _isEnabled
            ? AppColors.PRIMARY_COLOR
            : AppColors.PRIMARY_COLOR.withOpacity(0.5),
        size: 44,
      ),
      onPressed: _toggleIcon,
    );
  }
}
