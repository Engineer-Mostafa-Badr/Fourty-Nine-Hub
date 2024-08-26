import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class ShippingBanner extends StatelessWidget {
  const ShippingBanner({
    super.key,
    required this.model,
  });
  final BannerModel model;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
            color: AppColors.YELLOW_COLOR,
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              fit: BoxFit.cover,
              image:
                  CachedNetworkImageProvider(model.mainCategory?.banner ?? ""),
            ),
          ),
        ),
        Container(
          height: 70,
          width: double.infinity,
          color: Colors.black.withOpacity(0.3),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Icon(
                    Icons.favorite_border,
                    color: AppColors.SECONDARY_COLOR,
                  ),
                  const Sizer(
                    height: 20,
                  ),
                  Text(
                    '${model.mainCategory?.driverLength?.toShortScale} ${"Driver"}',
                    style: Styles.mediumText(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              // if (isDriver()) Spacer(),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Ship",
                  style: Styles.headerText(color: Colors.white, fontSize: 22),
                ),
              ),
              // if(serviceLocator<CacheService>().getDriverId() == null)
              // if (!isDriver())
              // !isDriver()?
              InkWell(
                onTap: () {
                  if (!isDriver()) {
                    if (context.read<UserCubit>().isLoggedIn) {
                      // context.push(Routes.DRIVERREQUESTS);
                      context.push(Routes.SHIPPING_REGISTER);
                    } else {
                      // context.push(Routes.SHIPPING_REGISTER);
                      context.push(Routes.LOGIN);
                    }
                  }
                },
                //  isDriver()?Colors.transparent:
                child: Text(
                  Labels.register,
                  style: Styles.mediumText(color: isDriver()?Colors.transparent: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
              // if ((model.subCategories!.first.isDriverApproved ?? false))
              //   if ((model.subCategories!.first.isDriver ?? false))
              // if (isDriver()) Spacer()
            ],
          ),
        ),
      ],
    );
  }

  bool isDriver() {
    if (model.subCategories!.first.isDriver ?? false) {
      return true;
    } else {
      if (model.subCategories!.first.isDriverApproved ?? false) {
        return true;
      } else {
        return false;
      }
    }
  }
}
