import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class OTPTimer extends StatefulWidget {
  final VoidCallback onResendPressed;

  const OTPTimer({super.key, required this.onResendPressed});

  @override
  State<OTPTimer> createState() => _OTPTimerState();
}

class _OTPTimerState extends State<OTPTimer> {
  static const int _resendTime = 240; // 60 seconds
  int _secondsRemaining = _resendTime;
  Timer? _timer;
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = _resendTime;
      _isEnabled = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        setState(() => _isEnabled = true);
      }
    });
  }

  void _resendOTP() {
    widget.onResendPressed(); // Notify parent about resend request
    _startTimer(); // Restart the countdown
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Label(
          text: LocaleKeys.DidntReceiveOTP.localize,
          style: Styles.mediumText(),
        ),
        const SizedBox(width: 8),
        _isEnabled
            ? TextButton(
                onPressed: _resendOTP,
                child: Text(
                  LocaleKeys.resendOTP.localize,
                  style: TextStyle(color: AppColors.SECONDARY_COLOR),
                ),
              )
            : Label(
                text: _formattedTime,
                style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
              ),
      ],
    );
  }
}
