import 'package:flutter/material.dart';
import '../../../../../../common/functions/global/upload_file.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../create_post/presentation/widgets/image_details.dart';
import '../../../domain/entities/post_entity.dart';
import '../../pages/show_post_images.dart';
import '../facebook_widgets/image_from_internet.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/manage_vibration.dart';

class FacebookAdvertisementCard extends StatelessWidget {
  const FacebookAdvertisementCard({super.key, required this.post});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.DIVIDER_GRAY_COLOR),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.42,
            child: GridView.builder(
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: post.images.length == 1 ? 1 : 2),
                itemCount: post.images.length < 4 ? post.images.length : 4,
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
      ManageVibration.vibrate();
                        if (index != 3 ||
                            (index == 3 && post.images.length == 4)) {
                          showDialog(
                              context: context,
                              builder: (context) => ImageDetailsScreen(
                                    image: post.images[index],
                                    fromPost: true,
                                    onRemoveImage: () {
                                      // controller
                                      //     .removePhoto(post.images![index]);
                                      context.pop();
                                    },
                                  ));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ShowPostsImages(
                                  images: post.images ?? [],
                                  onRemoveImage: (UploadFileEntity image) {
                                    // controller.removePhoto(image);
                                  },
                                );
                              });
                        }
                      },
                      child: Stack(
                        children: [
                          ImageFromInternet(
                            image: post.images[index] ?? '',
                            borderRadius: BorderRadius.circular(5),
                            defaultLogo: true,
                          ),

                          // Container(
                          //   margin: EdgeInsetsDirectional.only(
                          //       end: 10, bottom: 10),
                          //   padding: EdgeInsets.all(10),
                          //   decoration: BoxDecoration(
                          //     color: Colors.red,
                          //     borderRadius: BorderRadius.circular(15),
                          //     image: DecorationImage(
                          //       fit: BoxFit.fill,
                          //       image: NetworkImage(
                          //         post.images?[index] ?? '',
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          if (index == 3 && post.images.length > 4)
                            Container(
                              margin: const EdgeInsetsDirectional.only(
                                  end: 10, bottom: 10),
                              // padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Label(
                                  text: "+${post.images.length - 4}",
                                  style: Styles.headerText(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
          ),
          SizedBox(
            height: 10.h,
          ),
          Label(
            text: post.description ?? '',
          ),
          SizedBox(
            height: 10.h,
          ),
          GestureDetector(
            onTap: () {

      ManageVibration.vibrate();
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Label(
                text: LocaleKeys.sendMessage.localize,
                style: Styles.headerText(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}