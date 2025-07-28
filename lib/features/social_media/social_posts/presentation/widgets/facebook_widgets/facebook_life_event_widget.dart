import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/pages/life_event.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class FacebookLifeEventWidget extends StatelessWidget {
  const FacebookLifeEventWidget({super.key, required this.postEntity});
  final PostEntity postEntity;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(postEntity.lifeEvent?.subCatImages!=null&&(postEntity.lifeEvent?.subCatImages.isNotEmpty??false))...[SizedBox(
          height: 256,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              PageView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: postEntity.lifeEvent?.subCatImages.length??0,
                  itemBuilder: (context, index) {
                    return ImageFromInternet(
                      image: postEntity.lifeEvent?.subCatImages[index]??'',
                      height: 256,
                      width: double.infinity,
                      defaultLogo: true,
                    );
                  },
                  onPageChanged: (index) {
                    // context.read<CreatePostCubit>().onChangePage(index);
                  }
              ),
              PositionedDirectional(
                top: 238,
                start: 0,
                end: 0,
                child: Container(
                  height: 42,
                  width: 42,
                  // padding: EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    color: AppColors.SECONDARY_COLOR,
                    shape: BoxShape.circle,
                  ),
                  child: CachedSvgImage(imageUrl: postEntity.lifeEvent?.mainCatImage??'',height: 20,width: 20,color: Colors.white,),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        )],
        if(postEntity.lifeEvent?.subCatImages==null||(postEntity.lifeEvent?.subCatImages.isEmpty??false))...[
          Container(
            height: 42,
            width: 42,
            // padding: EdgeInsets.all(4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              color: AppColors.SECONDARY_COLOR,
              shape: BoxShape.circle,
            ),
            child: CachedSvgImage(imageUrl: postEntity.lifeEvent?.mainCatImage??'',height: 20,width: 20,color: Colors.white,),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
        Text(
            postEntity.lifeEvent?.title??'',style: const TextStyle(color: AppColors.PRIMARY_COLOR,fontSize: 20,fontWeight: FontWeight.w600),
        ),
        const SizedBox(
            height: 4
        ),
        Text(
          FormatDate().formatDate(postEntity.lifeEvent?.date??''),style: const TextStyle(color: AppColors.GREY_DARK_COLOR,fontSize: 14,fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 4
        ),
        Text(
            postEntity.lifeEvent?.desc??'',style: const TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
