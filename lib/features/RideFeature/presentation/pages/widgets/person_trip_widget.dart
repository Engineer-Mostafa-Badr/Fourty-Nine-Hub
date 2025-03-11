import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../res/style/app_colors.dart';

class PersonTripWidget extends StatelessWidget {
  final String image;
  final String name;
  final String? rate;

  const PersonTripWidget({
    super.key,
    required this.image,
    required this.name,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              ClipOval(
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: Image.asset(
                    image,
                    fit: BoxFit.scaleDown,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              if (rate != 'null' && rate != null) PositionedDirectional(
                top: -3,
                end: -3,
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
                        rate!,
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
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 70,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
