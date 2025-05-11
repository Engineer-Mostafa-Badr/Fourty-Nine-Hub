import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuildSheetItem extends StatelessWidget {
  const BuildSheetItem({super.key, this.onTap, required this.icon, required this.title, this.hasDivider,this.color});
  final GestureTapCallback? onTap;
  final bool? hasDivider;
  final String icon;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: SvgPicture.asset(icon,height: 18,width: 18,color: color,),
          title: Text(title, style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
          horizontalTitleGap: 18,
          onTap: onTap,
        ),
        if(hasDivider==true)const Divider(),

      ],
    );

  }
}
