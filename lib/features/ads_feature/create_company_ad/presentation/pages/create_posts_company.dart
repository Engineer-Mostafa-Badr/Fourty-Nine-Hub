import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../res/style/styles.dart';

class CreatePostCompany extends StatefulWidget {
  const CreatePostCompany({
    super.key,  this.text=true,  this.picture=true, required this.title,
  });
  final bool text ;
  final bool picture;
  final String title;

  @override
  State<CreatePostCompany> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostCompany> {
  var postContentTextController = TextEditingController();

  Future<bool> onBackPressed() async {
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        centerTitle: false,
        label: widget.title,
        actions: [
          TextButton(child: const Label(text: 'Post'), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          if(widget.text)
          _buildCreatePost(),
          if(widget.picture)
            Column(
              children: [
                _buildMediaCard(),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20.zR),
                  ),
                  child: Center(
                    child: Text(
                      'Upload Image',
                      style: Styles.headerText(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCreatePost() {
    return Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: TextField(
          maxLines: 4,
          maxLength: 150,
          style: const TextStyle(color: AppColors.QUANTITY_COLOR),
          onChanged: (c) {
            if (c.length == 150) {
              showErrorMessage(
                  context, "You can't type more than 150 character");
            }
          },
          controller: postContentTextController,
          decoration: const InputDecoration(
              hintText: 'Type Here ... ',
              hintStyle: TextStyle(color: AppColors.QUANTITY_COLOR),
              fillColor: Colors.white),
        ));
  }

  Widget _buildMediaCard() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2 == 1 ? 1 : 2),
        itemCount: 2 < 4 ? 2 : 4,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            // if (index != 3 || (index == 3 && 4 == 4)) {
            //   showDialog(
            //       context: context,
            //       builder: (context) => ImageDetailsScreen(
            //       //  image: state.images![index].file.path,
            //         image: 'https://th.bing.com/th/id/OIP.HxV79tFMPfBAIo0BBF-sOgHaEy?rs=1&pid=ImgDetMain',
            //         isFile: true,
            //         onRemoveImage: () {
            //           // controller.removePhoto(state.images![index]);
            //           // context.pop();
            //         },
            //       ));
            // } else {
            //   showDialog(
            //       context: context,
            //       builder: (context) => ShowAllImages(
            //         images: [],
            //         onRemoveImage: () {},
            //         // onRemoveImage: (UploadFileEntity image) {
            //         //   controller.removePhoto(image);
            //         // },
            //       ));
            // }
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
                        image: NetworkImage('https://th.bing.com/th/id/OIP.HxV79tFMPfBAIo0BBF-sOgHaEy?rs=1&pid=ImgDetMain'),
                      ),
                      // image: FileImage(
                      //   File(state.images?[index].file.path ?? ''),
                      // ),
                    ),
                  ),
                  if (index == 3 && 3 > 4)
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
                          text: "+",
                          // text: "+${state.images!.length - 4}",
                          style: Styles.headerText(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (index == 0 && 2== 1)
                PositionedDirectional(
                  end: 15,
                  top: 5,
                  child: InkWell(
                    onTap: () {
                      //controller.removePhoto(state.images?[index]);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
