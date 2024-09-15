import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadImageWidget extends StatefulWidget {
  final String label;
  final Function action;
  final IconData? icon;
  const UploadImageWidget(
      {super.key, required this.action, required this.label, this.icon});

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.action(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: .5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Icon(widget.icon ?? Icons.upload),
            ),
            Sizer(
              height: 5.h,
            ),
            Label(
              text: widget.label,
            ),
          ],
        ),
      ),
    );
  }
}
