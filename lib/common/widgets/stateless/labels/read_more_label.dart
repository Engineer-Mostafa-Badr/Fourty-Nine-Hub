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
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 50) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf!.isEmpty
          ? Text(firstHalf!)
          : Column(
              children: <Widget>[
                Text(flag ? ("${firstHalf!}...") : (firstHalf! + secondHalf!)),
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
}
