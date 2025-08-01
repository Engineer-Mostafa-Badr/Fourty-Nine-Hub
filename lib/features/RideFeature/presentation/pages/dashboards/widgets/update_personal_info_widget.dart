import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/assets/assets.dart';

class UpdatePersonalInfoWidget extends StatefulWidget {
  final String title;
  final int exdIn;
  final bool? isEnabled;
  const UpdatePersonalInfoWidget(
      {super.key, required this.title, required this.exdIn, this.isEnabled=true});

  @override
  State<UpdatePersonalInfoWidget> createState() =>
      _UpdatePersonalInfoWidgetState();
}

class _UpdatePersonalInfoWidgetState extends State<UpdatePersonalInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
        Expanded(child:   Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500)),
            Text('Exd.in ${widget.exdIn} days',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.black54)),
          ],
        ),),
          const Spacer(),
           Text(LocaleKeys.update.tr(),//'Update',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,
              color: widget.isEnabled==true?null:AppColors.GREY_DARK_COLOR
              )),
          const SizedBox(width: 8),
          Image.asset(Assets.update,color: context.isDarkMode?(widget.isEnabled==true?AppColors.PRIMARY_COLOR_DARK:AppColors.GREY_DARK_COLOR):widget.isEnabled==true?null:AppColors.GREY_DARK_COLOR,),
        ],
      ),
    );
  }
}
