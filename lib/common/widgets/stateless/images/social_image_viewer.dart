import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/styles.dart';
import '../labels/label.dart';

class SocialImageViewer extends StatelessWidget {
  final double? height, width;
  final String image;
  final int length, index;
  final Function? onDoubleTap;
  const SocialImageViewer(
      {super.key,
      this.height,
      this.width,
      this.onDoubleTap,
      required this.image,
      required this.length,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>showDialog(context: context,builder: (context)=>ImageDetailsScreen(image: image, fromPost: true,isFile: false,onRemoveImage: (){
        context.pop();
      },),),
      onDoubleTap: () => onDoubleTap != null ? onDoubleTap!() : null,
      child: SizedBox(
          height: height ?? kToolbarHeight * 3,
          width: width ?? double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image(
                  fit: BoxFit.fill,
                  image: Image.network(image).image,
                ),
              ),
              if(length>1)Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    // height: kToolbarHeight * .5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey),
                    child: Label(
                        text: '$index/$length',
                        style: Styles.mediumText(color: Colors.white)),
                  ))
            ],
          )),
    );
  }
}
