// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/widget/custom_scaffold.dart';

class ChatProfileView extends StatelessWidget {
  const ChatProfileView({super.key});

  void _showBottomSheet({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onSave,
  }) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Styles.headerText(color: AppColors.PRIMARY_COLOR),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: title,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    onSave(controller.text.trim());
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.SECONDARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(LocaleKeys.save.tr(),
                      style: Styles.mediumText(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<UserCubit>(),
      child: BlocBuilder<UserCubit, BasicState>(
        builder: (context, state) {
          return CustomScaffold(
            appBar: AppBar(
              // backgroundColor: AppColors.PRIMARY_COLOR,
              elevation: 0,
              leadingWidth: 26,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              title: Text(
                LocaleKeys.profile.tr(),
                style: Styles.headerText(color: Colors.black),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          context
                                  .read<UserCubit>()
                                  .state
                                  .data!
                                  .profilePicture ??
                              UIConst.profilePlaceHolder,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            backgroundColor: context.isDarkMode
                                ? AppColors.BACKGROUND_COLOR
                                : AppColors.PRIMARY_COLOR,
                            radius: 16,
                            child: InkWell(
                              onTap: () async {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 16,),
                                        Container(
                                          width: 42,
                                          height: 4,
                                          decoration: const BoxDecoration(
                                            // shape: BoxShape.circle,
                                              color: Color(0xffD9D9D9),
                                              borderRadius: BorderRadius.all(Radius.circular(50))
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                  onTap:(){
                                                    context.pop();
                                                  },
                                                  child: Icon(Icons.close_outlined, color: Colors.black.withOpacity(0.5),)),
                                              Text(context.isArabic? "صورة الملف الشخصي" : 'Profile photo', style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                              ),),
                                              Icon(Icons.delete_outline, color: Colors.black.withOpacity(0.5),)
                                            ],
                                          ),
                                        ),
                                         Padding(
                                           padding: const EdgeInsets.all(16),
                                           child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  await context
                                                      .read<UserCubit>()
                                                      .uploadPhoto(isGallery: false, context: context);
                                                  // Reload user data if needed
                                                },
                                                child: Column(
                                                  children: [
                                                    const Icon(Icons.camera_alt_outlined,color: AppColors.PRIMARY_COLOR_DARK, size: 30,),
                                                    const SizedBox(height: 8,),
                                                    Text(context.isArabic? "كاميرا": 'Camera', style: TextStyle(
                                                      color: Colors.black.withOpacity(0.5),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),)
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 24,),
                                              InkWell(
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  await context
                                                      .read<UserCubit>()
                                                      .uploadPhoto(isGallery: true, context: context);
                                                  // Reload user data if needed
                                                },
                                                child: Column(
                                                  children: [
                                                    const Icon(Icons.photo_outlined,color: AppColors.PRIMARY_COLOR_DARK, size: 30,),
                                                    const SizedBox(height: 8,),
                                                    Text(context.isArabic? "المعرض":'Gallery', style: TextStyle(
                                                      color: Colors.black.withOpacity(0.5),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),)
                                                  ],
                                                ),
                                              ),
                                            ],
                                                                                   ),
                                         ),

                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: AppColors.DARK_GRAY_COLOR,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.name.tr(),
                          style: Styles.mediumText(
                              color: Colors.black, fontSize: 34),
                        ),
                        Text(
                          context.read<UserCubit>().state.data!.fullName,
                          style: Styles.mediumText(fontWeight: FontWeight.w500,color: AppColors.DARK_GRAY_COLOR,),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: context.isDarkMode
                            ? Colors.white
                            :  AppColors.DARK_GRAY_COLOR,
                      ),
                      onPressed: () => _showBottomSheet(
                        context: context,
                        title: context.isArabic ? "تعديل الاسم" : "Update Name",
                        initialValue:
                            context.read<UserCubit>().state.data!.fullName,
                        onSave: (newValue) async {
                          await context
                              .read<UserCubit>()
                              .updateUserName(name: newValue);
                          await context.read<UserCubit>().getUser();
                        },
                      ),
                    ),
                    // subtitle: Text(
                    //   LocaleKeys.nameMessage.tr(),
                    //   style: Styles.mediumText(
                    //       color: AppColors.LIGHT_GRAY_COLOR2, fontSize: 24),
                    // ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: AppColors.DARK_GRAY_COLOR,
                    ),
                    title: Text(
                      LocaleKeys.about.tr(),
                      style: Styles.mediumText(
                          color: Colors.black, fontSize: 34),
                    ),
                    subtitle: Text(
                      context.read<UserCubit>().state.data!.bio == null ||
                              context.read<UserCubit>().state.data!.bio == ''
                          ? context.isArabic
                              ? " مرحبا انا استخدم تطبيق 49Hub"
                              : "Hi I am using 49Hub App"
                          : context.read<UserCubit>().state.data!.bio!,
                      style: Styles.mediumText(fontWeight: FontWeight.w500,color: AppColors.DARK_GRAY_COLOR,),
                    ),

                    trailing: IconButton(
                      icon: Icon(Icons.edit_outlined,
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.DARK_GRAY_COLOR,),
                      onPressed: () => _showBottomSheet(
                        context: context,
                        // title: LocaleKeys.updateBio.tr(),
                        title: context.isArabic ? "تعدبل الوصف" : "Update bio",
                        initialValue:
                            context.read<UserCubit>().state.data!.bio ?? '',
                        onSave: (newValue) async {
                          await context
                              .read<UserCubit>()
                              .updateUserBio(bio: newValue);
                          await context.read<UserCubit>().getUser();
                        },
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () async {
                      await context
                          .read<UserCubit>()
                          .getProfileView(isProfile: true);

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.9,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        builder: (context) {
                          // Ensure the context has access to ChatsCubit using BlocProvider
                          return BlocBuilder<UserCubit, BasicState>(
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Header
                                    Container(
                                      width: 42,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        // shape: BoxShape.circle,
                                        color: Color(0xffD9D9D9),
                                        borderRadius: BorderRadius.all(Radius.circular(50))
                                      ),
                                    ),
                                    const SizedBox(height: 16,),
                                    Text(
                                      context.isArabic
                                          ? "مشاهدات الملف الشخصي"
                                          : "Who viewed my profile?",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // List of last seen chats
                                    if (context
                                        .read<UserCubit>()
                                        .profileViews
                                        .isEmpty)
                                      Center(
                                        child: Text(
                                          context.isArabic
                                              ? "لا يوجد بيانات"
                                              : 'No data available',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      )
                                    else
                                      Flexible(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: context
                                              .read<UserCubit>()
                                              .profileViews
                                              .length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () async {
                                                await context
                                                    .read<UserCubit>()
                                                    .getProfileViewByUserId(
                                                      isProfile: true,
                                                      userId: context
                                                          .read<UserCubit>()
                                                          .profileViews[index]
                                                          .userId,
                                                    );
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.white,
                                                  constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.9,
                                                  ),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  builder: (context) {
                                                    // Ensure the context has access to ChatsCubit using BlocProvider
                                                    return BlocBuilder<
                                                        UserCubit, BasicState>(
                                                      builder:
                                                          (context, state) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              // Header
                                                              Container(
                                                                width: 42,
                                                                height: 4,
                                                                decoration: const BoxDecoration(
                                                                  // shape: BoxShape.circle,
                                                                    color: Color(0xffD9D9D9),
                                                                    borderRadius: BorderRadius.all(Radius.circular(50))
                                                                ),
                                                              ),
                                                              const SizedBox(height: 16,),
                                                              Text(
                                                                context.isArabic
                                                                    ? " المشاهدات بواسطة ${context.read<UserCubit>().profileViews[index].name}"
                                                                    : "Views by ${context.read<UserCubit>().profileViews[index].name}",
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 16),
                                                              // List of last seen chats
                                                              if (context
                                                                  .read<
                                                                      UserCubit>()
                                                                  .profileViewsByUserId
                                                                  .isEmpty)
                                                                Center(
                                                                  child: Text(
                                                                    context.isArabic
                                                                        ? "لا يوجد بيانات"
                                                                        : 'No data available',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                )
                                                              else
                                                                Flexible(
                                                                  child: ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: context
                                                                        .read<
                                                                            UserCubit>()
                                                                        .profileViewsByUserId
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                                                                                            leading:
                                                                        ClipRRect(
                                                                      borderRadius: BorderRadius.circular(50),
                                                                      child: CircleAvatar(
                                                                        radius: 25,
                                                                        child: Image.network(
                                                                          context.read<UserCubit>().profileViewsByUserId[index].avatar,
                                                                          fit: BoxFit.cover,
                                                                          width: 50,
                                                                          height: 50,
                                                                          errorBuilder: (context, error, stackTrace) {
                                                                            return Image.network(
                                                                              UIConst.profilePlaceHolder,
                                                                              fit: BoxFit.cover,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                                                                                            ),
                                                                                                                                            title:
                                                                        Text(
                                                                      context.read<UserCubit>().profileViewsByUserId[index].name,
                                                                      style: const TextStyle(
                                                                        fontWeight:
                                                                        FontWeight.w400,
                                                                        fontSize: 17,
                                                                      ),
                                                                                                                                            ),
                                                                                                                                            subtitle:
                                                                        Text(
                                                                      '${context.read<UserCubit>().profileViewsByUserId[index].date}         ${context.read<UserCubit>().profileViewsByUserId[index].time}',
                                                                      style: const TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                                                                                            ),
                                                                                                                                              );
                                                                    },
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              child: ListTile(
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50),
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor: Colors.white,
                                                    child: Image.network(
                                                      context
                                                          .read<UserCubit>()
                                                          .profileViews[
                                                              index]
                                                          .avatar,
                                                      fit: BoxFit.cover,
                                                      width: 50,
                                                      height: 50,
                                                      errorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        return Image
                                                            .network(
                                                          UIConst
                                                              .profilePlaceHolder,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  context
                                                      .read<UserCubit>()
                                                      .profileViews[index]
                                                      .name,
                                                  style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  '${context.read<UserCubit>().profileViews[index].date}       ${context.read<UserCubit>().profileViews[index].time}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            context.isArabic
                                ? "مشاهدات الملف الشخصي"
                                : "Who viewed my profile?",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 24,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    ),
                  ),
                  // const SizedBox(height: 1.0), // Space between containers
                  InkWell(
                    onTap: () async {
                      await context
                          .read<UserCubit>()
                          .getProfileView(isProfile: false);

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.9,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          // Ensure the context has access to ChatsCubit using BlocProvider
                          return BlocBuilder<UserCubit, BasicState>(
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Header
                                    Container(
                                      width: 42,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        // shape: BoxShape.circle,
                                          color: Color(0xffD9D9D9),
                                          borderRadius: BorderRadius.all(Radius.circular(50))
                                      ),
                                    ),
                                    const SizedBox(height: 16,),
                                    Text(
                                      context.isArabic
                                          ? "مشاهدات صورة الملف الشخصي"
                                          : "Who viewed my profile picture?",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // List of last seen chats
                                    if (context
                                        .read<UserCubit>()
                                        .profileViews
                                        .isEmpty)
                                      Center(
                                        child: Text(
                                          context.isArabic
                                              ? "لا يوجد بيانات"
                                              : 'No data available',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      )
                                    else
                                      Flexible(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: context
                                              .read<UserCubit>()
                                              .profileViews
                                              .length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () async {
                                                await context
                                                    .read<UserCubit>()
                                                    .getProfileViewByUserId(
                                                      isProfile: false,
                                                      userId: context
                                                          .read<UserCubit>()
                                                          .profileViews[index]
                                                          .userId,
                                                    );
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.white,
                                                  constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.9,
                                                  ),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  builder: (context) {
                                                    // Ensure the context has access to ChatsCubit using BlocProvider
                                                    return BlocBuilder<
                                                        UserCubit, BasicState>(
                                                      builder:
                                                          (context, state) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              // Header
                                                              Container(
                                                                width: 42,
                                                                height: 4,
                                                                decoration: const BoxDecoration(
                                                                  // shape: BoxShape.circle,
                                                                    color: Color(0xffD9D9D9),
                                                                    borderRadius: BorderRadius.all(Radius.circular(50))
                                                                ),
                                                              ),
                                                              const SizedBox(height: 16,),
                                                              Text(
                                                                context.isArabic
                                                                    ? " المشاهدات بواسطة ${context.read<UserCubit>().profileViews[index].name}"
                                                                    : "Views by ${context.read<UserCubit>().profileViews[index].name}",
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 16),
                                                              // List of last seen chats
                                                              if (context
                                                                  .read<
                                                                      UserCubit>()
                                                                  .profileViewsByUserId
                                                                  .isEmpty)
                                                                Center(
                                                                  child: Text(
                                                                    context.isArabic
                                                                        ? "لا يوجد بيانات"
                                                                        : 'No data available',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                )
                                                              else
                                                                Flexible(
                                                                  child: ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: context
                                                                        .read<
                                                                            UserCubit>()
                                                                        .profileViewsByUserId
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                                                                                            leading:
                                                                        ClipRRect(
                                                                      borderRadius: BorderRadius.circular(50),
                                                                      child: CircleAvatar(
                                                                        radius: 25,
                                                                        child: Image.network(
                                                                          context.read<UserCubit>().profileViewsByUserId[index].avatar,
                                                                          fit: BoxFit.cover,
                                                                          width: 50,
                                                                          height: 50,
                                                                          errorBuilder: (context, error, stackTrace) {
                                                                            return Image.network(
                                                                              UIConst.profilePlaceHolder,
                                                                              fit: BoxFit.cover,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                                                                                            ),
                                                                                                                                            title:
                                                                        Text(
                                                                      context.read<UserCubit>().profileViewsByUserId[index].name,
                                                                      style: const TextStyle(
                                                                        fontWeight:
                                                                        FontWeight.w400,
                                                                        fontSize: 17,
                                                                      ),
                                                                                                                                            ),
                                                                                                                                            subtitle:
                                                                        Text(
                                                                      '${context.read<UserCubit>().profileViewsByUserId[index].date}        ${context.read<UserCubit>().profileViewsByUserId[index].time}',
                                                                      style: const TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                                                                                            ),
                                                                                                                                              );
                                                                    },
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              child: ListTile(
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50),
                                                  child: CircleAvatar(
                                                    radius: 25,

                                                    child: Image.network(
                                                      context
                                                          .read<UserCubit>()
                                                          .profileViews[
                                                              index]
                                                          .avatar,
                                                      fit: BoxFit.cover,
                                                      width: 50,
                                                      height: 50,
                                                      errorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        return Image
                                                            .network(
                                                          UIConst
                                                              .profilePlaceHolder,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  context
                                                      .read<UserCubit>()
                                                      .profileViews[index]
                                                      .name,
                                                  style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  '${context.read<UserCubit>().profileViews[index].date}       ${context.read<UserCubit>().profileViews[index].time}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            context.isArabic
                                ? "مشاهدات صورة الملف الشخصي"
                                : "Who viewed my profile picture?",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 24,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
