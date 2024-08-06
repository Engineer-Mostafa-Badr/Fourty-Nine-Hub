import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/show_post_images.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class FacebookAdvertisementCard extends StatelessWidget {
  const FacebookAdvertisementCard({super.key, required this.post});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: post.images!.length == 1 ? 1 : 2),
            itemCount:
            post.images!.length < 4 ? post.images!.length : 4,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                if (index != 3 ||
                    (index == 3 && post.images!.length == 4)) {
                  showDialog(
                      context: context,
                      builder: (context) => ImageDetailsScreen(
                        image: post.images![index],
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
                          images: post.images??[],
                          onRemoveImage: (UploadFileEntity image) {
                            // controller.removePhoto(image);
                          },
                        );
                      }
                  );
                }
              },
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsetsDirectional.only(
                            end: 10, bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              post.images?[index]??'',
                            ),
                          ),
                        ),
                      ),
                      if (index == 3 && post.images!.length > 4)
                        Container(
                          margin: const EdgeInsetsDirectional.only(
                              end: 10, bottom: 10),
                          // padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Label(
                              text: "+${post.images!.length - 4}",
                              style: Styles.headerText(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (index == 0 && post.images!.length == 1)
                    PositionedDirectional(
                      end: 15,
                      top: 5,
                      child: InkWell(
                        onTap: () {
                          // controller.removePhoto(post.images?[index]);
                        },
                        child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                            )),
                      ),
                    ),
                ],
              ),
            )),
        const SizedBox(height: 10,),
        Label(text: post.description??'',),
        const SizedBox(height: 10,),
        Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: DefaultButton(onPressed: (){},label: 'Send Message',labelStyle: Styles.headerText(color: Colors.white,fontSize: 20),))
      ],
    );
  }
}
