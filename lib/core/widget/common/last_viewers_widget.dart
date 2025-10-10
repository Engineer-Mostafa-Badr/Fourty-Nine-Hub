import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/available_trip_join_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class LastViewersWidget extends StatelessWidget {
  const LastViewersWidget({super.key, this.lastViewers});
  final List<ViewerEntity>? lastViewers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(context.isArabic?'آخر المشاهدات':'Last Viewers',style: Styles.headerText(color: context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR),),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: List.generate(lastViewers?.length??0, (i)=>Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    ImageFromInternet(
                        image: '',
                        isCircle: true,
                        defaultLogo: false,
                        isMale: lastViewers?[i].gender=='male',
                        width: 40,
                        height: 40,
                        firstChar: lastViewers?[i].firstName?[0].toUpperCase(),
                        charPadding: 0),
                    const Sizer(),
                    Text(lastViewers?[i].firstName??'',style: Styles.mediumText(color: context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR),),
                  ],
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
