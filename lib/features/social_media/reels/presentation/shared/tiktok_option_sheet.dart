import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/controller/tiktok_controller_extension.dart';
import 'package:fourtyninehub/features/zoom/presentation/widgets/join_meeting_screen.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../../../../zoom/presentation/controller/stream_cubit.dart';

void showTiktokOption(BuildContext context, int randomNumber) =>
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // Make background transparent for rounded effect
      isScrollControlled: true,
      // Allows the sheet to take more space
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          // Adjust as needed
          maxChildSize: 0.7,
          minChildSize: 0.2,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor, // Set background color
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: ListView(
                controller: controller,
                shrinkWrap: true,
                children: [
// Header Section
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Label(
                      text: LocaleKeys.liveStreamOptions.localize,
                      style: Styles.headerText()),
                  const SizedBox(height: 16),
// Option 1: Create Live
                  ListTile(
                    leading: const Icon(Icons.videocam, color: Colors.blue),
                    title: Label(
                      text: LocaleKeys.createLive.localize,
                      style: Styles.mediumText(),
                    ),
                    onTap: () async {
                      var result = await context.read<StreamCubit>().createLive(
                            title: 'create live',
                            roomId: randomNumber.toString(),
                            context: context,
                          );
                      if (result == true && context.mounted) {
                        context.push(
                          Routes.LIVEView,
                          extra: ZegoArgs(
                            context
                                .read<StreamCubit>()
                                .state
                                .liveCreateResponseEntity!
                                .id,
                            true,
                            context.read<UserCubit>().state.data!.fullName,
                          ),
                        );
                      } else {
                        print("Failed to create live stream");
                      }
                    },
                  ),
                  const Divider(),
// Option 2: Watch Live
                  ListTile(
                    leading: const Icon(Icons.tv, color: Colors.green),
                    title: Text(LocaleKeys.watch.localize),
                    onTap: () {
                      context.pop();
                      context.push(Routes.LIVE);
                    },
                  ),
                  const SizedBox(height: 10),
// Cancel Button
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Label(
                        text: LocaleKeys.cancel.localize,
                        style: Styles.mediumText()),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
