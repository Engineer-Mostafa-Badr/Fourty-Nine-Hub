// lib/features/star_feature/presentation/widgets/talent_card/talent_card_overlay_controls.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../helpers/manage_vibration.dart';
import '../../../domain/entity/star_entity.dart';
import '../../controller/star_cubit/star_cubit.dart';


class TalentCardOverlayControls extends StatelessWidget {
  final StarEntity talent;
  final StarCubit cubit;
  final bool isPlaying;

  const TalentCardOverlayControls({
    super.key,
    required this.talent,
    required this.cubit,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        final isFavorite = cubit.isFavorite(talent.id);

        return Positioned(
          top: 8,
          left: 8,
          child: GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              cubit.toggleFavorite(talent.id);
            },
            child: Container(
              decoration: BoxDecoration(
                color: isPlaying
                    ? Colors.black12
                    : Color(0xffD9D9D9).withValues(alpha: .5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                  color: Color(0xffFF0000),
                  size: 25,
                ),
                onPressed: () {
                  ManageVibration.vibrate();
                  cubit.toggleFavorite(talent.id);
                },
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Private component for options and rating
class OptionsAndRatingSection extends StatelessWidget {
  final StarEntity talent;
  final StarCubit cubit;
  final VoidCallback onMoreOptionsTap;

  const OptionsAndRatingSection({
    required this.talent,
    required this.cubit,
    required this.onMoreOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // More options button
        SizedBox(
          width: 28,
          height: 28,
          child: IconButton(
            onPressed: onMoreOptionsTap,
            icon: Icon(
              Icons.more_vert,
              color: context.isDarkMode ? Colors.white : Colors.black,
              size: 20,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        SizedBox(height: 16),

        // Stars rating
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: List.generate(
            5,
            (starIndex) => GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                cubit.updateRating(talent.id, starIndex + 1);
              },
              child: Icon(
                starIndex < talent.averageRating
                    ? Icons.star
                    : Icons.star_border,
                color: starIndex < talent.averageRating
                    ? Colors.amber
                    : Colors.grey[400],
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
