import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadMoreLabel extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? trimLines;

  const ReadMoreLabel({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.trimLines,
  });

  @override
  State<ReadMoreLabel> createState() => _ReadMoreLabelState();
}

class _ReadMoreLabelState extends State<ReadMoreLabel> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;
  final int characterLimit = 300;

  // Variable to store if the link is being pressed
  bool isLinkPressed = false;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > characterLimit) {
      firstHalf = widget.text.substring(0, characterLimit);
      secondHalf = widget.text.substring(characterLimit, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf!.isEmpty
          ? _buildRichText(firstHalf!)
          : Column(
              children: <Widget>[
                _buildRichText(
                    flag ? ("${firstHalf!}...") : (firstHalf! + secondHalf!)),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        flag ? "show more" : "show less",
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }

  // Function to handle clickable links in the text
  Widget _buildRichText(String text) {
    final List<TextSpan> spans = _getTextSpans(
      text,
      widget.style ?? Styles.headerText(fontSize: 60.sp),
    );
    return Align(
      alignment: widget.textAlign == TextAlign.right
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: RichText(
        textAlign: widget.textAlign ?? TextAlign.left,
        text: TextSpan(children: spans),
      ),
    );
  }

  // Function to extract URLs and create TextSpans for normal text and links
  List<TextSpan> _getTextSpans(String text, TextStyle style) {
    final List<TextSpan> spans = [];
    final RegExp linkRegExp = RegExp(
      r'(https?:\/\/[^\s]+)', // Regular expression to detect URLs
      caseSensitive: false,
    );
    final matches = linkRegExp.allMatches(text);

    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: style, // Normal text style
        ));
      }

      final String url = match.group(0)!;
      spans.add(TextSpan(
        text: url,
        style: style.copyWith(
          color: isLinkPressed
              ? Colors.blue.shade900
              : Colors.blue, // Darken color on press
          decoration:
              isLinkPressed ? TextDecoration.underline : TextDecoration.none,
        ), // Link style
        recognizer: TapGestureRecognizer()
          ..onTapDown = (_) {
            setState(() {
              isLinkPressed = true; // Change style on press
            });
          }
          ..onTapCancel = () {
            setState(() {
              isLinkPressed = false; // Revert style if tap is canceled
            });
          }
          ..onTap = () {
            _launchURL(url); // Launch the URL on tap
            setState(() {
              isLinkPressed = false; // Revert style after tap
            });
          },
      ));

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: style, // Remaining normal text
      ));
    }

    return spans;
  }

  // Method to launch the URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
