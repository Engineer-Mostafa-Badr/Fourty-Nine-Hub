import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../../../common/functions/helper/lang_helper.dart';

class ShippingBanner extends StatelessWidget {
  const ShippingBanner({
    super.key,
    required this.model,
  });

  final BannerModel model;

  @override
  Widget build(BuildContext context) {
    return MainCategoryBanner(
      category: MainCategoryEntity(
        id: model.mainCategory?.mainCategoryId ?? '',
        name: getLang() == 'ar'
            ? model.mainCategory?.nameAr ?? ''
            : model.mainCategory?.nameEn ?? '',
        banner: model.mainCategory?.banner ?? UIConst.imagePlaceHolder,
        cover: model.mainCategory?.cover ?? UIConst.imagePlaceHolder,
        image: UIConst.imagePlaceHolder,
        total: model.mainCategory?.driverLength ?? 0,
        isFavorite: false, nameEn: '',
      ),
      onFavorite: () {},
    );
    // return Container(
    //   padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
    //   decoration: BoxDecoration(
    //     color: AppColors.YELLOW_COLOR,
    //     borderRadius: BorderRadius.circular(5),
    //     image: DecorationImage(
    //       fit: BoxFit.cover,
    //       image: CachedNetworkImageProvider(model.mainCategory?.banner ?? ""),
    //     ),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Column(
    //         children: [
    //           const Icon(
    //             Icons.favorite_border,
    //             color: AppColors.SECONDARY_COLOR,
    //           ),
    //           Sizer
    //             height: 20.h,
    //           ),
    //           Text(
    //             '${model.mainCategory?.driverLength?.toShortScale} ${"Driver"}',
    //             style: Styles.mediumText(
    //               color: Colors.white,
    //             ),
    //           )
    //         ],
    //       ),
    //       Text(
    //         "Shipping",
    //         style: Styles.headerText(color: Colors.white),
    //       ),
    //       InkWell(
    //         onTap: () {
    //           if (context.read<UserCubit>().isLoggedIn) {
    //             context.push(Routes.SHIPPING_REGISTER);
    //           } else {
    //             context.push(Routes.SHIPPING_REGISTER);
    //             // context.push(Routes.LOGIN);
    //           }
    //         },
    //         child: Text(
    //           Labels.register,
    //           style: Styles.mediumText(color: Colors.white),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
