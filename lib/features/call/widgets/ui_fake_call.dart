import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/call/widgets/build_app_bar.dart';
import 'package:fourtyninehub/features/call/widgets/build_bottom_btns.dart';

class UIFakeCall extends StatelessWidget {
  final UserModel receiver;
  final dynamic onMorePressed;
  const UIFakeCall({super.key, required this.receiver, required this.onMorePressed});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        'assets/images/whatsapp_bacground.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BuildAppBar(
            receiver: receiver,
          ),
          // Top section with contact details

          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(receiver.profilePicture ??
                    'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
              ),
            ),
          ),

          // Bottom call control buttons
          BuildBottomBtns(
          currentContext: context,
            onMorePressed: onMorePressed,
          ),
        ],
      ),
    ]);
  }
}
