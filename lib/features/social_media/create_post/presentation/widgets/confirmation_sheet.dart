import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import 'parent_sheet.dart';
import '../../../../../helpers/manage_vibration.dart';

class ConfirmationSheet extends StatelessWidget {
  final String? btnTitle;
  final String? title;
  final String? description;
  final GestureTapCallback? onSafeAsDraft;
  final GestureTapCallback? onDiscardPost;
  final bool isPay;

  const ConfirmationSheet({
    super.key,
    @required this.btnTitle,
    this.onSafeAsDraft,
    this.onDiscardPost,
    this.description,
    this.title,
    this.isPay = false,
  });

  @override
  Widget build(BuildContext context) {
    return ParentSheet(
      childPadding: const EdgeInsetsDirectional.only(start: 10,end: 28,top: 12,bottom: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Want to finish your post late?',
            style: TextStyle(color: AppColors.black, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Save it as a draft or you can continue editing it. ',
            style: TextStyle(color: AppColors.DARK_GRAY_COLOR, fontSize: 14),
          ),
          const SizedBox(height: 35),
          ClickableWidget(
              onTap: onSafeAsDraft,
              child: Row(
            children: [
              SvgPicture.asset(Assets.draftPost,height: 20,width: 20,),
              const SizedBox(width: 6,),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Save as draft',style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                  ),),
                  Text('You will receive a notification with your draft',style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.GREY_DARK_COLOR
                  ),),
                ],
              )
            ],
          )),
          SizedBox(
            height: 35,
          ),
          ClickableWidget(
              onTap: onDiscardPost,
              child: Row(
                children: [
                  SvgPicture.asset(Assets.discardPost,height: 20,width: 20,),
                  const SizedBox(width: 8,),
                  const Text('Discard post',style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),)
                ],
              )),
          SizedBox(
            height: 35,
          ),
          ClickableWidget(
              onTap: (){
      ManageVibration.vibrate();
                context.pop();
              },
              child: Row(
                children: [
                  SvgPicture.asset(Assets.continueEditing,height: 20,width: 20,),
                  const SizedBox(width: 8,),
                  const Text('Continue editing',style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.SECONDARY_COLOR
                  ),)
                ],
              )),
        ],
      ),
    );
  }
}