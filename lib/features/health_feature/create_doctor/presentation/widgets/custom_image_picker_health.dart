import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class CustomImagePickerHealth extends StatelessWidget {
  const CustomImagePickerHealth({
    super.key,
    required this.onTap,
    required this.isUploaded,
  });
  final void Function()? onTap;
  final bool isUploaded;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 105,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Center(
          child: isUploaded
              ? const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.grey,
                )
              : SvgPicture.asset(
                  Assets.image2Icon,
                ),
        ),
      ),
    );
  }
}
