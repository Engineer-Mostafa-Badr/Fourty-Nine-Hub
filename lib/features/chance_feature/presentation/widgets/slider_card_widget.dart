import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';

class SliderCardWidget extends StatefulWidget {
  const SliderCardWidget({super.key});

  @override
  State<SliderCardWidget> createState() => _SliderCardWidgetState();
}

class _SliderCardWidgetState extends State<SliderCardWidget> {
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 9.0,
          thumbShape: SliderComponentShape.noThumb,
          activeTrackColor: AppColors.SECONDARY_COLOR,
          inactiveTrackColor: AppColors.GREY_NORMAL_COLOR,
        ),
        child: Slider(
          value: _sliderValue,
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: (value) {
            setState(() {
              _sliderValue = value; // تحديث القيمة عند سحب الشريحة
            });
          },
        ),
      ),
    );
  }
}
