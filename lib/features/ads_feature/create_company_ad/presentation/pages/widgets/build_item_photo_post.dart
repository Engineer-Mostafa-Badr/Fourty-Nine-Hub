import 'package:flutter/material.dart';

import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../social_media/create_post/presentation/widgets/image_details.dart';
import '../../../../../social_media/create_post/presentation/widgets/show_all_images.dart';
import '../../../data/models/company_advertise_model.dart';

class BuildItemPhotoPost extends StatelessWidget {
  const BuildItemPhotoPost({super.key, required this.media, this.length});
  final Media media;
  final length;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: length == 1 ? 1 : 2),
        itemCount:length < 4 ? length: 4,
        itemBuilder: (context, index) =>
            InkWell(
              onTap: () {
                if (index != 3 ||
                    (index == 3 && length == 4)) {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          ImageDetailsScreen(
                            image: media.photo!,
                            isFile: true,
                            onRemoveImage: () {
                              // controller.removePhoto(media.photo!);
                              // context.pop();
                            },
                          )
                  );
                } else {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          ShowAllImages(
                            images: length, onRemoveImage: (){},
                            // onRemoveImage: (UploadFileEntity image) {
                            //   controller.removePhoto(image);
                            // },
                          )
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
                            image: NetworkImage(media.photo!),
                          ),
                        ),
                      ),
                      if (index == 3 && length > 4)
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
                              text: "+${media.photo!.length - 4}",
                              style: Styles.headerText(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // if (index == 0 && media.photo!.length == 1)
                  //   PositionedDirectional(
                  //     end: 15,
                  //     top: 5,
                  //     child: InkWell(
                  //       onTap: () {},
                  //       child: const Icon(
                  //         Icons.close,
                  //         color: Colors.red,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ));
  }
}
