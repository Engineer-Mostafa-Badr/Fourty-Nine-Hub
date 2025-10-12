import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../domain/entity/star_entity.dart';
import '../../controller/star_cubit/star_cubit.dart';

/// Video rating section widget
/// Shows 5 stars for rating or average rating if already rated
class VideoRatingSection extends StatelessWidget {
  final StarEntity talent;
  final StarCubit starCubit;

  const VideoRatingSection({
    super.key,
    required this.talent,
    required this.starCubit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: starCubit.videoUpdates,
      builder: (context, snapshot) {
        final isRated = talent.isRate;
        final averageRating = talent.averageRating;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isRated)
                // Show rating stars if not rated
                ...List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      starCubit.rateVideo(talent.id, (index + 1).toDouble());
                    },
                    child: Icon(
                      Icons.star_border,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              else
                // Show average rating if rated
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 20,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 4),
                    Text(
                      averageRating.toStringAsFixed(1).toArabicNumbers(context),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
