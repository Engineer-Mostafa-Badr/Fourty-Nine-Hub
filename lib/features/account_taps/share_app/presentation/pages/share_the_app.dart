import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../cubit/share_app_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShareTheApp extends StatelessWidget {
  const ShareTheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: 'Share App',
        ),
        body: Padding(
          padding:  EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: 30.w
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatisticsWidget(context: context),
              const Sizer(),
              Expanded(child: Image.asset(Assets.share)),
              const Sizer(),
               Label(text: 'Recommend Us',style: Styles.headerText(),),
              const Sizer(),
              const Label(
                  text: 'Share code with your friends and get 50 EGP for every one',
                maxLines: 5,
              ),
              const Sizer(),
              _buildLinkWidget(context: context),
              const Sizer(),
              // Stack(
              //   children: [
              //     Positioned.fill(
              //       child: Column(
              //         children: [
              //           Expanded(
              //               child: Container(
              //             decoration: BoxDecoration(
              //                 color: Theme.of(context).scaffoldBackgroundColor),
              //           )),
              //           Expanded(
              //               child: Container(
              //             decoration: BoxDecoration(
              //                 color: Theme.of(context).scaffoldBackgroundColor),
              //           )),
              //         ],
              //       ),
              //     ),
              //     Positioned.fill(
              //         child: Center(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.symmetric(
              //               horizontal: 20,
              //             ),
              //             child: Card(
              //               shadowColor: Theme.of(context).primaryColor,
              //               elevation: 10,
              //               child: Container(
              //                 padding: const EdgeInsets.all(20),
              //                 decoration: BoxDecoration(
              //                   color: Theme.of(context).scaffoldBackgroundColor,
              //                   borderRadius: BorderRadius.circular(10),
              //                   boxShadow: [
              //                     BoxShadow(color: Theme.of(context).primaryColor)
              //                   ],
              //                 ),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                   children: [
              //                     Image.asset(Assets.share),
              //                     const Sizer(),
              //                     _buildLinkWidget(context: context),
              //                     const Sizer(),
              //
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ))
              //   ],
              // ),
            ],
          ),
        ));
  }

  Widget _buildLinkWidget({required BuildContext context}) {
    final controller = context.read<ShareAppCubit>();
    return Column(
      children: [
        InkWell(
          onLongPress: () => controller.copyToClipboard(context),
          child: BadgedLabel(
              // height: kToolbarHeight,
              width: double.infinity,
              color: AppColors.GREY_NORMAL_COLOR,
              label: controller.link),
        ),
        const Sizer(),
        AppButton(
            color: AppColors.AUTH_CONTAINER_COLOR,
            label: 'Share The App',
            onPressed: () => controller.shareTheApp()),
      ],
    );
  }

  Widget _buildStatisticsWidget({required BuildContext context}) {
    return InkWell(
      onTap: () => context.push(Routes.WALLET),
      child: Row(
        children: [
          Expanded(
            child: _buildStatisticsItem(
                color: AppColors.PRIMARY_COLOR,
                title: 'Users',
                subTitle: '30 user'),
          ),
          const Sizer(),
          Expanded(
            child: _buildStatisticsItem(
                color: AppColors.PRIMARY_COLOR,
                title: 'Balance',
                subTitle: '1500'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsItem({
    required Color color,
    required String title,
    required String subTitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Label(
            text: title,
            style: Styles.mediumText(color: Colors.white),
          ),
          Label(
            text: subTitle,
            style: Styles.mediumText(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Widget _buildShareChannelsWidget() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10),
  //     margin: const EdgeInsets.symmetric(
  //       horizontal: 20,
  //     ),
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //     child: Row(
  //       children: [
  //         Expanded(
  //             child: Center(
  //           child: _buildShareChannelItem(
  //               label: 'Facebook',
  //               icon: FontAwesomeIcons.facebook,
  //               color: Colors.blue,
  //               onTap: () {}),
  //         )),
  //         Expanded(
  //             child: Center(
  //           child: _buildShareChannelItem(
  //               label: 'Instagram',
  //               icon: FontAwesomeIcons.instagram,
  //               color: Colors.purple,
  //               onTap: () {}),
  //         )),
  //         Expanded(
  //             child: Center(
  //           child: _buildShareChannelItem(
  //               label: 'WhatsApp',
  //               icon: FontAwesomeIcons.whatsapp,
  //               color: Colors.green,
  //               onTap: () {}),
  //         )),
  //         Expanded(
  //             child: Center(
  //           child: _buildShareChannelItem(
  //               label: 'Twitter',
  //               icon: FontAwesomeIcons.twitter,
  //               color: Colors.blue,
  //               onTap: () {}),
  //         )),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildShareChannelItem(
  //     {required String label,
  //     required IconData icon,
  //     required Color color,
  //     required Function onTap}) {
  //   return InkWell(
  //     onTap: () => onTap(),
  //     child: Container(
  //       padding: const EdgeInsets.all(10),
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       child: Icon(
  //         icon,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildHistoryWidget() {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Expanded(
  //               child: Label(
  //             text: 'Joined At',
  //             style: Styles.headerText(),
  //           )),
  //           TextButton(onPressed: () {}, child: const Label(text: 'See All'))
  //         ],
  //       ),
  //       ListView.separated(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemBuilder: (context, index) => _buildHistoryItemWidget(),
  //           separatorBuilder: (context, index) => const Sizer(),
  //           itemCount: 10),
  //     ],
  //   );
  // }
  //
  // Widget _buildHistoryItemWidget() {
  //   return Row(
  //     children: [
  //       const ProfileImage(
  //         accountId: 0,
  //         userId: '',
  //       ),
  //       const Sizer(),
  //       Expanded(
  //           child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Label(
  //             text: 'Farouk Shahin',
  //             style: Styles.mediumText(fontWeight: FontWeight.bold),
  //           ),
  //           const Label(text: 'Joined At: 2024-05-29')
  //         ],
  //       ))
  //     ],
  //   );
  // }
}
