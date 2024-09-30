// // ignore_for_file: use_build_context_synchronously

// // part of 'camera_picker.dart';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/core/extensions/file_extension.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';

// class MediaSliderView extends StatefulWidget {
//   final ChatRoomCubit chatRoomCubit;
//   const MediaSliderView({super.key, required this.chatRoomCubit});

//   @override
//   State<MediaSliderView> createState() => _MediaSliderViewState();
// }

// class _MediaSliderViewState extends State<MediaSliderView> {
//   int _selectedIndex = 0;
//   late PageController _pageController;
//   late ScrollController _scrollController;
//   bool isLoading = false;

//   @override
//   void initState() {
//     _pageController = PageController(initialPage: _selectedIndex);
//     _scrollController = ScrollController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   // Function to scroll the horizontal list to the selected thumbnail
//   void _scrollToSelectedThumbnail(int index) {
//     double offset = index * 155.0; // Adjust width + padding/margin here
//     _scrollController.animateTo(
//       offset,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: BlocProvider.value(
//         value: widget.chatRoomCubit,
//         child: Builder(
//           builder: (context) {
//             return Scaffold(
//               backgroundColor: Colors.black,
//               body: Stack(
//                 children: [
//                   // The PageView for media (background layer)
//                   Positioned.fill(
//                     child: PageView.builder(
//                       controller: _pageController,
//                       itemCount: context.read<ChatRoomCubit>().media.length,
//                       onPageChanged: (index) {
//                         setState(() {
//                           _selectedIndex = index;
//                         });
//                         _scrollToSelectedThumbnail(
//                             index); // Scroll to the thumbnail
//                       },
//                       itemBuilder: (context, index) {
//                         final file = context.read<ChatRoomCubit>().media[index];
//                         if (file.isImage) {
//                           return Image.file(
//                             file,
//                           );
//                         } else {
//                           return _TrimmerView(
//                               file: file, onSave: (editedVideo) {});
//                         }
//                       },
//                     ),
//                   ),
//                   // The overlay containing the top icons, ListView, and TextField
//                   Column(
//                     children: [
//                       // Top Row with icons
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10.w),
//                         child: Row(
//                           children: [
//                             _BaseIcon(
//                               icon: Icons.close,
//                               onTap: () {
//                                 context.read<ChatRoomCubit>().media.clear();
//                                 context.pop();
//                               },
//                             ),
//                             const Spacer(),
//                             _BaseIcon(
//                                 icon: Icons.plus_one_rounded, onTap: () {}),
//                             SizedBox(width: 20.h),
//                             _BaseIcon(
//                               icon: Icons.edit,
//                               onTap: () async {
//                                 Uint8List? editedImage;
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => ProImageEditor.file(
//                                     context
//                                         .read<ChatRoomCubit>()
//                                         .media[_selectedIndex],
//                                     onImageEditingComplete:
//                                         (Uint8List bytes) async {
//                                       editedImage = bytes;
//                                       context.pop();
//                                     },
//                                   ),
//                                 ).then((value) async {
//                                   if (editedImage != null) {
//                                     context
//                                             .read<ChatRoomCubit>()
//                                             .media[_selectedIndex] =
//                                         await _convertUint8ListToFile(
//                                             editedImage!);
//                                     setState(() {});
//                                   }
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       // The ListView for displaying media thumbnails
//                       SizedBox(
//                         height: 100.h,
//                         child: ListView.separated(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           scrollDirection: Axis.horizontal,
//                           controller: _scrollController,
//                           itemCount: context.read<ChatRoomCubit>().media.length,
//                           separatorBuilder: (context, index) => const Sizer(),
//                           itemBuilder: (context, index) {
//                             final file =
//                                 context.read<ChatRoomCubit>().media[index];
//                             if (file.isImage) {
//                               return _mediaContainer(
//                                   index: index, image: FileImage(file));
//                             } else {
//                               return FutureBuilder<Uint8List?>(
//                                 future: generateThumbnail(path: file.path),
//                                 builder: (context,
//                                     AsyncSnapshot<Uint8List?> snapshot) {
//                                   if (snapshot.hasData &&
//                                       snapshot.data != null &&
//                                       snapshot.data!.isNotEmpty) {
//                                     return _mediaContainer(
//                                         index: index,
//                                         image: MemoryImage(snapshot.data!),
//                                         isPhoto: false);
//                                   } else {
//                                     return Shimmer.fromColors(
//                                       baseColor: Colors.grey[300]!,
//                                       highlightColor: Colors.grey[100]!,
//                                       child: Container(
//                                         width: 50.h,
//                                         height: 100.h,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 },
//                               );
//                             }
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       // The TextField for adding captions
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: TextField(
//                           controller: context
//                               .read<ChatRoomCubit>()
//                               .messageTextController,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.grey[850],
//                             prefixIcon: IconButton(
//                               icon: const Icon(Icons.add_photo_alternate,
//                                   color: Colors.grey),
//                               onPressed: () async {
//                                 await context.read<ChatRoomCubit>().pickMedia();
//                                 setState(() {});
//                               },
//                             ),
//                             hintText: 'Add a caption ...',
//                             hintStyle: const TextStyle(color: Colors.grey),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30.0),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(height: 150.h),
//                     ],
//                   ),
//                 ],
//               ),
//               // Floating Action Button for sending message
//               floatingActionButton: FloatingActionButton(
//                 onPressed: () async {
//                   setState(() {
//                     isLoading = true;
//                   });
//                   await context.read<ChatRoomCubit>().sendMessage();
//                   await Future.delayed(const Duration(seconds: 6), () {});
//                   setState(() {
//                     isLoading = false;
//                   });
//                   context.pop();
//                 },
//                 backgroundColor: AppColors.BACKGROUND_COLOR,
//                 child: isLoading
//                     ? const CircularProgressIndicator(
//                         color: AppColors.PRIMARY_COLOR)
//                     : const Icon(Icons.send, color: AppColors.PRIMARY_COLOR),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

// //   Future<File> _convertUint8ListToFile(Uint8List uint8list) async {
// //     // Get the application's directory to store the file.
// //     final directory = await getApplicationDocumentsDirectory();

// //     // Create a unique file path
// //     String filePath =
// //         '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';

// //     // Convert the Uint8List to an image using the image package.
// //     img.Image image = img.decodeImage(uint8list)!;

// //     // Encode the image as a PNG.
// //     List<int> pngBytes = img.encodePng(image);

// //     // Create a file from the Uint8List.
// //     File imgFile = File(filePath);

// //     // Write the file
// //     await imgFile.writeAsBytes(pngBytes);

// //     return imgFile;
// //   }

//   Widget _mediaContainer(
//       {required int index, required ImageProvider image, bool isPhoto = true}) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//           _pageController.jumpToPage(index);
//         });
//       },
//       child: Container(
//         width: 150.h,
//         decoration: BoxDecoration(
//           border: _selectedIndex == index
//               ? Border.all(color: Colors.white, width: 3)
//               : null,
//           borderRadius: BorderRadius.circular(10),
//           image: DecorationImage(
//             image: image,
//             fit: BoxFit.cover,
//             colorFilter: _selectedIndex == index
//                 ? const ColorFilter.mode(Colors.black54, BlendMode.darken)
//                 : null,
//           ),
//         ),
//         child: isPhoto
//             ? index == _selectedIndex
//                 ? Center(
//                     child: IconButton(
//                       onPressed: () async {
//                         setState(() {
//                           context.read<ChatRoomCubit>().media.removeAt(index);
//                           // Adjust the selected index after deletion
//                           if (_selectedIndex > 0) {
//                             _selectedIndex--;
//                           }

//                           // If no media left, pop back to the previous screen
//                           if (context.read<ChatRoomCubit>().media.isEmpty) {
//                             context.pop();
//                             context.pop();
//                           }
//                         });
//                       },
//                       icon: const Icon(
//                         Icons.delete,
//                         color: Colors.white,
//                         size: 26,
//                       ),
//                     ),
//                   )
//                 : null
//             : Center(
//                 child: Icon(
//                   _selectedIndex == index
//                       ? Icons.delete
//                       : Icons.play_arrow_rounded,
//                   color: Colors.white,
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class _TrimmerView extends StatefulWidget {
//   final File file;
//   final void Function(File video) onSave;

//   const _TrimmerView({required this.file, required this.onSave});

//   @override
//   _TrimmerViewState createState() => _TrimmerViewState();
// }

// class _TrimmerViewState extends State<_TrimmerView> {
//   // final Trimmer _trimmer = Trimmer();

// //   double _startValue = 0.0;
// //   double _endValue = 0.0;

//   bool _isPlaying = false;
//   bool _progressVisibility = false;

//   Future<String?> _saveVideo() async {
//     setState(() {
//       _progressVisibility = true;
//     });

//     String? value;

//     // await _trimmer.saveTrimmedVideo(
//     //     startValue: _startValue,
//     //     endValue: _endValue,
//     //     onSave: (path) {
//     //       setState(() {
//     //         value = path;
//     //         _progressVisibility = false;
//     //       });
//     //     });

//     return value;
//   }

//   void _loadVideo() {
//     // _trimmer.loadVideo(videoFile: widget.file);
//   }

//   @override
//   void initState() {
//     super.initState();

//     _loadVideo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 20.h),
//       color: Colors.black,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           Visibility(
//             visible: _progressVisibility,
//             child: const LinearProgressIndicator(
//               backgroundColor: Colors.red,
//             ),
//           ),

//           Expanded(
//             child: InkWell(
//               onTap: () async {
//                 // bool playbackState = await _trimmer.videoPlaybackControl(
//                 //   startValue: _startValue,
//                 //   endValue: _endValue,
//                 // );
//                 // setState(() {
//                 //   _isPlaying = playbackState;
//                 // });
//               },
//               // child: VideoViewer(trimmer: _trimmer)
//             ),
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Expanded(
//               //   child: TrimViewer(
//               //     trimmer: _trimmer,
//               //     viewerHeight: 50.0,
//               //     // viewerWidth: MediaQuery.of(context).size.width,
//               //     onChangeStart: (value) => _startValue = value,
//               //     onChangeEnd: (value) => _endValue = value,
//               //     onChangePlaybackState: (value) =>
//               //         setState(() => _isPlaying = value),
//               //   ),
//               // ),
//               SizedBox(width: 5.h),
//               Center(child: _BaseIcon(icon: Icons.check, onTap: _saveVideo)),
//             ],
//           ),
//           // Sizer(),
//           // ElevatedAppButton(
//           //   onPressed: () async {
//           //     if (_progressVisibility) {
//           //       _saveVideo().then((outputPath) {
//           //         CliLogger.info('OUTPUT PATH: $outputPath');
//           //         if (outputPath != null) {
//           //           widget.onSave(File(outputPath));
//           //           ScaffoldMessenger.of(context).showSnackBar(
//           //             SnackBar(
//           //                 content: Text(LocaleKeys.suscessfullySaved.tr())),
//           //           );
//           //         }
//           //       });
//           //     }
//           //   },
//           //   label: LocaleKeys.save.tr(),
//           // ),
//           // TextButton(
//           //   child: _isPlaying
//           //       ? Icon(
//           //           Icons.pause,
//           //           size: 80.0,
//           //           color: Colors.white,
//           //         )
//           //       : Icon(
//           //           Icons.play_arrow,
//           //           size: 80.0,
//           //           color: Colors.white,
//           //         ),
//           //   onPressed: () async {
//           //     bool playbackState = await _trimmer.videoPlaybackControl(
//           //       startValue: _startValue,
//           //       endValue: _endValue,
//           //     );
//           //     setState(() {
//           //       _isPlaying = playbackState;
//           //     });
//           //   },
//           // )
//         ],
//       ),
//     );
//   }
// }
