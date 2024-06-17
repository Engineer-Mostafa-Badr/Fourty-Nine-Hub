import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class AdCard extends StatelessWidget {
  final AdModel item;
  const AdCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.ADdetails),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: SquareImage(
                  width: double.infinity,
                  radius: 10,
                  source: NetworkImage(item.images.first))),
          Row(
            children: [
              Expanded(
                child: Label(
                  text: '${item.price} L.E',
                  style: Styles.mediumText(
                      fontWeight: FontWeight.bold,
                      color: AppColors.SECONDARY_COLOR),
                  maxLines: 1,
                ),
              ),
              const Sizer(),
              IconAppButton(
                  size: 20, icon: Icons.favorite_border, onPressed: () {}),
            ],
          ),
          Label(
            text: item.title,
            style: Styles.mediumText(fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          Label(
            text: item.description,
            style: Styles.mediumText(),
            maxLines: 2,
          ),
          Label(
            text: item.address.address,
            style: Styles.mediumText(),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
