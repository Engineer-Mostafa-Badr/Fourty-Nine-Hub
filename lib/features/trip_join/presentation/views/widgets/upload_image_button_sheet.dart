import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/upload_button_and_info.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/upload_image_popup.dart';
import 'package:go_router/go_router.dart';

class UploadImageButtonSheet extends StatelessWidget {
  const UploadImageButtonSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        child: Column(
          children: [
            const Sizer(),
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            const Sizer(),
            UploadButtonAndInfo(
              isCarImage: true,
              number: 1,
              isSuccess: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadImagePopup(
                      cameraCallback: () {},
                      galleryCallback: () {},
                    );
                  },
                );
              },
            ),
            UploadButtonAndInfo(
              isCarImage: true,
              number: 2,
              isSuccess: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadImagePopup(
                      cameraCallback: () {},
                      galleryCallback: () {},
                    );
                  },
                );
              },
            ),
            UploadButtonAndInfo(
              isCarImage: true,
              number: 3,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadImagePopup(
                      cameraCallback: () {},
                      galleryCallback: () {},
                    );
                  },
                );
              },
            ),
            UploadButtonAndInfo(
              isCarImage: true,
              number: 4,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadImagePopup(
                      cameraCallback: () {},
                      galleryCallback: () {},
                    );
                  },
                );
              },
            ),
            UploadButtonAndInfo(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadImagePopup(
                      cameraCallback: () {},
                      galleryCallback: () {},
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
