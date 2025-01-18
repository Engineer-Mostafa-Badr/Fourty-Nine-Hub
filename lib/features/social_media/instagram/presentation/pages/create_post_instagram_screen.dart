import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/create_post_details_instagram_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class CreatePostInstagramScreen extends StatefulWidget {
  const CreatePostInstagramScreen({super.key});

  @override
  State<CreatePostInstagramScreen> createState() =>
      _CreatePostInstagramScreenState();
}

class _CreatePostInstagramScreenState extends State<CreatePostInstagramScreen> {
  List<AssetEntity> images = [];
  bool isLoading = true;
  Future<File?>? selectedImage;
  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    final hasPermission = await requestPermission();
    if (hasPermission) {
      final fetchedImages = await fetchAllImages();
      setState(() {
        images = fetchedImages;
        selectedImage = images.first.file;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied!')),
      );
    }
  }

  Future<List<AssetEntity>> fetchAllImages() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        // type: RequestType.fromTypes([RequestType.image, RequestType.video]), // جلب الصور فقط
        type: RequestType.image);

    if (albums.isNotEmpty) {
      final AssetPathEntity album = albums.first; // اختر الألبوم الأول
      List<AssetEntity> allImages = [];
      int page = 0; // ابدأ من الصفحة الأولى
      const int pageSize = 100;

      while (true) {
        // جلب الصور في الصفحة الحالية
        final List<AssetEntity> images =
            await album.getAssetListPaged(page: page, size: pageSize);
        if (images.isEmpty) {
          break; // إذا لم تكن هناك صور إضافية، أخرج من الحلقة
        }
        allImages.addAll(images); // أضف الصور إلى القائمة النهائية
        page++; // انتقل إلى الصفحة التالية
      }

      return allImages;
    }

    return [];
  }

  bool multiSelect = false;
  List<AssetEntity> selectedMeda = [];

  BoxFit? fit;
  Future<bool> requestPermission() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    return result.isAuth; // تحقق من أن الإذن مُعطى
  }

  List postTypes = ["Post", "Story", "Reel"];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (images.isEmpty) {
      return const Center(child: Text('No images found!'));
    }

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        // shadowColor: Colors.white,
        elevation: 0,
        
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        title: Text(
          "New Post",
          style: Styles.headerText(fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              List<File> fileImges = [];
              for (var item in selectedMeda) {
                File? file = await item.file;
                fileImges.add(file!);
              }
              File? oneImage = await selectedImage;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePostDetailsInstagramScreen(
                        images: multiSelect ? fileImges : [oneImage!]),
                  ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Next",
                style: Styles.headerText(fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          if (selectedImage == null)
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
              child: selectedImage == null
                  ? Center(
                      child: Text(
                      "Select Image",
                      style: Styles.headerText(fontWeight: FontWeight.w400),
                    ))
                  : null,
            )
          else
            FutureBuilder<File?>(
              future: selectedImage,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(20),
                          minScale: 1.0, // الحد الأدنى للتكبير
                          maxScale: 4.0, // الحد الأقصى للتكبير
                          scaleEnabled: true, // تمكين التكبير
                          child: Image.file(
                            snapshot.data!,
                            fit:
                                fit, // تضمن عرض الصورة بالكامل مع الحفاظ على الأبعاد
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (fit == BoxFit.contain) {
                                fit = BoxFit.cover;
                              } else {
                                fit = BoxFit.contain;
                              }
                            });
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            margin: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.PRIMARY_COLOR),
                            child: const Icon(
                              Icons.expand,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: Text(
                      "Select Image",
                      style: Styles.headerText(fontWeight: FontWeight.w400),
                    ),
                  );
                }
              },
            ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          "Recents ›",
                          style: Styles.headerText(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              multiSelect = !multiSelect;
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: multiSelect
                                  ? Colors.white
                                  : AppColors.PRIMARY_COLOR,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.copy,
                                color:
                                    multiSelect ? Colors.black : Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const Sizer(),
                        GestureDetector(
                          onTap: () async {
                            var pickedImage = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            if (pickedImage != null) {
                              setState(() {
                                Future<File?> futureFile =
                                    Future.value(File(pickedImage.path));
                                selectedImage =
                                    futureFile; // تعيين الصورة في selectedImage
                              });
                            }
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder<Uint8List?>(
                              future: images[index].originBytes, // تصغير الصور
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (multiSelect) {
                                        // selectedMeda.add(images[index]);
                                        if (selectedMeda
                                            .contains(images[index])) {
                                          selectedMeda.remove(images[index]);
                                        } else {
                                          selectedMeda.add(images[index]);
                                        }
                                        selectedImage = images[index].file;
                                      } else {
                                        selectedImage = images[index].file;
                                      }
                                      setState(() {});
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
                                                    color: Colors.white
                                                        .withOpacity(0.4),
                                                    border: Border.all(
                                                        color: Colors.white)),
                                                child: Center(
                                                    child:
                                                        selectedMeda.contains(
                                                                images[index])
                                                            ? Text(
                                                                (selectedMeda.indexOf(
                                                                            images[index]) +
                                                                        1)
                                                                    .toString(),
                                                                style: Styles
                                                                    .headerText(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            30),
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
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 25,
                          child: Container(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(10), // لجعل الحواف دائرية
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10.0, // التمويه على المحور X
                                  sigmaY: 10.0, // التمويه على المحور Y
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  height: 50,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 70),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.black.withOpacity(
                                        0.6), // لون شفاف لإظهار التأثير الزجاجي
                                    // border: Border.all(
                                    //   color: Colors.white.withOpacity(
                                    //       0.3), // إطار شفاف لتحسين الشكل
                                    //   width: 1,
                                    // ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ...List.generate(postTypes.length, (index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            postTypes[index],
                                            style: Styles.headerText(
                                                color: index == 0?  Colors.white:Colors.grey, fontWeight: index == 0?FontWeight.bold:FontWeight.w400),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ImageCard extends StatefulWidget {
//   const ImageCard({super.key, required this.media});
//   final File media;

//   @override
//   State<ImageCard> createState() => _ImageCardState();
// }

// class _ImageCardState extends State<ImageCard> {
//   late VideoP
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
