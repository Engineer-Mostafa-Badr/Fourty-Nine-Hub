import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/main_category_entity.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';

class MainCategoryCard extends StatelessWidget {
  final MainCategoryEntity mainCategory;
  final bool isList;
  const MainCategoryCard(
      {super.key, required this.mainCategory, this.isList = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.goNamed(Routes.SUBCATEGORIES, extra: mainCategory.id),
      child: isList
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: mainCategory.image,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if (mainCategory.name != null)
                                    Label(
                                      text: mainCategory.name ?? "",
                                      style: Styles.headerText(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  Label(
                                    text: '${mainCategory.total} Ads',
                                    style:
                                        Styles.mediumText(color: Colors.white),
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
            )
          : Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  backgroundImage: NetworkImage(mainCategory.image),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: mainCategory.name,
                          style:
                              Styles.mediumText(fontWeight: FontWeight.w700)),
                      TextSpan(
                          text: ' /${mainCategory.total} Ads',
                          style: Styles.smallText(
                              fontWeight: FontWeight.w700, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
