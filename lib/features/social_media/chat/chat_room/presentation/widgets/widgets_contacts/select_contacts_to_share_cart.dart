import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../domain/entities/message_shared_contacts_entity.dart';

class SelectContactToShareCart extends StatefulWidget {
  final MessageSharedContactsEntity contact;

  const SelectContactToShareCart({super.key, required this.contact});

  @override
  State<SelectContactToShareCart> createState() =>
      _SelectContactToShareCartState();
}

class _SelectContactToShareCartState extends State<SelectContactToShareCart> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        setState(() {
          isSelected = !isSelected;
          if (isSelected) {
            context
                .read<ChatRoomCubit>()
                .addToSelectedContacts(contact: widget.contact);
          } else {
            context
                .read<ChatRoomCubit>()
                .removeFromSelectedContacts(contact: widget.contact);
          }
        })
      },
      splashColor:
          AppColors.PRIMARY_COLOR.withOpacity(0.3), // Ripple effect color
      highlightColor:
          AppColors.LIGHT_GRAY_COLOR.withOpacity(0.2), // Highlight color on tap
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200), // Smooth transition when tapped
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: isSelected
            ? AppColors.PRIMARY_COLOR.withOpacity(0.1)
            : context.isDarkMode
                ? AppColors.QUANTITY_COLOR
                : AppColors.BACKGROUND_COLOR, // Change background when selected
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
              width: 8,
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.contact.name,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mediumText(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      // "A bird in the hand is better than two on the tree.",
                      widget.contact.phoneNumber,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Styles.smallText(color: AppColors.LIGHT_GRAY_COLOR2),
                    )
                  ],
                ),
              ),
            ),
            isSelected
                ? const CircleAvatar(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    radius: 12,
                    child: Icon(
                      Icons.check,
                      color: AppColors.BACKGROUND_COLOR,
                      size: 14,
                    ),
                  )
                : Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: AppColors.PRIMARY_COLOR,
                        )),
                  ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
