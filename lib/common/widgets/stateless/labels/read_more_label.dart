import 'package:flutter/material.dart';
// import 'package:readmore/readmore.dart';


class ReadMoreLabel extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? trimLines;
  const ReadMoreLabel(
      {super.key,
      required this.text,
      this.style,
      this.textAlign,
      this.trimLines});

  @override
  State<ReadMoreLabel> createState() => _ReadMoreLabelState();
}

class _ReadMoreLabelState extends State<ReadMoreLabel> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded
              ? widget.text
              : '${widget.text.substring(0, widget.trimLines)}...',
          style: widget.style,
          textAlign: widget.textAlign,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(isExpanded ? 'Read Less' : 'Read More'),
        ),
      ],
    );
  }
}
