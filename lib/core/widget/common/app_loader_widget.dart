import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

enum AppLoaderSize {
  small(25),
  medium(80),
  large(128);

  final double value;

  const AppLoaderSize(this.value);
}

class AppLoaderWidget extends StatefulWidget {
  /// default is small for footer
  final AppLoaderSize size;
  final bool _enableLogo;
  final Color? color;

  const AppLoaderWidget.mediumProgress({super.key, this.color})
      : size = AppLoaderSize.medium,
        _enableLogo = false;

  const AppLoaderWidget.smallProgress({super.key, this.color})
      : size = AppLoaderSize.small,
        _enableLogo = false;

  const AppLoaderWidget.largeLogo({super.key, this.color})
      : _enableLogo = true,
        size = AppLoaderSize.large;

  @override
  State<AppLoaderWidget> createState() => _AppLoaderWidgetState();
}

class _AppLoaderWidgetState extends State<AppLoaderWidget> with SingleTickerProviderStateMixin {
  /// Bounce Curve
  late AnimationController _controller;


  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.repeat();
    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._enableLogo) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SpinKitSpinningLines(color:AppColors.SECONDARY_COLOR),
            Sizer(),
            Text(
              context.isArabic?'جاري التحميل...':'Loading...',
              style: Styles.mediumText(color: !context.isDarkMode?AppColors.PRIMARY_COLOR:AppColors.whiteColor),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.square(
        dimension: widget.size.value,
        child: CircularProgressIndicator(
          color: widget.color,
          strokeCap: StrokeCap.round,
          strokeWidth: 2.5,
        ),
      );
    }
  }
}
