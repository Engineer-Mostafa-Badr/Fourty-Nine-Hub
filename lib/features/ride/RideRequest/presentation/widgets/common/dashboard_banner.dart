import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../food_feature/restaurants_list/data/models/is_restaurant_model.dart';

class DashboardBanner extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? route;
  final IsRestaurantModel? isRestaurantModel;
  final void Function()? onTap;

  const DashboardBanner(
      {super.key,
      this.subTitle,
      required this.title,
      this.route,
      this.onTap,
      this.isRestaurantModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            if (route != null) {
              context.push(route!, extra: isRestaurantModel);
            }
          },
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20.r)),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: title,
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
                size: 35.w,
              ),
            ],
          )),
    );
  }
}
