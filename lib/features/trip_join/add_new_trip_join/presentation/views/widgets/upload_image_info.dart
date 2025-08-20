import 'package:flutter/material.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class UploadImageInfo extends StatelessWidget {
  const UploadImageInfo({
    super.key,
    this.number,
    this.isCarImage = false,
    this.isSuccess = false,
  });
  final bool isCarImage;
  final bool isSuccess;
  final int? number;
  @override
  Widget build(BuildContext context) {
    Color color = isSuccess ? Colors.green[400]! : AppColors.SECONDARY_COLOR;
    String text = '';
    IconData icon = isSuccess ? Icons.check : Icons.close;
    if (isCarImage) {
      if (isSuccess) {
        text = '$number Car Images Uploaded';
      } else {
        text = '$number Car Images Remaining';
      }
    } else {
      if (isSuccess) {
        text = 'Car Plate Number Image Uploaded';
      } else {
        text = 'Car Plate Number Image Remaining';
      }
    }
    return Row(
      children: [
        Icon(icon, color: color),
        Text(
          text,
          style: Styles.mediumText(),
        ),
      ],
    );
  }
}
