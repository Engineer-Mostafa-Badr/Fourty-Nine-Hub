import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/features/tube/presentation/cubit/tube_cubit.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/functions/global/upload_file.dart';
import '../../../../core/constants/constants.dart';
import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../widgets/video_card_widget.dart';

class MyVideosTubeScreen extends StatefulWidget {
  const MyVideosTubeScreen({super.key});
  @override
  State<MyVideosTubeScreen> createState() => _MyVideosTubeScreenState();
}

class _MyVideosTubeScreenState extends State<MyVideosTubeScreen> {
  late final ScrollController _scrollController;
  late final TubeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<TubeCubit>();
    _scrollController = ScrollController();
    _cubit.loadInitialMyTubeVideos();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _cubit.getMyTubeVideos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showEditDialog(GetAllTubeVideosEntity video) {
    final cubit = context.read<TubeCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditVideoBottomSheet(video: video, cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TubeCubit, TubeState>(
      listener: (context, state) async {
        // if (state.showSnackbar && state.uploadStatus == StateStatus.success) {
        //   ScaffoldMessenger.of(context)
        //     ..hideCurrentSnackBar()
        //     ..showSnackBar(
        //       const SnackBar(
        //         content: Text('Video updated!'),
        //         backgroundColor: Colors.green,
        //         duration: Duration(seconds: 2),
        //       ),
        //     );
        // } else if (state.uploadStatus == StateStatus.error) {
        //   ScaffoldMessenger.of(context)
        //     ..hideCurrentSnackBar()
        //     ..showSnackBar(
        //       const SnackBar(
        //         content: Text('Update failed'),
        //         backgroundColor: Colors.red,
        //       ),
        //     );
        // }
      },

      builder: (context, state) {
        final videos = state.getMyTubeVideosData ?? [];

        return Container(
          color: Colors.black,
          child: RefreshIndicator(
            onRefresh: _cubit.loadInitialMyTubeVideos,
            child: ListView.builder(
              itemCount: videos.length + (_cubit.hasMoreMyTubeVideos ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= videos.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                        child: CircularProgressIndicator(color: Colors.red)),
                  );
                }
                return VideoCardTube(
                  video: videos[index],
                  videoList: videos,
                  isMyVideo: true,
                  onEditPressed: () => _showEditDialog(videos[index]),
                  onDeletePressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: const Color(0xFF1A1A1A),
                        title: const Text('Delete video?',
                            style: TextStyle(color: Colors.white)),
                        content: const Text(
                          'This action cannot be undone.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.white70)),
                            onPressed: () => Navigator.pop(ctx, false),
                          ),
                          TextButton(
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.red)),
                            onPressed: () => Navigator.pop(ctx, true),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await _cubit.deleteTubeVideo(videos[index].id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Video deleted successfully'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        );
      },
      // builder: (context, state) {
      //   // FIXED: Use state.getAllTubeVideosData instead of cubit.myTubeVideos
      //   final videos = state.getMyTubeVideosData ?? _cubit.myTubeVideos;
      //
      //   return Container(
      //     color: Colors.black,
      //     child: RefreshIndicator(
      //       color: Colors.red,
      //       backgroundColor: const Color(0xFF0F0F0F),
      //       onRefresh: _cubit.loadInitialMyTubeVideos,
      //       child: ListView.builder(
      //         controller: _scrollController,
      //         padding: EdgeInsets.zero,
      //         itemCount: videos.length + (_cubit.hasMoreMyTubeVideos ? 1 : 0),
      //         itemBuilder: (context, index) {
      //           if (index >= videos.length) {
      //             return const Padding(
      //               padding: EdgeInsets.symmetric(vertical: 24),
      //               child: Center(
      //                 child: CircularProgressIndicator(color: Colors.red),
      //               ),
      //             );
      //           }
      //           final video = videos[index];
      //           return VideoCardTube(
      //             video: video,
      //             videoList: _cubit.myTubeVideos,
      //             isMyVideo: true,
      //             onEditPressed: () => _showEditDialog(video),
      //             onDeletePressed: () async {
      //               final confirm = await showDialog<bool>(
      //                 context: context,
      //                 builder: (ctx) => AlertDialog(
      //                   backgroundColor: const Color(0xFF1A1A1A),
      //                   title: const Text('Delete video?', style: TextStyle(color: Colors.white)),
      //                   content: const Text(
      //                     'This action cannot be undone.',
      //                     style: TextStyle(color: Colors.white70),
      //                   ),
      //                   actions: [
      //                     TextButton(
      //                       child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
      //                       onPressed: () => Navigator.pop(ctx, false),
      //                     ),
      //                     TextButton(
      //                       child: const Text('Delete', style: TextStyle(color: Colors.red)),
      //                       onPressed: () => Navigator.pop(ctx, true),
      //                     ),
      //                   ],
      //                 ),
      //               );
      //               if (confirm == true) {
      //                 await _cubit.deleteTubeVideo(video.id!);
      //                 ScaffoldMessenger.of(context).showSnackBar(
      //                   const SnackBar(
      //                     content: Text('Video deleted successfully'),
      //                     backgroundColor: Colors.red,
      //                     duration: Duration(seconds: 2),
      //                   ),
      //                 );
      //               }
      //             },
      //           );
      //         },
      //       ),
      //     ),
      //   );
      // },
    );
  }
}

class EditVideoBottomSheet extends StatefulWidget {
  final GetAllTubeVideosEntity video;
  final TubeCubit cubit;
  const EditVideoBottomSheet({
    required this.video,
    required this.cubit,
    super.key,
  });

  @override
  State<EditVideoBottomSheet> createState() => _EditVideoBottomSheetState();
}

class _EditVideoBottomSheetState extends State<EditVideoBottomSheet>
    with SingleTickerProviderStateMixin {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  XFile? _pickedThumbnail;
  String? _uploadedMediaId;
  bool _uploadingThumbnail = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.video.title ?? '');
    _descCtrl = TextEditingController(text: widget.video.description ?? '');

    // Reset upload state
    _pickedThumbnail = null;
    _uploadedMediaId = null;

    // If video has a local thumbnail (from previous optimistic update), show it
    if (widget.video.localThumbnailPath != null &&
        File(widget.video.localThumbnailPath!).existsSync()) {
      _pickedThumbnail = XFile(widget.video.localThumbnailPath!);
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadThumbnail() async {
    setState(() {
      _uploadingThumbnail = true;
      _uploadedMediaId = null;
      _pickedThumbnail = null;
    });

    try {
      await UploadFile().uploadImage(
        context: context,
        subCategoryId: Constants.tubeSubCategory ?? '65a9c19f8c451e01ef7e17ac',
        hasLoading: false,
        onUploaded: (fileEntity) {
          setState(() {
            _uploadedMediaId = fileEntity.mediaId;
            _pickedThumbnail = fileEntity.file;
            _uploadingThumbnail = false;
          });
          debugPrint('Thumbnail uploaded - MediaId: ${fileEntity.mediaId}');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text('Thumbnail uploaded successfully!'),
                  ],
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      );

      if (_uploadedMediaId == null && mounted) {
        setState(() => _uploadingThumbnail = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text('Upload failed - no mediaId returned'),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _uploadingThumbnail = false);
      debugPrint('Upload error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text('Upload error: $e')),
              ],
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _save() async {
    debugPrint('Current _uploadedMediaId value: $_uploadedMediaId');
    debugPrint('Original thumbnail URL: ${widget.video.thumbnail}');

    final hasChanges =
        _titleCtrl.text.trim() != (widget.video.title ?? '').trim() ||
            _descCtrl.text.trim() != (widget.video.description ?? '').trim() ||
            _uploadedMediaId != null;

    if (!hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text('No changes to save'),
            ],
          ),
          backgroundColor: const Color(0xFFF59E0B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    widget.cubit.updateTubeVideo(
      videoId: widget.video.id!,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      thumbnailMediaId: _uploadedMediaId,
      localThumbnailPath: _pickedThumbnail?.path,
    );

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;

    // Determine current image source
    DecorationImage? thumbnailImage;
    if (_pickedThumbnail != null) {
      thumbnailImage = DecorationImage(
        image: FileImage(File(_pickedThumbnail!.path)),
        fit: BoxFit.cover,
      );
    } else if (video.localThumbnailPath != null &&
        File(video.localThumbnailPath!).existsSync()) {
      thumbnailImage = DecorationImage(
        image: FileImage(File(video.localThumbnailPath!)),
        fit: BoxFit.cover,
      );
    } else if (video.thumbnail != null && video.thumbnail!.isNotEmpty) {
      thumbnailImage = DecorationImage(
        image: NetworkImage(video.thumbnail!),
        fit: BoxFit.cover,
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Video',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          // letterLetterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Update your video details',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail Section
                      const Text(
                        'Thumbnail',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: _uploadingThumbnail
                            ? null
                            : _pickAndUploadThumbnail,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFF242424),
                            border: Border.all(
                              color: _uploadingThumbnail
                                  ? Colors.red.withOpacity(0.5)
                                  : Colors.white10,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            image: thumbnailImage,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                // Gradient overlay
                                if (thumbnailImage != null)
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Uploading overlay
                                if (_uploadingThumbnail)
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        SizedBox(
                                          width: 48,
                                          height: 48,
                                          child: CircularProgressIndicator(
                                            color: Colors.red,
                                            strokeWidth: 3,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Uploading to S3...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Please wait',
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Empty thumbnail prompt
                                if (!_uploadingThumbnail &&
                                    thumbnailImage == null)
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.add_photo_alternate_rounded,
                                            color: Colors.white70,
                                            size: 36,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Tap to upload thumbnail',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Recommended: 1280×720',
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // “Change” button
                                if (!_uploadingThumbnail &&
                                    thumbnailImage != null)
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.white24,
                                          width: 1,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.edit_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            'Change',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Upload status indicator
                      if (_uploadedMediaId != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF10B981).withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF10B981),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Thumbnail ready',
                                        style: TextStyle(
                                          color: Color(0xFF10B981),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'ID: $_uploadedMediaId',
                                        style: TextStyle(
                                          color: const Color(0xFF10B981)
                                              .withOpacity(0.8),
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Title field
                      const Text(
                        'Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10, width: 1.5),
                        ),
                        child: FormTextField(
                          controller: _titleCtrl,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          hint: 'Enter video title',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description field
                      const Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10, width: 1.5),
                        ),
                        child: FormTextField(
                          controller: _descCtrl,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          maxLines: 5,
                          hint: 'Describe your video...',
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: _isSaving
                                  ? null
                                  : () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: (_uploadingThumbnail || _isSaving)
                                  ? null
                                  : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                disabledBackgroundColor: Colors.grey.shade800,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      _uploadingThumbnail
                                          ? 'Uploading...'
                                          : 'Save Changes',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
class EditVideoBottomSheet extends StatefulWidget {
  final GetAllTubeVideosEntity video;
  final TubeCubit cubit;
  const EditVideoBottomSheet({
    required this.video,
    required this.cubit,
    super.key,
  });

  @override
  State<EditVideoBottomSheet> createState() => _EditVideoBottomSheetState();
}

class _EditVideoBottomSheetState extends State<EditVideoBottomSheet> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  XFile? _pickedThumbnail;
  String? _uploadedMediaId; // Store ONLY the mediaId (not URL)
  bool _uploadingThumbnail = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.video.title ?? '');
    _descCtrl = TextEditingController(text: widget.video.description ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // Upload to S3 immediately when image is picked
  Future<void> _pickAndUploadThumbnail() async {
    setState(() {
      _uploadingThumbnail = true;
      _uploadedMediaId = null;
      _pickedThumbnail = null;
    });

    try {
      await UploadFile().uploadImage(
        context: context,
        subCategoryId: Constants.tubeSubCategory ?? '65a9c19f8c451e01ef7e17ac',
        hasLoading: false, // Don't show the default loading dialog
        onUploaded: (fileEntity) {
          // Update state IMMEDIATELY when callback is triggered
          setState(() {
            _uploadedMediaId = fileEntity.mediaId;
            _pickedThumbnail = fileEntity.file;
            _uploadingThumbnail = false;
          });
          debugPrint('✅ Thumbnail uploaded - MediaId: ${fileEntity.mediaId}');
          debugPrint('✅ State updated - _uploadedMediaId: $_uploadedMediaId');
        },
      );

      // Show success message if we have a mediaId
      if (_uploadedMediaId != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thumbnail uploaded! ID: $_uploadedMediaId'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() => _uploadingThumbnail = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Upload failed - no mediaId returned'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _uploadingThumbnail = false);
      debugPrint('❌ Upload error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _save() {
    debugPrint('💾 Current _uploadedMediaId value: $_uploadedMediaId');
    debugPrint('💾 Original thumbnail URL: ${widget.video.thumbnail}');

    final hasChanges = _titleCtrl.text.trim() != (widget.video.title ?? '').trim() ||
        _descCtrl.text.trim() != (widget.video.description ?? '').trim() ||
        _uploadedMediaId != null;

    if (!hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes to save.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    widget.cubit.updateTubeVideo(
      videoId: widget.video.id!,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      thumbnailMediaId: _uploadedMediaId, // only send if updated
    );
  }



  @override
  Widget build(BuildContext context) {
    final video = widget.video;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thumbnail picker - uploads to S3 when clicked
            GestureDetector(
              onTap: _uploadingThumbnail ? null : _pickAndUploadThumbnail,
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF272727),
                  image: _pickedThumbnail != null
                      ? DecorationImage(
                    image: FileImage(File(_pickedThumbnail!.path)),
                    fit: BoxFit.cover,
                  )
                      : (video.thumbnail != null
                      ? DecorationImage(
                    image: NetworkImage(video.thumbnail!),
                    fit: BoxFit.cover,
                  )
                      : null),
                ),
                alignment: Alignment.center,
                child: _uploadingThumbnail
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(color: Colors.red),
                    SizedBox(height: 8),
                    Text(
                      'Uploading to S3...',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                )
                    : (_pickedThumbnail == null && video.thumbnail == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_a_photo,
                        color: Colors.white70, size: 36),
                    SizedBox(height: 8),
                    Text(
                      'Tap to upload thumbnail',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),
                  ],
                )
                    : null),
              ),
            ),

            // Upload status indicator
            if (_uploadedMediaId != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Ready - ID: $_uploadedMediaId',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Title field with container background
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF272727),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _titleCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Description field with container background
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF272727),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _descCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  // Save button disabled only while uploading
                  onPressed: _uploadingThumbnail ? null : _save,
                  child: Text(_uploadingThumbnail ? 'Uploading...' : 'Save'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
*/
