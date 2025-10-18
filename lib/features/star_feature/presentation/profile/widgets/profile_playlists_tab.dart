import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/playlist_entity.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/messages/messages.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../presentation_exports.dart';

import '../../shared/widgets/common/error_widget.dart';
import '../../shared/widgets/common/loading_indicator.dart';
import 'playlist/playlist_card.dart';
import 'playlist_details_page.dart';

class ProfilePlaylistsTab extends StatefulWidget {
  final bool isCurrentUser;
  final String? userId;

  const ProfilePlaylistsTab({
    super.key,
    required this.isCurrentUser,
    this.userId,
  });

  @override
  State<ProfilePlaylistsTab> createState() => _ProfilePlaylistsTabState();
}

class _ProfilePlaylistsTabState extends State<ProfilePlaylistsTab>
    with AutomaticKeepAliveClientMixin {
  late PlaylistCubit _playlistCubit;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _playlistCubit = context.read<PlaylistCubit>();
    _loadPlaylists();
  }

  void _loadPlaylists() {
    if (widget.isCurrentUser) {
      // Check if user is authenticated before loading
      if (!_playlistCubit.isAuthenticated) {
        print('❌ User not authenticated: ${_playlistCubit.currentUserInfo}');
        return;
      }

      print(
          '🎵 Loading current user playlists: ${_playlistCubit.currentUserInfo}');
      _playlistCubit.getMyPlaylists(refresh: true);
    } else if (widget.userId != null && widget.userId!.isNotEmpty) {
      // Validate user ID format before making API call
      if (widget.userId!.length != 24) {
        print('❌ Invalid user ID format: ${widget.userId}');
        return;
      }

      print('🎵 Loading playlists for user: ${widget.userId}');
      _playlistCubit.getPlaylists(widget.userId!, refresh: true);
    } else {
      print('❌ No user ID provided for other user playlists');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (context, state) {
        // Handle authentication issues
        if (widget.isCurrentUser && !_playlistCubit.isAuthenticated) {
          return _buildAuthenticationError(context);
        }

        // Handle invalid user ID
        if (!widget.isCurrentUser &&
            (widget.userId == null ||
                widget.userId!.isEmpty ||
                widget.userId!.length != 24)) {
          return _buildInvalidUserError(context);
        }

        if (state.isLoading && !state.hasPlaylists) {
          return Center(
            child: StarLoadingIndicator(),
          );
        }

        if (state.isError && !state.hasPlaylists) {
          return Center(
            child: StarErrorWidget(
              message: _getErrorMessage(context, state),
              onRetry: _loadPlaylists,
            ),
          );
        }

        if (!state.hasPlaylists) {
          return _buildEmptyState(context);
        }

        return Column(
          children: [
            // Header with Create Playlist button (only for current user)
            if (widget.isCurrentUser) ...[
              _buildHeader(context, state),
              SizedBox(height: 8),
            ],

            // Playlists List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _loadPlaylists(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  itemCount: state.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = state.playlists[index];
                    return // في ProfilePlaylistsTab
                        PlaylistCard(
                      playlist: playlist,
                      onTap: () => _handlePlaylistTap(context, playlist),
                      showMenu: widget.isCurrentUser,
                      overrideVideoCount: playlist.videosCount,
                      onEdit: widget.isCurrentUser
                          ? () => _showEditPlaylistDialog(context, playlist)
                          : null,
                      onDelete: widget.isCurrentUser
                          ? () => _showDeleteConfirmation(context, playlist)
                          : null,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAuthenticationError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.login,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            context.isArabic
                ? 'يرجى تسجيل الدخول أولاً'
                : 'Please log in first',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            context.isArabic
                ? 'تحتاج إلى تسجيل الدخول لعرض قوائم التشغيل الخاصة بك'
                : 'You need to log in to view your playlists',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to login screen
              context.push(Routes.FirstLoginScreen);
            },
            icon: Icon(Icons.login),
            label: Text(
              context.isArabic ? 'تسجيل الدخول' : 'Log In',
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvalidUserError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            context.isArabic ? 'معرف مستخدم غير صالح' : 'Invalid User ID',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            context.isArabic
                ? 'لا يمكن تحميل قوائم التشغيل لهذا المستخدم'
                : 'Cannot load playlists for this user',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(BuildContext context, PlaylistState state) {
    final errorMessage = state.failure?.toString() ?? '';

    // Check for specific error types
    if (errorMessage.contains('BSON') || errorMessage.contains('ObjectId')) {
      return context.isArabic
          ? 'خطأ في معرف المستخدم - يرجى المحاولة مرة أخرى'
          : 'User ID error - please try again';
    }

    if (errorMessage.contains('authentication') ||
        errorMessage.contains('auth')) {
      return context.isArabic
          ? 'خطأ في التحقق من الهوية - يرجى تسجيل الدخول مرة أخرى'
          : 'Authentication error - please log in again';
    }

    if (errorMessage.contains('network') ||
        errorMessage.contains('connection')) {
      return context.isArabic
          ? 'خطأ في الاتصال - تحقق من الإنترنت'
          : 'Connection error - check internet';
    }

    // Default error message
    return state.failure?.toString() ??
        (context.isArabic
            ? 'خطأ في تحميل قوائم التشغيل'
            : 'Failed to load playlists');
  }

  Widget _buildHeader(BuildContext context, PlaylistState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.isArabic
                ? 'قوائم التشغيل (${state.playlists.length.toString().toArabicNumbers(context)})'
                : 'Playlists (${state.playlists.length})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          // ElevatedButton.icon(
          //   onPressed: (state.isCreating || !_playlistCubit.isAuthenticated)
          //       ? null
          //       : () => _showCreatePlaylistDialog(context),
          //   icon: state.isCreating
          //       ? SizedBox(
          //           width: 16,
          //           height: 16,
          //           child: CircularProgressIndicator(strokeWidth: 2),
          //         )
          //       : Icon(
          //           Icons.add,
          //           size: 20,
          //           color: Colors.white,
          //         ),
          //   label: Text(
          //     context.isArabic ? 'إنشاء قائمة' : 'Create',
          //     style: TextStyle(fontSize: 14, color: Colors.white),
          //   ),
          //   style: ElevatedButton.styleFrom(
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.playlist_play,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            widget.isCurrentUser
                ? (context.isArabic
                    ? 'لا توجد قوائم تشغيل بعد'
                    : 'No playlists yet')
                : (context.isArabic ? 'لا توجد قوائم تشغيل' : 'No playlists'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          if (widget.isCurrentUser && _playlistCubit.isAuthenticated) ...[
            SizedBox(height: 8),
            Text(
              context.isArabic
                  ? 'ابدأ في إنشاء قوائم التشغيل الخاصة بك'
                  : 'Start creating your own playlists',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showCreatePlaylistDialog(context),
              icon: Icon(Icons.add),
              label: Text(
                context.isArabic ? 'إنشاء قائمة تشغيل' : 'Create Playlist',
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handlePlaylistTap(BuildContext context, PlaylistEntity playlist) {
    ManageVibration.vibrate();

    // Navigate to playlist details page with both PlaylistCubit and StarCubit
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => serviceLocator<PlaylistCubit>(),
              ),
              BlocProvider(
                create: (context) => serviceLocator<StarCubit>(),
              ),
            ],
            child: PlaylistDetailsPage(playlist: playlist),
          ),
        ));
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    if (!_playlistCubit.isAuthenticated) {
      context.push(Routes.FirstLoginScreen);
      return;
    }

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
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       context.isArabic
                  //           ? 'تم إنشاء قائمة التشغيل بنجاح'
                  //           : 'Playlist created successfully',
                  //     ),
                  //     backgroundColor: Colors.green,
                  //   ),
                  // );
                  showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم إنشاء قائمة التشغيل بنجاح'
                        : 'Playlist created successfully',
                  );
                } else if (state.isError) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       _getErrorMessage(context, state),
                  //     ),
                  //     backgroundColor: Colors.red,
                  //   ),
                  // );
                  showErrorMessage(
                    context,
                    _getErrorMessage(context, state),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.isCreating
                      ? null
                      : () async {
                          if (nameController.text.trim().isEmpty) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text(
                            //       context.isArabic
                            //           ? 'يرجى إدخال اسم القائمة'
                            //           : 'Please enter playlist name',
                            //     ),
                            //     backgroundColor: Colors.orange,
                            //   ),
                            // );
                            showErrorMessage(
                              context,
                              context.isArabic
                                  ? 'يرجى إدخال اسم القائمة'
                                  : 'Please enter playlist name',
                            );
                            return;
                          }

                          await _playlistCubit.createPlaylist(
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

  void _showEditPlaylistDialog(BuildContext context, PlaylistEntity playlist) {
    final nameController = TextEditingController(text: playlist.name);
    final descriptionController =
        TextEditingController(text: playlist.description);

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (context) => serviceLocator<PlaylistCubit>(),
        child: AlertDialog(
          title: Text(
            context.isArabic ? 'تعديل قائمة التشغيل' : 'Edit Playlist',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: context.isArabic ? 'اسم القائمة' : 'Playlist Name',
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
                if (state.isSuccess && !state.isUpdating) {
                  Navigator.pop(dialogContext);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       context.isArabic
                  //           ? 'تم تحديث قائمة التشغيل بنجاح'
                  //           : 'Playlist updated successfully',
                  //     ),
                  //     backgroundColor: Colors.green,
                  //   ),
                  // );
                  showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم تحديث قائمة التشغيل بنجاح'
                        : 'Playlist updated successfully',
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.isUpdating
                      ? null
                      : () async {
                          await _playlistCubit.updatePlaylist(
                            playlistId: playlist.id,
                            name: nameController.text.trim(),
                            description: descriptionController.text.trim(),
                          );
                        },
                  child: state.isUpdating
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.isArabic ? 'حفظ' : 'Save'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, PlaylistEntity playlist) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (context) => serviceLocator<PlaylistCubit>(),
        child: AlertDialog(
          title: Text(
            context.isArabic ? 'حذف قائمة التشغيل' : 'Delete Playlist',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            context.isArabic
                ? 'هل أنت متأكد من حذف قائمة التشغيل "${playlist.name}"؟ لا يمكن التراجع عن هذا الإجراء.'
                : 'Are you sure you want to delete playlist "${playlist.name}"? This action cannot be undone.',
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
                if (state.isSuccess && !state.isDeleting) {
                  Navigator.pop(dialogContext);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       context.isArabic
                  //           ? 'تم حذف قائمة التشغيل بنجاح'
                  //           : 'Playlist deleted successfully',
                  //     ),
                  //     backgroundColor: Colors.red,
                  //   ),
                  // );
                  showSuccessMessage(
                    context,
                    context.isArabic
                        ? 'تم حذف قائمة التشغيل بنجاح'
                        : 'Playlist deleted successfully',
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.isDeleting
                      ? null
                      : () async {
                          await _playlistCubit.deletePlaylist(playlist.id);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: state.isDeleting
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(context.isArabic ? 'حذف' : 'Delete'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
