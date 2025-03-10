import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../res/style/app_colors.dart';

class RateCar extends StatelessWidget {
  final String image;
  final String rate;
  final bool isPerson;

  const RateCar({
    super.key,
    required this.image,
    required this.rate,
    this.isPerson = false,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          isPerson ? ClipOval(
            child: Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
              child: Image.network(
                image,
                fit: BoxFit.scaleDown,
                width: 50,
                height: 50,
              ),
            ),
          )
              : Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  image,
                  fit: BoxFit.scaleDown,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
          if (rate != 'null') PositionedDirectional(
            top: -3,
            end: isPerson ? -3 : 2,
            child: Container(
              alignment: Alignment.center,
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.cF5F5F5,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 12,
                  ),
                  Text(
                    rate,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

