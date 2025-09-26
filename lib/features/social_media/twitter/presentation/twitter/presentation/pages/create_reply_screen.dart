import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/build_sheet_item.dart';
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';

import '../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../domain/usecases/comment_reply_usecase.dart';
import '../../../bloc/twitter_bloc.dart';

class CreateReplyTwitter extends StatefulWidget {
  const CreateReplyTwitter({
    super.key,
    required this.postId,
    required this.ownerName,
    required this.ownerHandle,
    this.onReplied,
  });

  final String postId;
  final String ownerName;
  final String ownerHandle;
  final void Function(TwitterCommentReplyParams created)? onReplied;

  @override
  State<CreateReplyTwitter> createState() => _CreateReplyTwitterState();
}

class _CreateReplyTwitterState extends State<CreateReplyTwitter> {
  final TextEditingController _controller = TextEditingController();
  final SheetController _sheet = SheetController();
  final List<String> _pickedImages = []; // wire to your picker if needed
  final FocusNode _inputFocus = FocusNode(); // ⬅️ add this

  @override
  void initState() {
    super.initState();
    // Autofocus behavior is up to you
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _inputFocus.requestFocus();
      }
    });
  }
  @override
  void dispose() {
    _inputFocus.dispose();
    _controller.dispose();
    super.dispose();
  }
  Future<void> _submit() async {
    final txt = _controller.text.trim();
    if (txt.isEmpty) return;
    ManageVibration.vibrate();

    final cubit = context.read<TwitterCubit>();

    // If your API requires only (commentId, content)
    final params = TwitterCommentReplyParams(
      reply: txt,
      content: txt,
      postId: widget.postId,
      // mediaIds: uploadedMediaIds,
    );

    final ok = await cubit.onCommentReply(params: params);
    if (ok == true) {
      // optional callback
      widget.onReplied?.call(params);

      // toast
      final msg = context.isArabic ? 'تم نشر الرد' : 'Reply posted';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

      // close
      if (mounted) Navigator.pop(context, true);
    } else {
      final msg = context.isArabic ? 'فشل نشر الرد' : 'Failed to post reply';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = context.read<UserCubit>().state.data;
    final avatar = me?.profilePicture ?? '';

    final isAr = context.isArabic;
    final handleWithAt = '@${widget.ownerHandle}';
    final titleText =
        isAr ? 'ردًا على $handleWithAt' : 'Replying to $handleWithAt';
    final hintText = isAr
        ? 'اكتب ردك إلى ${widget.ownerName}'
        : 'Write your reply to ${widget.ownerName}';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          leadingWidth: 120.w,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: Padding(
            padding: EdgeInsetsDirectional.only(start: 10.w),
            child: TextButton(
              onPressed: _submit,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF1D9BF0),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
              ),
              child: Text(isAr ? 'رد' : 'Reply',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
          title: Text(
            titleText,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(bottom: 140.h),
            children: [
              // Row: avatar + multiline field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // avatar
                    ClipOval(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: ImageFromInternet(
                          image: avatar,
                          fit: BoxFit.cover,
                          isCircle: true,
                          defaultLogo: false,
                          isMale: (me?.gender ?? '').toLowerCase() != 'female',
                          firstChar: (me?.firstName ?? 'U')
                              .characters
                              .first
                              .toUpperCase(),
                          charPadding: 5,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // text field
                     Expanded( // <-- give the text area constraints inside the Row
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
 /*
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              context.isArabic
                                  ? 'ردًا على @${widget.ownerName}'
                                  : 'Replying to @${widget.ownerHandle}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ),
*/

                           ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 40, maxHeight: 140),
                            child: TextField(
                              controller: _controller,
                              focusNode: _inputFocus,   // ⬅️ attach focus node
                              autofocus: true,          // ⬅️ ask for focus immediately
                              maxLines: 5,
                              cursorColor: Theme.of(context).colorScheme.primary,
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                              decoration: const InputDecoration(
                                hintText: '',
                                isCollapsed: true,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                filled: false,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (_) {
                                if (_controller.text.isNotEmpty) {
                                  _sheet.collapse();
                                }
                                setState(() {});
                              },
                            ),
                          ),

                          // Optional inline hint when empty
                          if (_controller.text.trim().isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                context.isArabic
                                    ? 'اكتب ردك إلى ${widget.ownerName}'
                                    : 'Write your reply to ${widget.ownerName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withOpacity(0.45),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              ],
          ),

          // Action sheet (attachments) like your create screen
          IgnorePointer(
            ignoring: (_sheet.state?.currentScrollOffset ?? 0) > 0,
            child: SnappingBottomSheet(
              controller: _sheet,
              duration: const Duration(milliseconds: 400),
              color: context.isDarkMode
                  ? AppColors.getFillColor(context)
                  : Colors.white,
              shadowColor: Colors.black26,
              elevation: 0,
              maxWidth: MediaQuery.of(context).size.width,
              cornerRadius: 0,
              closeOnBackdropTap: true,
              padding: EdgeInsets.zero,
              snapSpec: const SnapSpec(
                snap: true,
                initialSnap: 0.5,
                snappings: [0.1, 0.4, 0.8],
                positioning: SnapPositioning.relativeToAvailableSpace,
              ),
              body: Container(),
              builder: (context, state1) => Column(
                children: [
                  SizedBox(height: 10.h),
                  const Divider(height: 1),
                  BuildSheetItem(
                    icon: Assets.imageIcon,
                    title: isAr ? 'صورة/فيديو' : 'Photo/Video',
                    onTap: () async {
                      ManageVibration.vibrate();
                      // TODO: pick images, upload, push into _pickedImages
                      _sheet.collapse();
                    },
                    hasDivider: true,
                  ),
                  BuildSheetItem(
                    icon: Assets.cameraIcon,
                    title: isAr ? 'كاميرا' : 'Camera',
                    onTap: () async {
                      ManageVibration.vibrate();
                      // TODO: open camera
                      _sheet.collapse();
                    },
                    hasDivider: true,
                  ),
                  BuildSheetItem(
                    icon: Assets.gifIcon,
                    title: isAr ? 'صورة متحركة' : 'GIF',
                    onTap: () async {
                      ManageVibration.vibrate();
                      // TODO: open GIF picker and attach
                      _sheet.collapse();
                    },
                    hasDivider: false,
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
