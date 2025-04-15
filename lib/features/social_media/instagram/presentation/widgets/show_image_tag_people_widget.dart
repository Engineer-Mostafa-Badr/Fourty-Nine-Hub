
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ShowImageTagPeopleWidget extends StatefulWidget {
  const ShowImageTagPeopleWidget({
    super.key,
    required this.images,
    required this.onTap,
  });

  final List<File> images;
  final void Function() onTap;

  @override
  State<ShowImageTagPeopleWidget> createState() =>
      _ShowImageTagPeopleWidgetState();
}

class _ShowImageTagPeopleWidgetState extends State<ShowImageTagPeopleWidget> {
  final List<Offset> _tapPositions = [];

  /// تقوم باستقبال موقع الضغط
  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _tapPositions.add(details.localPosition);
    });
  }

  /// تقوم بانشاء ويدجت ويعطيه مكان ظهوره
  Widget _buildTapIndicator(Offset position) {
    return Positioned(
      left: position.dx - 40,
      top: position.dy - 10,
      child: _buildCustomIndicator(),
    );
  }

  /// الويدجت التي ستظهر عندما يتم الضغط على الصورة
  Widget _buildCustomIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          Assets.instagramTriangleBlackIcon,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: ShapeDecoration(
            color: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Label(
            text: LocaleKeys.whoIsThis.localize,
            style: Styles.mediumText(color: Colors.white),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                _handleTapDown(details);
                widget.onTap();
              },
              child: Image.file(
                widget.images[index],
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            ..._tapPositions.map((position) => _buildTapIndicator(position)),
          ],
        );
      },
    );
  }
}
