import 'package:flutter/material.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../domain/entity/star_entity.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../../pages/video_details_view.dart';

class TalentMyItem extends StatelessWidget {
  final StarEntity talent;
  final StarCubit cubit;
  final int index;
  final Function(StarEntity, String)? onVideoTap;

  const TalentMyItem({
    super.key,
    required this.talent,
    required this.cubit,
    required this.index,
    this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaUrl =
        talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';

    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        if (onVideoTap != null) {
          onVideoTap!(talent, mediaUrl);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoDetailsView(
                talent: talent,
                mediaUrl: mediaUrl,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 140,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    talent.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${talent.user.firstName} ${talent.user.lastName}",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
