import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class EditProfileTinder extends StatelessWidget {
  const EditProfileTinder({super.key});

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.editProfile.localize,
      ),
      body: BlocProvider<TinderViewCubit>(
        create: (BuildContext context) => serviceLocator()
          ..fetchUserProfile(userId: userCubit.state.data!.id),
        child: BlocBuilder<TinderViewCubit, TinderViewState>(
          builder: (BuildContext context, state) {
            var controller = context.read<TinderViewCubit>();
            if (state.status == TinderStates.success) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1 / 1.3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 9, // Always display 9 items
                  itemBuilder: (context, index) {
                    final hasImage =
                        index < (state.profileUserData?.pictures.length ?? 0);
                    final imageUrl = hasImage
                        ? state.profileUserData!.pictures[index].mediaKey
                        : null;

                    return Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Container(
                          height: 200.h,
                          margin: EdgeInsets.symmetric(horizontal: 15.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: hasImage
                                ? null
                                : Border.all(color: Colors.grey, width: 2),
                            color: hasImage ? null : Colors.grey[400],
                            image: hasImage
                                ? DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(imageUrl!),
                                  )
                                : state.newImage != null &&
                                        index ==
                                            state.profileUserData?.pictures
                                                .length
                                    ? DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(
                                            File(state.newImage!.file.path)),
                                      )
                                    : null,
                          ),
                          child: state.isUploading == false &&
                                  index ==
                                      state.profileUserData?.pictures.length
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.SECONDARY_COLOR,
                                  ),
                                )
                              : null,
                        ),
                        if (hasImage ||
                            (state.newImage != null &&
                                index ==
                                    state.profileUserData?.pictures.length))
                          InkWell(
                            onTap: () async {
                              await controller.deletePicture(
                                  state.profileUserData!.pictures[index].id);
                              controller.fetchUserProfile(
                                  userId: userCubit.state.data!.id);
                            },
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: AppColors.GREY_NORMAL_COLOR,
                              child: Icon(
                                Icons.clear,
                                color: AppColors.AUTH_CONTAINER_COLOR,
                                size: 40.sp,
                              ),
                            ),
                          )
                        else
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Wrap(
                                    children: <Widget>[
                                      ListTile(
                                          leading:
                                              const Icon(Icons.photo_library),
                                          title:
                                              Text(LocaleKeys.gallery.localize),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            await controller.uploadPhoto(
                                                isGallery: true, context: context);
                                          }),
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: Text(LocaleKeys.camera.localize),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          await controller.uploadPhoto(
                                              isGallery: false, context: context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: AppColors.SECONDARY_COLOR,
                              child: Icon(
                                Icons.add,
                                color: AppColors.AUTH_CONTAINER_COLOR,
                                size: 40.sp,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/upload_tinder_picture_use_case.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
//
// class EditProfileTinder extends StatelessWidget {
//   const EditProfileTinder({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final userCubit = context.read<UserCubit>();
//     return Scaffold(
//       appBar: BackAppBar(
//         label: LocaleKeys.editProfile.localize,
//       ),
//       body: BlocProvider<TinderViewCubit>(
//         create: (BuildContext context) => serviceLocator()
//           ..fetchUserProfile(userId: userCubit.state.data!.id),
//         child: BlocBuilder<TinderViewCubit, TinderViewState>(
//           builder: (BuildContext context, state) {
//             var controller=context.read<TinderViewCubit>();
//             return Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 1 / 1.3,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: 9, // Always display 9 items
//                 itemBuilder: (context, index) {
//                   final hasImage = index < (state.profileUserData?.pictures.length ?? 0);
//                   final imageUrl = hasImage
//                       ? state.profileUserData!.pictures[index].mediaKey
//                       : null;
//
//                   return Stack(
//                     alignment: AlignmentDirectional.bottomStart,
//                     children: [
//                       Container(
//                         height: 200.h,
//                         margin: EdgeInsets.symmetric(horizontal: 15.w),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12.r),
//                           border: hasImage
//                               ? null
//                               : Border.all(color: Colors.grey, width: 2),
//                           color: hasImage ? null : Colors.grey[400],
//                           image: hasImage
//                               ? DecorationImage(
//                             fit: BoxFit.fill,
//                             image: NetworkImage(imageUrl!),
//                           )
//                               : state.newImage != null && index == state.profileUserData?.pictures.length
//                               ? DecorationImage(
//                             fit: BoxFit.fill,
//                             image: FileImage(File(state.newImage!.file.path)),
//                           )
//                               : null,
//                         ),
//                       ),
//                       if (hasImage || state.newImage != null && index == state.profileUserData?.pictures.length)
//                         CircleAvatar(
//                           radius: 30.r,
//                           backgroundColor: AppColors.GREY_NORMAL_COLOR,
//                           child: Icon(
//                             Icons.clear,
//                             color: AppColors.AUTH_CONTAINER_COLOR,
//                             size: 40.sp,
//                           ),
//                         )
//                       else
//                         InkWell(
//                           onTap: () {
//                             showModalBottomSheet(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return Wrap(
//                                   children: <Widget>[
//                                     ListTile(
//                                       leading: const Icon(Icons.photo_library),
//                                       title: Text(LocaleKeys.gallery.localize),
//                                       onTap: () async {
//                                         Navigator.pop(context);
//                                         final image = await controller.uploadPhoto(isGallery: true);
//                                         if (image != null) {
//                                           await context.read<TinderViewCubit>().uploadPictures(
//                                             pictures: AddImagesParams(
//                                               media: [image],
//                                             ),
//                                           );
//                                           // Reload user profile data to refresh the grid
//                                           await controller.fetchUserProfile(
//                                               userId: userCubit.state.data!.id);
//                                         }
//                                       },
//                                     ),
//                                     ListTile(
//                                       leading: const Icon(Icons.camera_alt),
//                                       title: Text(LocaleKeys.camera.localize),
//                                       onTap: () async {
//                                         Navigator.pop(context);
//                                         final image = await controller.uploadPhoto(isGallery: false);
//                                         if (image != null) {
//                                           await context.read<TinderViewCubit>().uploadPictures(
//                                             pictures: AddImagesParams(
//                                               media: [image],
//                                             ),
//                                           );
//                                           // Reload user profile data to refresh the grid
//                                           await controller.fetchUserProfile(
//                                               userId: userCubit.state.data!.id);
//                                         }
//                                       },
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                           child: CircleAvatar(
//                             radius: 30.r,
//                             backgroundColor: AppColors.SECONDARY_COLOR,
//                             child: Icon(
//                               Icons.add,
//                               color: AppColors.AUTH_CONTAINER_COLOR,
//                               size: 40.sp,
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
