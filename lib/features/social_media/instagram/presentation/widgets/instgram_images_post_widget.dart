import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstgramImagesPostWidget extends StatefulWidget {
  const InstgramImagesPostWidget({super.key, required this.images});
  final List images;

  @override
  State<InstgramImagesPostWidget> createState() =>
      _InstgramImagesPostWidgetState();
}

class _InstgramImagesPostWidgetState extends State<InstgramImagesPostWidget> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.images.length == 1) {
      return Container(
        height: 400,
        color: Colors.red,
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 400,
            child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(8),
                  height: 400,
                  color: Colors.red,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withValues(alpha: 0.5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text("${currentIndex+1}/${widget.images.length}", style: Styles.mediumText(color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                );
              },
            ),
          ),
          Sizer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
            widget.images.length,
            (index) {
              return AnimatedContainer(
                margin: EdgeInsets.symmetric(horizontal: 2),
                duration: Duration(milliseconds: 500),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index? AppColors.PRIMARY_COLOR: Colors.grey,
                ),
              );
            },
          )
            ],
          )
        ],
      );
    }
  }
}
