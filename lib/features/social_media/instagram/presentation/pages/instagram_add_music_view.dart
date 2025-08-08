import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../cubit/instagram_add_music_cubit/instagram_add_music_cubit.dart';
import '../widgets/post_instagram_widget.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class InstagramAddMusicView extends StatelessWidget {
  const InstagramAddMusicView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Label(
          text: LocaleKeys.addMusic.localize,
          style: Styles.headerText(
            fontSize: 40,
          ),
        ),
        leading: IconButton(
          onPressed: () {
      ManageVibration.vibrate();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_rounded),
          color: context.isDarkMode ? Colors.white : const Color(0xB3000000),
        ),
      ),
      body: const InstagramAddMusicViewBody(),
    );
  }
}

class InstagramAddMusicViewBody extends StatelessWidget {
  const InstagramAddMusicViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstagramAddMusicCubit, InstagramAddMusicState>(
      buildWhen: (previous, current) =>
          previous.isSelectedMusic != current.isSelectedMusic,
      builder: (context, state) {
        if (state.isSelectedMusic) {
          return const Column(
            children: [],
          );
        } else {
          return Stack(
            children: [
              const Column(
                children: [
                  InstagramAddMusicViewAppBar(),
                  SizedBox(
                    height: 16,
                  ),
                  MusicSectionsWidget(),
                  SizedBox(
                    height: 4,
                  ),
                  InstagramAddMusicListView(),
                ],
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 34,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF4C2F2B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      ImageFromInternet(
                        image: testImage,
                        height: 44,
                        width: 44,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            text: 'Amr Diab Music',
                            style: Styles.mediumText(
                              color: context.isDarkMode
                                  ? const Color(0xff0D0D0D)
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.29,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Label(
                            text: 'Amr Diab',
                            style: Styles.smallText(
                              fontSize: 24,
                              color: context.isDarkMode
                                  ? const Color(0xff0D0D0D)
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 0.83,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {

      ManageVibration.vibrate();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.pause,
                            color: context.isDarkMode
                                ? const Color(0xff0D0D0D)
                                : Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {

      ManageVibration.vibrate();
                        },
                        child: Icon(
                          Icons.arrow_circle_right,
                          color: context.isDarkMode
                              ? const Color(0xff0D0D0D)
                              : Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class InstagramAddMusicListView extends StatelessWidget {
  const InstagramAddMusicListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 20 : 0),
            child: ListTile(
              onTap: () {

      ManageVibration.vibrate();
              },
              leading: ImageFromInternet(
                image: testImage,
                height: 44,
                width: 44,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(4),
              ),
              title: Label(
                text: 'Amr Diab Music',
                style: Styles.mediumText(
                  fontWeight: FontWeight.w500,
                  height: 1.29,
                ),
              ),
              subtitle: Label(
                text: 'Amr Diab',
                style: Styles.smallText(
                  fontSize: 24,
                  color: context.isDarkMode
                      ? const Color(0x66FFFFFF)
                      : const Color(0x66000000),
                  fontWeight: FontWeight.w500,
                  height: 0.83,
                ),
              ),
              trailing: IconButton(
                onPressed: () {

      ManageVibration.vibrate();
                },
                icon: const Icon(Icons.turned_in_not),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MusicSectionsWidget extends StatelessWidget {
  const MusicSectionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstagramAddMusicCubit, InstagramAddMusicState>(
      buildWhen: (previous, current) =>
          previous.activeMusicSectionIndex != current.activeMusicSectionIndex,
      builder: (context, state) {
        final List<String> sections =
            context.read<InstagramAddMusicCubit>().musicSections;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: sections
                .map((section) => Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 12,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
      ManageVibration.vibrate();
                          final index = sections.indexOf(section);
                          context
                              .read<InstagramAddMusicCubit>()
                              .changeMusicSection(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: ShapeDecoration(
                            color: state.activeMusicSectionIndex ==
                                    sections.indexOf(section)
                                ? (context.isDarkMode
                                    ? const Color(0xff171717)
                                    : const Color(0xFFFFEEEA))
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Label(
                            text: section,
                            style: Styles.headerText(
                              color: state.activeMusicSectionIndex ==
                                      sections.indexOf(section)
                                  ? (context.isDarkMode
                                      ? const Color(0xffFF4622)
                                      : const Color(0xFFFF3308))
                                  : (context.isDarkMode
                                      ? const Color(0x4DFFFFFF)
                                      : const Color(0x4D000000)),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class InstagramAddMusicViewAppBar extends StatelessWidget {
  const InstagramAddMusicViewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: context.isDarkMode
              ? const Color(0xFF1B1B1B)
              : const Color(0xffF0F0F0),
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefixIcon: SizedBox(
            width: 16,
            height: 16,
            child: Center(
              child: SvgPicture.asset(context.isDarkMode
                  ? Assets.instagramSearchIconDark
                  : Assets.instagramSearchIcon),
            ),
          ),
          hintStyle: Styles.mediumText(
            color: context.isDarkMode
                ? const Color(0x80FFFFFF)
                : const Color(0x80000000),
          ),
          hintText: LocaleKeys.searchForALocation.localize,
        ),
      ),
    );
  }
}