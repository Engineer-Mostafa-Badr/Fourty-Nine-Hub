import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../res/style/styles.dart';

class CustomSearchHealth extends StatelessWidget {
  final Function(String)? onSearch;

  const CustomSearchHealth({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2C3E50), // Navy desaturated blue border
          width: 1.5,
        ),
      ),
      child: Row(
          children: [
            Sizer(width: 20,),
          Icon(Icons.search,size: 30,),
      Sizer(width: 15,),
      Text("Search",style: Styles.mediumText(color: AppColors.black),
      ),]
    ),
    );
  }
}
