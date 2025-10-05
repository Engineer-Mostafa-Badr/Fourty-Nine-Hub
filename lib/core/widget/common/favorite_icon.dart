import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({super.key, required this.isFavourite, required this.onPressedFavorite});
  final bool isFavourite;
  final Function() onPressedFavorite;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(1, 1),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: IconAppButton(
        size: 32,
        icon: isFavourite == false
            ? Icons.favorite_border
            : Icons.favorite,
        // shadows: [
        //   Shadow(
        //     color: Colors.black,
        //     offset: const Offset(1, 1),
        //     blurRadius: 10,
        //   ),
        // ],
        color: isFavourite == false?AppColors.whiteColor:AppColors.SECONDARY_COLOR,
        onPressed: onPressedFavorite,
      ),
    );
  }
}
