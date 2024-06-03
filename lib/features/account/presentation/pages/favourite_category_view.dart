import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';

class FavouriteCategoryView extends StatefulWidget {
  const FavouriteCategoryView({super.key});

  @override
  State<FavouriteCategoryView> createState() => _FavouriteCategoryViewState();
}

class _FavouriteCategoryViewState extends State<FavouriteCategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Favourite Categories',
        iconColor: Colors.white,
        backColor: AppColors.PRIMARY_COLOR,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 2.5),
          itemBuilder: (context, index) {
            return _buildServiceItem();
          },
        ),
      ),
    );
  }


  Widget _buildServiceItem() {
    return InkWell(
      onTap: () => context.push(Routes.SUBCATEGORIES),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          // padding: const EdgeInsets.all(5),
          // margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: UIConst.imagePlaceHolder,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                  child: Container(
                color: Colors.black.withOpacity(.2),
              )),
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Label(
                              text: 'Ride',
                              style: Styles.headerText(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Label(
                              text: '20 Ads',
                              style: Styles.mediumText(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      const Sizer(),
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.LIGHT_GRAY_COLOR,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
