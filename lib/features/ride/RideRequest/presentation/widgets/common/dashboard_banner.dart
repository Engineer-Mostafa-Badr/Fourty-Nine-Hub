import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class DashboardBanner extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? route;
  const DashboardBanner(
      {super.key, this.subTitle, required this.title, this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (route != null) {
          context.push(route!);
        }
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)),
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
              ),
            ],
          )),
    );
  }
}
