
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SelectContactToShareCart extends StatelessWidget {
  

  final Contact contact;

  const SelectContactToShareCart({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: AppColors.BACKGROUND_COLOR,
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              UIConst.profilePlaceHolder,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.mediumText(fontWeight: FontWeight.w600),
                ),
                Text(
                  "A bird in the hand is better than two on the tree.",
                  overflow: TextOverflow.ellipsis,
                  style:
                      Styles.smallText(color: AppColors.LIGHT_GRAY_COLOR2),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
