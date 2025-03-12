
import 'package:flutter/material.dart';


import '../../../../../res/style/app_colors.dart';


class CustomRideButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;
  final bool isRed;

  const CustomRideButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isRed
                  ? [
                AppColors.cF33D49,
                AppColors.cC0303A,
                AppColors.cA72A32,
                AppColors.c9A272E,
                AppColors.c93252C,
                AppColors.c90242B,
              ]
                  : [
                AppColors.c0B1035,
                AppColors.c161F68,
                AppColors.c1B2781,
                AppColors.c1E2B8E,
                AppColors.c1F2D95,
                AppColors.c0B1035,
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
        ),

        if (isDisabled)
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        Positioned.fill(
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isDisabled ? Colors.grey[400] : Colors.white,
                shadows: isDisabled
                    ? [
                  const Shadow(
                    color: Color(0xFFFFFFFF),
                    offset: Offset(0, 1),
                    blurRadius: 4,
                  ),
                  const Shadow(
                    color: Color(0xFFD9D9D9),
                    offset: Offset(1, 0),
                    blurRadius: 4,

                  ),
                  const Shadow(
                    color: Color(0xFFFFFFFF),
                    offset: Offset(0, 0),
                    blurRadius: 4,
                  ),
                  const Shadow(
                    color: Color(0xFFD9D9D9),
                    offset: Offset(0, 0),
                    blurRadius: 4,

                  ),
                  const Shadow(
                    color: Color(0xFF3C3C43),
                    offset: Offset(0, 0),
                    blurRadius: 4,

                  ),
                  const Shadow(
                    color: Color(0xFF818181),
                    offset: Offset(0, 0),
                    blurRadius: 4,

                  ),
                ] :  [
                  const Shadow(
                    color: Color(0xFFFFFFFF),
                    offset: Offset(0, 1),
                    blurRadius: 4,
                  ),
                  const Shadow(
                    color: Color(0xFFD9D9D9),
                    offset: Offset(1, 0),
                    blurRadius: 4,

                  ),
                  const Shadow(
                    color: Color(0xFFFFFFFF),
                    offset: Offset(0, 0),
                    blurRadius: 4,
                  ),
                  const Shadow(
                    color: Color(0xFFD9D9D9),
                    offset: Offset(0, 0),
                    blurRadius: 4,

                  ),
                  const Shadow(
                    color: Color(0xFF3C3C43),
                    offset: Offset(0, 0),
                    blurRadius: 4,

                  ),
                  const Shadow(
                    color: Color(0xFF818181),
                    offset: Offset(0, 0),
                    blurRadius: 4,

                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class TestButtonRide extends StatelessWidget {
//   const TestButtonRide({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const SizedBox(
//             height: 200,
//           ),
//           const LoadingTripWidget(),
//           Row(
//             children: [
//               Expanded(
//                 child: CustomRideButton(
//                   text: "Ride Mode",
//                   onPressed: () {},
//                   isRed: true,
//                   isDisabled: true,
//                 ),
//               ),
//               Expanded(
//                 child: CustomRideButton(
//                   text: "Ride Mode",
//                   onPressed: () {},
//                   isRed: true,
//                 ),
//               ),
//             ],
//           ),
//           CustomRideButton(
//             text: "Car/Truck Register",
//             onPressed: () {},
//             // isDisabled: true,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//

