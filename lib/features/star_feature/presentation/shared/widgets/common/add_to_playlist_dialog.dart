import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../presentation_exports.dart';


class AddToPlaylistDialog extends StatefulWidget {
  final String videoId;

  const AddToPlaylistDialog({
    super.key,
    required this.videoId,
  });

  @override
  State<AddToPlaylistDialog> createState() => _AddToPlaylistDialogState();
}

class _AddToPlaylistDialogState extends State<AddToPlaylistDialog> {
  Set<String> addingToPlaylists = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Text(
                  context.isArabic
                      ? 'إضافة إلى قائمة التشغيل'
                      : 'Add to playlist',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Create new playlist button
          Container(
            margin: EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _showCreatePlaylistDialog(),
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                context.isArabic
                    ? 'إنشاء قائمة تشغيل جديدة'
                    : 'Create new playlist',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),

          // Playlists list
          Expanded(
            child: BlocBuilder<PlaylistCubit, PlaylistState>(
              builder: (context, state) {
                if (state.isLoading && !state.hasPlaylists) {
                  return Center(
                    child: StarLoadingIndicator(
                      message: context.isArabic
                          ? 'جاري تحميل قوائم التشغيل...'
                          : 'Loading playlists...',
                    ),
                  );
                }

                if (state.isError && !state.hasPlaylists) {
                  return Center(
                    child: StarErrorWidget(
                      message: state.failure?.toString() ??
                          (context.isArabic
                              ? 'خطأ في تحميل قوائم التشغيل'
                              : 'Failed to load playlists'),
                      onRetry: () => context
                          .read<PlaylistCubit>()
                          .getMyPlaylists(refresh: true),
                    ),
                  );
                }

                if (!state.hasPlaylists) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.playlist_add,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          context.isArabic
                              ? 'لا توجد قوائم تشغيل'
                              : 'No playlists yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          context.isArabic
                              ? 'أنشئ قائمة تشغيل لحفظ الفيديوهات'
                              : 'Create a playlist to save videos',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = state.playlists[index];
                    final isAdding = addingToPlaylists.contains(playlist.id);

                    return _buildPlaylistItem(playlist, isAdding);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistItem(PlaylistEntity playlist, bool isAdding) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 60,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: playlist.thumbnail.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    playlist.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.playlist_play,
                        color: Colors.grey[600],
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.playlist_play,
                  color: Colors.grey[600],
                ),
        ),
        title: Text(
          playlist.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          context.isArabic
              ? '${playlist.videosCount.toString().toArabicNumbers(context)} فيديو • ${timeago.format(playlist.createdAt, locale: context.locale.languageCode).toArabicNumbers(context)}'
              : '${playlist.videosCount} videos • ${timeago.format(playlist.createdAt, locale: context.locale.languageCode)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        trailing: isAdding
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.add_circle_outline,
                color: Colors.grey[600],
              ),
        onTap: isAdding ? null : () => _addToPlaylist(playlist),
      ),
    );
  }

  void _addToPlaylist(PlaylistEntity playlist) async {
    setState(() {
      addingToPlaylists.add(playlist.id);
    });

    final playlistCubit = context.read<PlaylistCubit>();
    final success =
        await playlistCubit.addVideoToPlaylist(playlist.id, widget.videoId);

    setState(() {
      addingToPlaylists.remove(playlist.id);
    });

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.isArabic
                ? 'تم إضافة الفيديو إلى "${playlist.name}"'
                : 'Added to "${playlist.name}"',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Close dialog after short delay
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.isArabic ? 'فشل في إضافة الفيديو' : 'Failed to add video',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCreatePlaylistDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (context) => serviceLocator<PlaylistCubit>(),
        child: AlertDialog(
          title: Text(
            context.isArabic
                ? 'إنشاء قائمة تشغيل جديدة'
                : 'Create New Playlist',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: context.isArabic ? 'اسم القائمة' : 'Playlist Name',
                  hintText: context.isArabic
                      ? 'أدخل اسم القائمة'
                      : 'Enter playlist name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: context.isArabic ? 'الوصف' : 'Description',
                  hintText: context.isArabic
                      ? 'أدخل وصف القائمة'
                      : 'Enter playlist description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                context.isArabic ? 'إلغاء' : 'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            BlocConsumer<PlaylistCubit, PlaylistState>(
              listener: (context, state) {
                if (state.isSuccess && !state.isCreating) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.isArabic
                            ? 'تم إنشاء قائمة التشغيل بنجاح'
                            : 'Playlist created successfully',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Refresh playlists in the main dialog
                  context.read<PlaylistCubit>().getMyPlaylists(refresh: true);
                } else if (state.isError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.failure?.toString() ??
                            (context.isArabic
                                ? 'فشل في إنشاء قائمة التشغيل'
                                : 'Failed to create playlist'),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.isCreating
                      ? null
                      : () async {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.isArabic
                                      ? 'يرجى إدخال اسم القائمة'
                                      : 'Please enter playlist name',
                                ),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          await context.read<PlaylistCubit>().createPlaylist(
                                name: nameController.text.trim(),
                                description: descriptionController.text.trim(),
                              );
                        },
                  child: state.isCreating
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.isArabic ? 'إنشاء' : 'Create'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
