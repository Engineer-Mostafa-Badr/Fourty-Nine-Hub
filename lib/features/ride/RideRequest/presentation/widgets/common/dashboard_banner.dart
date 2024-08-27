import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class DashboardBanner extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? route;
  final void Function()? onTap;
  const DashboardBanner(
      {super.key, this.subTitle, required this.title, this.route, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            if (route != null) {
              context.push(route!);
            }
          },
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20.zR)),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: '$title ',
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: subTitle,
                    style: Styles.mediumText(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ])),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 35.zW,
              ),
            ],
          )),
    );
  }
}
