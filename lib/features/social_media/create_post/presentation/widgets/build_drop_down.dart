import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../res/style/app_colors.dart';

class BuildDropDown extends StatelessWidget {
  const BuildDropDown({super.key, required this.text, required this.icon, this.width, this.height, this.fontWeight});
  final String text;
  final String icon;
  final double? width;
  final double? height;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      constraints: BoxConstraints(
        maxWidth: 150, //  حسب الحاجة
      ),
      decoration: BoxDecoration(
        color: context.isDarkMode?AppColors.getFillColor(context):AppColors.GREYCARD,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // دي مهمة جداً
        children: [
          SvgPicture.asset(icon, width: width??16,height: height??16,color: context.isDarkMode?Colors.white:null,),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR)),
          const Icon(Icons.arrow_drop_down, size: 22),
        ],
      ),
    );
  }
}
