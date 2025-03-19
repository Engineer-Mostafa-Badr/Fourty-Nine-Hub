import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';

class RouteButtonWidget extends StatelessWidget {
  const RouteButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Color(0xff0B1035),
            ),
            child: const Text(
              "+ Create Route",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            context.push(Routes.captainShareInfoScreen);
          },
          child: Container(
            height: 35,
            width: 35,
            decoration: const BoxDecoration(
              color: Color(0xff0B1035),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.question_mark,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
