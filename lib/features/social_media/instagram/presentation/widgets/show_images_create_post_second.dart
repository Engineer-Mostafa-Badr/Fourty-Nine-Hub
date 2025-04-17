import 'dart:io';

import 'package:flutter/material.dart';

class ShowImagesCreatePostSecond extends StatelessWidget {
  const ShowImagesCreatePostSecond({
    super.key,
    required this.selectedImages,
  });
  final List<Future<File?>> selectedImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.25,
      child: PageView.builder(
        itemCount: selectedImages.length,
        itemBuilder: (context, index) {
          return FutureBuilder<File?>(
            future: selectedImages[index],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.file(snapshot.data!);
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );
  }
}
