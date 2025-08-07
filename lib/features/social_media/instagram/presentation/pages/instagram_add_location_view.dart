import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import '../cubit/instagram_add_location_cubit/instagram_add_location_cubit.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../helpers/manage_vibration.dart';

class InstagramAddLocationView extends StatelessWidget {
  const InstagramAddLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstagramAddLocationCubit, InstagramAddLocationState>(
      listener: (context, state) {
        // if (state.status.isInitial) {
        //   print('remove remove remove remove remove remove');
        //   context.read<CreatePostInstagramCubit>().removeLocation();
        // }
        if (state.status.isLoading) {
          showLoadingDialog(context);
        }
        if (state.status.isSuccess) {
          context.read<CreatePostInstagramCubit>().addLocation(state.location!);
          context.pop();
        }
        if (state.status.isFailure) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure!,
              context,
            ),
          );
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          appBar: AppBar(
              title: Label(
                text: LocaleKeys.selectALocation.localize,
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
                color: context.isDarkMode
                    ? Colors.white
                    : Colors.black.withValues(alpha: 0.7),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
      ManageVibration.vibrate();
                      context
                          .read<InstagramAddLocationCubit>()
                          .fetchLocationAndAddress();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        Assets.instagramRefreshRedIcon,
                      ),
                    ),
                  ),
                ),
              ]),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Container(
                //   height: 40,
                //   clipBehavior: Clip.antiAlias,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(6),
                //   ),
                //   child: TextField(
                //     decoration: InputDecoration(
                //
                //       filled: true,
                //       fillColor: const Color(0xffF0F0F0),
                //       border: InputBorder.none,
                //       focusedBorder: InputBorder.none,
                //       enabledBorder: InputBorder.none,
                //       prefixIcon: SizedBox(
                //           width: 16,
                //           height: 16,
                //           child: Center(
                //               child: SvgPicture.asset(Assets.instagramSearchIcon))),
                //       hintStyle: Styles.mediumText(
                //         color: const Color(0x80000000),
                //       ),
                //       hintText: LocaleKeys.searchForALocation.localize,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 72,
                ),
                if (state.location != null)
                  Column(
                    children: [
                      Label(
                        text: state.location!.name,
                        style: Styles.headerText(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                        width: double.infinity,
                      ),
                      InkWell(
                        onTap: () {
      ManageVibration.vibrate();
                          context
                              .read<InstagramAddLocationCubit>()
                              .removeLocation();
                          context
                              .read<CreatePostInstagramCubit>()
                              .removeLocation();
                        },
                        child: Material(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 23,
                              vertical: 12,
                            ),
                            decoration: ShapeDecoration(
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.c0B1035,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Label(
                              text: LocaleKeys.close.localize,
                              style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? const Color(0xFF0D0D0D)
                                      : Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Label(
                        text: LocaleKeys.seePlacesNearYou.localize,
                        style: Styles.headerText(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Label(
                          text: LocaleKeys
                              .toIncludeNearbyPlacesTurnOnLocationServices
                              .localize,
                          style: Styles.mediumText(
                            color: const Color(0xFF7F7F7F),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
      ManageVibration.vibrate();
                          context
                              .read<InstagramAddLocationCubit>()
                              .fetchLocationAndAddress();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 23, vertical: 12),
                          decoration: ShapeDecoration(
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.c0B1035,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Label(
                            text: LocaleKeys.turnOnLocationServices.localize,
                            style: Styles.mediumText(
                                color: context.isDarkMode
                                    ? const Color(0xFF0D0D0D)
                                    : Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                // Stack(
                //   children: [
                //     Column(
                //       children: [
                //         Label(
                //           text: LocaleKeys.seePlacesNearYou.localize,
                //           style: Styles.headerText(
                //             fontSize: 32,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //         const SizedBox(
                //           height: 4,
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 16),
                //           child: Label(
                //             text: LocaleKeys
                //                 .toIncludeNearbyPlacesTurnOnLocationServices
                //                 .localize,
                //             style: Styles.mediumText(
                //               color: const Color(0xFF7F7F7F),
                //               fontWeight: FontWeight.w500,
                //             ),
                //             maxLines: 2,
                //             textAlign: TextAlign.center,
                //           ),
                //         ),
                //         const SizedBox(
                //           height: 16,
                //         ),
                //         InkWell(
                //           onTap: () {
                //             context
                //                 .read<InstagramAddLocationCubit>()
                //                 .fetchLocationAndAddress();
                //           },
                //           child: Container(
                //             padding: const EdgeInsets.symmetric(
                //                 horizontal: 23, vertical: 12),
                //             decoration: ShapeDecoration(
                //               color: AppColors.c0B1035,
                //               shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(8)),
                //             ),
                //             child: Label(
                //               text: LocaleKeys.turnOnLocationServices.localize,
                //               style: Styles.mediumText(color: Colors.white),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //     PositionedDirectional(
                //       top: 0,
                //       end: 0,
                //       child: InkWell(
                //         onTap: () {},
                //         child: const Icon(
                //           Icons.close,
                //           color: Color(0xB3000000),
                //         ),
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}