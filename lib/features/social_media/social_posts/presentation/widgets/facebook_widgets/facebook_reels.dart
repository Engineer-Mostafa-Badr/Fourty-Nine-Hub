import 'package:flutter/material.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../instagram/presentation/widgets/insta_reel_card.dart';
import '../../../../reels/data/models/new_reels_model.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class FacebookReels extends StatefulWidget {
  const FacebookReels({super.key, required this.reels});
  final List<Reel> reels;

  @override
  State<FacebookReels> createState() => _FacebookReelsState();
}

class _FacebookReelsState extends State<FacebookReels> {
  final ScrollController _scrollController = ScrollController();
  final int _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.getFindFillColor(context),
        border: Border(bottom: BorderSide(color: AppColors.getFindFillColor(context), width: 6)),
      ),
      padding: const EdgeInsetsDirectional.only(start: 10, bottom: 16, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.isArabic?'ريلز':'Reels',
            style: Styles.headerText(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: widget.reels.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 180,
                  width: 104,
                  child: InstagramReelCard(
                    item: widget.reels[index],
                    playVideo: index == _currentIndex,
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10),
            ),
          ),
        ],
      ),
    );
  }
}
