import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../res/style/app_colors.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;
  final TextStyle? moreStyle;
  final TextStyle? lessStyle;
  final String moreText;
  final String lessText;
  final bool isLoading;

  const ReadMoreText({
    super.key,
    required this.text,
    this.trimLines = 2,
    this.style,
    this.moreStyle,
    this.lessStyle,
    this.moreText = '...Read more',
    this.lessText = 'Read less',
    this.isLoading = false,
  });

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _isExpanded = false;
  bool _needsExpandButton = false;
  double? _lastMaxWidth;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SpinKitThreeBounce(
          color: Theme.of(context).primaryColor,
          size: 20.0,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (_lastMaxWidth != constraints.maxWidth) {
          _lastMaxWidth = constraints.maxWidth;
          WidgetsBinding.instance.addPostFrameCallback(
                (_) => _checkTextOverflow(constraints),
          );
        }

        // For expanded state
        if (_isExpanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.text, style: widget.style),
              const SizedBox(height: 4),
              _buildButton(context),
            ],
          );
        }

        // For truncated state
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.text,
                maxLines: widget.trimLines,
                overflow: TextOverflow.clip,
                style: widget.style,
              ),
            ),
            if (_needsExpandButton) _buildButton(context),
          ],
        );
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          _isExpanded ? widget.lessText : widget.moreText,
          style: _isExpanded
              ? widget.lessStyle ?? _defaultLessStyle(context)
              : widget.moreStyle ?? _defaultMoreStyle(context),
        ),
      ),
    );
  }

  void _checkTextOverflow(BoxConstraints constraints) {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: constraints.maxWidth);
    if (mounted) {
      setState(() {
        _needsExpandButton = textPainter.didExceedMaxLines;
      });
    }
  }

  TextStyle _defaultMoreStyle(BuildContext context) {
    return TextStyle(
      color: AppColors.SECONDARY_COLOR,
      fontWeight: FontWeight.bold,

    );
  }

  TextStyle _defaultLessStyle(BuildContext context) {
    return TextStyle(
      color: AppColors.SECONDARY_COLOR,
      fontWeight: FontWeight.w500,
    );
  }
}