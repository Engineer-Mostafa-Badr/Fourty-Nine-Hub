import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class ChatProfileView extends StatelessWidget {
  const ChatProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_COLOR, // Background color
        elevation: 0,
        leadingWidth: 26,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          LocaleKeys.profile.tr(),
          style: Styles.headerText(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture Section
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    UIConst.profilePlaceHolder,
                  ), // Profile Image
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: context.isDarkMode
                        ? AppColors.BACKGROUND_COLOR
                        : AppColors.PRIMARY_COLOR,
                    radius: 16,
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Name Section
            ListTile(
              leading: const Icon(
                Icons.person,
                color: AppColors.DARK_GRAY_COLOR,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.name.tr(),
                    style: Styles.mediumText(
                        color: AppColors.LIGHT_GRAY_COLOR2, fontSize: 24),
                  ),
                  Text(
                    context.read<UserCubit>().state.data!.fullName,
                    style: Styles.mediumText(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              trailing: Icon(Icons.edit,
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR),
              subtitle: Text(
                LocaleKeys.nameMessage.tr(),
                style: Styles.mediumText(
                    color: AppColors.LIGHT_GRAY_COLOR2, fontSize: 24),
              ),
            ),
            const Divider(),
            // About Section
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: AppColors.DARK_GRAY_COLOR,
              ),
              title: Text(
                LocaleKeys.about.tr(),
                style: Styles.mediumText(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'لا حول ولا قوة الا بالله العلي العظيم❤',
                // context.read<UserCubit>().state.data!.about,
                style: Styles.mediumText(
                    color: AppColors.LIGHT_GRAY_COLOR2, fontSize: 24),
              ),
              trailing: Icon(Icons.edit,
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR),
            ),
            const Divider(),
            // Phone Number Section
            // ListTile(
            //   leading:
            //       const Icon(Icons.phone, color: AppColors.DARK_GRAY_COLOR),
            //   title: Text(
            //     LocaleKeys.phone.tr(),
            //     style: Styles.mediumText(fontWeight: FontWeight.bold),
            //   ),
            //   subtitle: Text(
            //     '+20 1211972375',
            //     style: Styles.mediumText(
            //         color: AppColors.LIGHT_GRAY_COLOR2, fontSize: 24),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
