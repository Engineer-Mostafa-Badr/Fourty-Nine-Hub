import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class CustomImagePickerHealth extends StatelessWidget {
  const CustomImagePickerHealth({
    super.key,
    required this.onTap,
    required this.isUploaded,
    this.imageFile,
  });

  final void Function()? onTap;
  final bool isUploaded;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 105,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color:  AppColors.getFindFillColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: imageFile != null
            ? Image.file(
          imageFile!,
          fit: BoxFit.cover,
        )
            : Center(
          child: SvgPicture.asset(
            Assets.image2Icon,
            color: AppColors.getTextColor(context),
          ),
        ),
      ),
    );
  }
}

// class CustomImagePickerHealth extends StatelessWidget {
//   const CustomImagePickerHealth({
//     super.key,
//     required this.onTap,
//     required this.isUploaded,
//   });
//   final void Function()? onTap;
//   final bool isUploaded;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 100,
//         width: 105,
//         clipBehavior: Clip.antiAlias,
//         decoration: ShapeDecoration(
//           color: const Color(0xFFD9D9D9),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         child: Center(
//           child: isUploaded
//               ? const Icon(
//                   Icons.check_circle_outline_rounded,
//                   color: Colors.grey,
//                 )
//               : SvgPicture.asset(
//                   Assets.image2Icon,
//                 ),
//         ),
//       ),
//     );
//   }
// }
