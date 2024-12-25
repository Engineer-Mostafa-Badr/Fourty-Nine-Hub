import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/pages/select_activity_view.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_search_friends.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/show_all_images.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import '../../../../../common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import '../../../../account_taps/privacy/domain/entities/privacy_status_enum.dart';
import '../cubit/create_post_cubit.dart';
import 'select_feeling_view.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key, required this.social});
  final String social;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  // String? _filePath;
  // TextEditingController _startController = TextEditingController();
  // TextEditingController _endController = TextEditingController();
  //
  // Future<void> pickAudioFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.audio,
  //   );
  //
  //   if (result != null && result.files.isNotEmpty) {
  //     setState(() {
  //       _filePath = result.files.single.path;
  //     });
  //   } else {
  //     // Handle case when the user cancels file picking.
  //     print("No file selected.");
  //   }
  // }

  // Future<void> extractAudioSegment(String inputFilePath, String outputFilePath, int startSecond, int endSecond) async {
  //   final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  //
  //   // Construct the FFmpeg command to extract the audio segment.
  //   String command = '-i $inputFilePath -ss $startSecond -to $endSecond -c copy $outputFilePath';
  //
  //   // Execute the command.
  //   await _flutterFFmpeg.execute(command);
  // }

  // Future<void> uploadAudio(String filePath, String uploadUrl) async {
  //   FormData formData = FormData.fromMap({
  //     'file': await MultipartFile.fromFile(filePath, filename: 'audio_segment.mp3'),
  //   });
  //
  //
  //   try {
  //     Response response = await Dio().post(uploadUrl, data: formData);
  //     print('Upload response: ${response.data}');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Upload successful!')),
  //     );
  //   } catch (e) {
  //     print('Upload failed: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Upload failed!')),
  //     );
  //   }
  // }
  //
  // void _handleUpload() async {
  //   if (_filePath == null) {
  //     print("No file selected.");
  //     return;
  //   }
  //
  //   try {
  //     int startSecond = int.parse(_startController.text);
  //     int endSecond = int.parse(_endController.text);
  //
  //     if (startSecond < 0 || endSecond <= startSecond) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Invalid start or end time!')),
  //       );
  //       return;
  //     }
  //
  //     String outputFilePath = '/path/to/output/audio_segment.mp3';
  //  //   await extractAudioSegment(_filePath!, outputFilePath, startSecond, endSecond);
  //
  //     // Replace with your upload URL
  //     await uploadAudio(outputFilePath, 'https://your-api-endpoint.com/upload');
  //   } catch (e) {
  //     print('Error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error processing audio!')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreatePostCubit>();
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state.status == CreatePostStates.error) {}
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar:
                  BackAppBar(label: LocaleKeys.createPost.localize, actions: [
                TextButton(
                    child: Label(text: LocaleKeys.post.localize),
                    onPressed: () => controller.createPost(
                        context: context, type: widget.social)),
              ]),
              body: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          final res = await CustomVerticalSheetItem.normal<
                              PrivacyStatus>(context, [
                            CustomSheetModel(
                              text: LocaleKeys.public.localize,
                              value: PrivacyStatus.public,
                              iconData: Icons.language,
                            ),
                            CustomSheetModel(
                              text: LocaleKeys.friends.localize,
                              value: PrivacyStatus.friends,
                              iconData: Icons.family_restroom,
                            ),
                            CustomSheetModel(
                              text: LocaleKeys.followers.localize,
                              value: PrivacyStatus.followers,
                              iconData: Icons.accessibility_sharp,
                            ),
                            CustomSheetModel(
                              text: LocaleKeys.friendsAndFollowers.localize,
                              value: PrivacyStatus.friendsAndFollowers,
                              iconData: Icons.supervised_user_circle_outlined,
                            ),
                            CustomSheetModel(
                              text: LocaleKeys.onlyMe.localize,
                              value: PrivacyStatus.onlyMe,
                              iconData: Icons.lock,
                            ),
                          ]);
                          print(res?.name);
                          print("============>");
                          controller.selectPrivacy(
                              privacy: res?.name ?? 'public');
                        },
                        child: Container(
                          margin: const EdgeInsetsDirectional.only(start: 10),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                state.selectedPrivacy == 'onlyMe'
                                    ? Icons.lock
                                    : state.selectedPrivacy == 'friends'
                                        ? Icons.family_restroom
                                        : state.selectedPrivacy == 'followers'
                                            ? Icons.accessibility_sharp
                                            : state.selectedPrivacy ==
                                                    'friendsAndFollowers'
                                                ? Icons
                                                    .supervised_user_circle_outlined
                                                : Icons.language,
                                size: 16,
                              ),
                              const Sizer(),
                              Text(
                                state.selectedPrivacy == 'onlyMe'
                                    ? LocaleKeys.onlyMe.localize
                                    : state.selectedPrivacy == 'friends'
                                        ? LocaleKeys.friends.localize
                                        : state.selectedPrivacy == 'followers'
                                            ? LocaleKeys.followers.localize
                                            : state.selectedPrivacy ==
                                                    'friendsAndFollowers'
                                                ? LocaleKeys.friendsAndFollowers
                                                    .localize
                                                : LocaleKeys.public.localize,
                                style: Styles.mediumText(
                                  color: AppColors.AUTH_CONTAINER_COLOR,
                                ),
                              ),
                              const Sizer(),
                              Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 30.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.social != 'twitter')
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Row(
                        children: [
                          if (state.selectedFeeling != null &&
                              state.selectedFeeling!.name.isNotEmpty)
                            Container(
                              margin:
                                  const EdgeInsetsDirectional.only(start: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.onRemoveFeeling();
                                    },
                                    child: const Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w),
                                        child: Row(
                                          children: [
                                            Text(
                                                '${LocaleKeys.feeling.localize} ',
                                                style: Styles.mediumText(
                                                  color: AppColors
                                                      .AUTH_CONTAINER_COLOR,
                                                )),
                                            Text(state.selectedFeeling!.name,
                                                style: Styles.mediumText(
                                                  color: AppColors
                                                      .AUTH_CONTAINER_COLOR,
                                                )),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          //Sizer(width: 10.w,),
                          if (state.selectedActivity != null &&
                              state.selectedActivity!.name.isNotEmpty)
                            Container(
                              margin:
                                  const EdgeInsetsDirectional.only(start: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.onRemoveActivity();
                                    },
                                    child: const Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          state.selectedActivity!.name,
                                          style: Styles.mediumText(),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (state.selectedUsers != null &&
                      state.selectedUsers!.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Label(
                        text: '${LocaleKeys.withKey.localize}: ',
                        style: Styles.headerText(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // Enable horizontal scrolling
                        child: Row(
                          children: [
                            Wrap(
                              direction: Axis.horizontal,
                              runSpacing: 10,
                              spacing: 10,
                              children: List.generate(
                                state.selectedUsers!.length,
                                (index) => GestureDetector(
                                  onTap: () {},
                                  child: BadgedLabel(
                                    label:
                                        state.selectedUsers?[index].fullName ??
                                            '',
                                    onRemove: () {
                                      controller.onRemoveUser(
                                          state.selectedUsers![index]);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const Sizer(),
                  _buildCreatePost(onChange: (c) {
                    if (c.length > 80 &&
                        c.length < 120 &&
                        state.backColor != '#FFFFFFFF') {
                      controller.onBigger80();
                    } else if (c.length > 120 &&
                        c.length < 150 &&
                        state.backColor != '#FFFFFFFF') {
                      controller.onBigger120();
                    } else if (c.length > 150) {
                      controller.onBigger150();
                    } else {
                      controller.onSmallerText();
                    }
                    return controller.removeBackground();
                  }),
                  const Sizer(),
                  if (widget.social != 'twitter' &&
                      (state.images == null || state.images!.isEmpty) &&
                      state.isBiggerThen150 == false)
                    _buildColorsBallet(context: context),
                  const Sizer(),
                  if (state.images != null && state.images!.isNotEmpty)
                    Expanded(child: _buildMediaCard()),
                  const Sizer(),
                  _buildOptions(controller),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCreatePost({required Function(String) onChange}) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
      return Container(
          height:
              (state.backColor == '#FFFFFFFF' && state.isBiggerThen150 == false)
                  ? null
                  : (state.isBiggerThen150 == true)
                      ? 300
                      : 250,
          alignment: state.isBiggerThen150 == false
              ? AlignmentDirectional.topStart
              : Alignment.center,
          color: ((state.isBiggerThen150 == true &&
                  state.isBiggerThan80 == false &&
                  state.isBiggerThen120 == false))
              ? Colors.white
              : Color(int.parse(state.backColor!.substring(1), radix: 16)),
          child: Align(
            child: TextField(
              // focusNode: focusNode,
              maxLines: null,
              expands: (state.backColor == '#FFFFFFFF') ? false : true,
              textAlign: (state.backColor == '#FFFFFFFF' ||
                      state.isBiggerThen150 == true)
                  ? TextAlign.start
                  : TextAlign.center,
              style: TextStyle(
                  color: (state.backColor != '#FFFFFFFF' &&
                          state.isBiggerThen150 == false)
                      ? Colors.white
                      : AppColors.QUANTITY_COLOR,
                  fontSize: (state.isBiggerThen120 == true &&
                          state.isBiggerThan80 == false)
                      ? 25.sp
                      : (state.isBiggerThen120 == false &&
                              state.isBiggerThan80 == true)
                          ? 25.sp
                          : 30.sp,
                  fontWeight: (state.backColor == '#FFFFFFFF' ||
                          state.isBiggerThen150 == true)
                      ? FontWeight.w400
                      : FontWeight.bold),
              onChanged: (c) => onChange(c),
              controller:
                  context.read<CreatePostCubit>().postContentTextController,
              decoration: InputDecoration(
                hintText: '${LocaleKeys.typeHere.localize} ... ',
                hintStyle: Styles.mediumText(color: AppColors.QUANTITY_COLOR),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                fillColor: ((state.isBiggerThen150 == true &&
                        state.isBiggerThan80 == false &&
                        state.isBiggerThen120 == false))
                    ? Colors.white
                    : Color(
                        int.parse(state.backColor!.substring(1), radix: 16)),
                border: (state.backColor == '#FFFFFFFF' ||
                        state.isBiggerThen150 == true)
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 100),
                        borderRadius: BorderRadius.circular(0),
                      ),
              ),
            ),
          ));
    });
  }

  Widget _buildMediaCard() {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        final createPostCubit = context.read<CreatePostCubit>();
        return Column(
          children: [
            // Existing Image Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: state.images!.length == 1 ? 1 : 2,
                childAspectRatio: 1 / 2,
              ),
              itemCount: state.images!.length < 4 ? state.images!.length : 4,
              itemBuilder: (context, index) => InkWell(
                // Handle image interactions
                onTap: () {
                  if (index != 3 || (index == 3 && state.images!.length == 4)) {
                    showDialog(
                      context: context,
                      builder: (context) => ImageDetailsScreen(
                        image: state.images![index].file.path,
                        isFile: true,
                        onRemoveImage: () {
                          createPostCubit.removePhoto(state.images![index]);
                          context.pop();
                        },
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => ShowAllImages(
                        images: state.images!,
                        onRemoveImage: (UploadFileEntity image) {
                          createPostCubit.removePhoto(image);
                        },
                      ),
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
                              image: FileImage(
                                File(state.images?[index].file.path ?? ''),
                              ),
                            ),
                          ),
                        ),
                        if (index == 3 && state.images!.length > 4)
                          Container(
                            margin: const EdgeInsetsDirectional.only(
                                end: 10, bottom: 10),
                            // padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Center(
                              child: Label(
                                text: "+${state.images!.length - 4}",
                                style: Styles.headerText(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (index == 0 && state.images!.length == 1)
                      PositionedDirectional(
                        end: 15,
                        top: 5,
                        child: InkWell(
                          onTap: () {
                            context
                                .read<CreatePostCubit>()
                                .removePhoto(state.images?[index]);
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: pickAudioFile,
            //   child: Text('Pick Audio File'),
            // ),
            // SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: _handleUpload,
            //   child: Text('Upload Audio Segment'),
            // ),
            // ElevatedButton(
            //   onPressed: _pickAudioFile,
            //   child: Text('Pick Audio File'),
            // ),
            // // Music Selection UI
            // if (_audioFile != null)
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Text('Audio File Picked: ${_audioFile!.path}'),
            //   ),
            // Container(
            //   height: 150,
            //   width: 150,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     image: DecorationImage(
            //       image: AssetImage(Assets.image), // Replace with your image
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20),
            // // Audio title
            // Text(
            //   '(feat. Onuy) - KEBDA',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(height: 10),
            // // Artist name
            // Text(
            //   'Afroto',
            //   style: TextStyle(fontSize: 16, color: Colors.grey),
            // ),
            // SizedBox(height: 20),
            // // Audio progress bar
            // Slider(
            //   value: _audioPlayer.position.inSeconds.toDouble(),
            //   max: _audioPlayer.duration?.inSeconds.toDouble() ?? 1,
            //   onChanged: (value) {
            //     _audioPlayer.seek(Duration(seconds: value.toInt()));
            //   },
            // ),
            // // Play/Pause button
            // IconButton(
            //   icon: Icon(
            //     _isPlaying ? Icons.pause : Icons.play_arrow,
            //     size: 40,
            //   ),
            //   onPressed: () async {
            //     if (_isPlaying) {
            //       await _audioPlayer.pause();
            //     } else {
            //       await _audioPlayer.play();
            //     }
            //     setState(() {
            //       _isPlaying = !_isPlaying;
            //     });
            //     _pickAudioFile();
            //   },
            // ),
            // SizedBox(height: 20),
            // // Placeholder for waveform (to be implemented)
            // Container(
            //   height: 50,
            //   color: Colors.grey[300],
            //   child: Center(
            //     child: Text(
            //       'Waveform placeholder',
            //       style: TextStyle(color: Colors.grey),
            //     ),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     IconButton(
            //       icon: const Icon(Icons.music_note, color: Colors.blue),
            //       onPressed: () async {
            //         final result = await FilePicker.platform.pickFiles(
            //           type: FileType.audio,
            //         );
            //         if (result != null && result.files.isNotEmpty) {
            //           final selectedMusic = result.files.single.path!;
            //           audioCubit.addMusic(selectedMusic);
            //         }
            //       },
            //     ),
            //     if (state.music != null)
            //       Expanded(
            //         child: Text(
            //           'Selected Music: ${state.music}',
            //           overflow: TextOverflow.ellipsis,
            //           style: const TextStyle(color: Colors.black),
            //         ),
            //       ),
            //     if (state.music != null)
            //       IconButton(
            //         icon: const Icon(Icons.close, color: Colors.red),
            //         onPressed: () => audioCubit.removeMusic(),
            //       ),
            //   ],
            // ),
            // // Music Playback Controls
            // if (state.music != null)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       IconButton(
            //         icon: const Icon(Icons.play_arrow, color: Colors.green),
            //         onPressed: () => audioCubit.playMusic(),
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.pause, color: Colors.orange),
            //         onPressed: () => audioCubit.pauseMusic(),
            //       ),
            //     ],
            //   ),
          ],
        );
      },
    );
  }

  Widget _buildColorsBallet({required BuildContext context}) {
    final List<String> colors = [
      "#FFFFFFFF", // Colors.white
      "#FFFFA500", // Colors.orange
      "#FF0000FF", // Colors.blue
      "#FFFF0000", // Colors.red
      "#FF008000", // Colors.green
      "#FFDA70D6", // Colors.purpleAccent
      "#FFFFC0CB", // Colors.pink
      "#FFFFFF00", // Colors.yellow
      "#FFFF5252", // Colors.redAccent
      "#FF90EE90", // Colors.lightGreen
      "#FF64FFDA" // Colors.tealAccent
    ];
    final controller = context.read<CreatePostCubit>();
    return SizedBox(
      height: 30.h,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => controller.selectColor(color: colors[index]),
              child: Container(
                height: 30.h,
                width: 30,
                decoration: BoxDecoration(
                    color:
                        Color(int.parse(colors[index].substring(1), radix: 16)),
                    border: Border.all(color: Colors.grey, width: .5),
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: colors.length),
    );
  }

  Widget _buildOptions(CreatePostCubit controller) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(start: 8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async => await controller.uploadPhoto(),
                child: Row(
                  children: [
                    const Icon(
                      Icons.image,
                      color: Colors.green,
                      size: 30,
                    ),
                    const Sizer(),
                    Text(
                      LocaleKeys.photo.localize,
                      style: Styles.mediumText(
                          fontSize: 34, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              if (widget.social != 'twitter') ...[
                const Divider(),
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    bottomSheet(
                        isScrollControlled: true,
                        context: context,
                        widget: SelectActivity(
                          activities: state.activities ?? [],
                          onSelected: (ActivityEntity item) => context
                              .read<CreatePostCubit>()
                              .selectActivity(item: item),
                        ));
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_activity,
                        color: Colors.blue,
                        size: 30,
                      ),
                      const Sizer(),
                      Text(
                        LocaleKeys.activity.localize,
                        style: Styles.mediumText(
                            fontSize: 34, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
              if (widget.social != 'twitter') ...[
                const Divider(),
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    bottomSheet(
                        isScrollControlled: true,
                        context: context,
                        widget: SelectFeelingView(
                          feelings: state.feelings ?? [],
                          onSelected: (FeelingEntity item) => context
                              .read<CreatePostCubit>()
                              .selectedFeeling(item: item),
                        ));
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.orangeAccent,
                        size: 30,
                      ),
                      const Sizer(),
                      Text(
                        LocaleKeys.feeling.localize,
                        style: Styles.mediumText(
                            fontSize: 65.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
              if (widget.social != 'twitter') ...[
                const Divider(),
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => BuildSearchFriends(
                              onSelectUser: (PostUserEntity user) {
                                controller.selectUsers(user);
                                // context.pop(true);
                              },
                              controller: controller,
                            ));
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people,
                        color: Colors.grey,
                        size: 30,
                      ),
                      const Sizer(),
                      Text(
                        LocaleKeys.tagPeople.localize,
                        style: Styles.mediumText(
                            fontSize: 34, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            ]),
      );
    });
  }
}
