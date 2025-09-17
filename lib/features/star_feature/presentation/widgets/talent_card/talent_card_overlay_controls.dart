// lib/features/star_feature/presentation/widgets/talent_card/talent_card_overlay_controls.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';

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
class OptionsAndRatingSection extends StatefulWidget {
  final StarEntity talent;
  final StarCubit cubit;
  final VoidCallback onMoreOptionsTap;

  const OptionsAndRatingSection({
    super.key,
    required this.talent,
    required this.cubit,
    required this.onMoreOptionsTap,
  });

  @override
  State<OptionsAndRatingSection> createState() =>
      _OptionsAndRatingSectionState();
}

class _OptionsAndRatingSectionState extends State<OptionsAndRatingSection> {
  int? _selectedRating;
  bool _isAnimating = false;
  bool _shouldFadeOut = false;
  bool _showFinalRating = false;

  void _onStarTap(int rating) async {
    if (_isAnimating) return;

    setState(() {
      _selectedRating = rating;
      _isAnimating = true;
      _shouldFadeOut = false;
    });

    ManageVibration.vibrate();

    // Wait for 300ms to show the selected stars
    await Future.delayed(Duration(milliseconds: 300));

    if (mounted) {
      // Start fade out animation
      setState(() {
        _shouldFadeOut = true;
      });

      // Wait for fade out to complete (600ms)
      await Future.delayed(Duration(milliseconds: 600));

      if (mounted) {
        // Update the rating and show snack bar
        widget.cubit.updateRating(widget.talent.id, rating);

        // Show final rating display
        setState(() {
          _showFinalRating = true;
          _isAnimating = false;
        });
      }
    }
  }

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
            onPressed: widget.onMoreOptionsTap,
            icon: Icon(
              Icons.more_vert,
              color: context.isDarkMode ? Colors.white : Colors.black,
              size: 20,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        SizedBox(height: 16),

        // Stars rating - show average rating or allow rating if not rated yet
        if (!widget.talent.isRate && !_isAnimating && !_showFinalRating)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(
              5,
              (starIndex) => GestureDetector(
                onTap: () => _onStarTap(starIndex + 1),
                child: Icon(
                  Icons.star_border,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ),
            ),
          ),

        // Show average rating if video has been rated
        if (widget.talent.isRate && widget.talent.averageRating > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.talent.averageRating
                    .toStringAsFixed(1)
                    .toArabicNumbers(context),
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 16,
              ),
            ],
          ),

        // Animated stars during rating selection
        if (_selectedRating != null && _isAnimating)
          AnimatedOpacity(
            opacity: _shouldFadeOut ? 0.0 : 1.0,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                5,
                (starIndex) => Icon(
                  starIndex < _selectedRating! ? Icons.star : Icons.star_border,
                  color: starIndex < _selectedRating!
                      ? Colors.amber
                      : Colors.grey[400],
                  size: 16,
                ),
              ),
            ),
          ),

        // Final rating display - show single star with rating number
        // if (_showFinalRating && _selectedRating != null)
        //   Row(
        //     mainAxisSize: MainAxisSize.min,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Text(
        //         _selectedRating.toString().toArabicNumbers(context),
        //         style: TextStyle(
        //           color: context.isDarkMode ? Colors.white : Colors.black,
        //           fontSize: 12,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       SizedBox(width: 2),
        //       Icon(
        //         Icons.star,
        //         color: Colors.amber,
        //         size: 16,
        //       ),
        //     ],
        //   ),
      ],
    );
  }
}
