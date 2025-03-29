import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

class ReadMoreText extends StatefulWidget {
  final String username;
  final String description;
  final TextStyle? usernameStyle;
  final TextStyle? descriptionStyle;
  final int maxLines;

  const ReadMoreText({
    super.key,
    required this.username,
    required this.description,
    this.usernameStyle,
    this.descriptionStyle,
    this.maxLines = 2,
  });

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: '${widget.username} ',
          style: widget.usernameStyle ??
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          children: [
            TextSpan(
              text: _expanded
                  ? widget.description
                  : _trimText(widget.description, constraints.maxWidth),
              style: widget.descriptionStyle ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            TextSpan(
              text: _expanded ? ' less' : (_exceedsMaxLines(widget.description, constraints.maxWidth) ? ' more' : ''),
              style: (widget.descriptionStyle ?? const TextStyle(fontSize: 16))
                  .copyWith(color: const Color(0xff6E6E6E)),
            ),
          ],
        );

        return GestureDetector(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: RichText(text: textSpan),
        );
      },
    );
  }

  bool _exceedsMaxLines(String text, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: widget.descriptionStyle),
      maxLines: widget.maxLines,
      textDirection: context.isArabic? TextDirection.rtl : TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  String _trimText(String text, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: widget.descriptionStyle),
      maxLines: widget.maxLines,
      textDirection: context.isArabic? TextDirection.rtl : TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth);

    int endIndex = text.length;
    while (endIndex > 0 && textPainter.didExceedMaxLines) {
      endIndex -= 1;
      textPainter.text = TextSpan(text: text.substring(0, endIndex) + '...', style: widget.descriptionStyle);
      textPainter.layout(maxWidth: maxWidth);
    }

    return text.substring(0, endIndex) + '...';
  }
}