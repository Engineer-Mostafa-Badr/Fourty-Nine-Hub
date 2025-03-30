import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:photo_manager/photo_manager.dart';

class PostBodyCreatePostInstagramGridView extends StatelessWidget {
  const PostBodyCreatePostInstagramGridView({
    super.key,
    required this.onTap,
    required this.images,
    required this.multiSelect,
    required this.selectedMeda,
  });

  final void Function(int)? onTap;
  final List<AssetEntity> images;
  final bool multiSelect;
  final List<AssetEntity> selectedMeda;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 3,
        mainAxisSpacing: 2,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Uint8List?>(
          future: images[index].originBytes, // تصغير الصور
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return GestureDetector(
                onTap: () {
                  context.read<CreatePostInstagramCubit>().onTapImage(index);
                },
                child: Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: MemoryImage(snapshot.data!),
                      fit: BoxFit.cover,
                    )),
                    child: multiSelect
                        ? Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.4),
                                border: Border.all(color: Colors.white)),
                            child: Center(
                                child: selectedMeda.contains(images[index])
                                    ? Text(
                                        (selectedMeda.indexOf(images[index]) +
                                                1)
                                            .toString(),
                                        style: Styles.headerText(
                                            color: Colors.white, fontSize: 30),
                                      )
                                    : null),
                          )
                        : null),
              );
            }
            return Container(color: Colors.grey);
          },
        );
      },
    );
  }
}
