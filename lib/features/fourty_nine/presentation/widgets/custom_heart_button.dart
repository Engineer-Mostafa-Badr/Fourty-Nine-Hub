import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/widgets/overlay_circular_menu.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/assets/assets.dart';

class CustomHeartButton extends StatelessWidget {
  const CustomHeartButton({super.key});

  Widget _buildMenuItem(String svgPath) {
    return CircleAvatar(
      backgroundColor: const Color(0xffD9D9D9),
      radius: 20.0,
      child: Center(child: SvgPicture.asset(svgPath)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverlayCircularMenu(
      mainIcon: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.favorite, color: Colors.red),
      ),
      radius: 60,
      menuItems: [
        CircularMenuItem(
          icon: _buildMenuItem(
            Assets.heartIcon,
          ),
          onPressed: () {
            log('----------------------- Heart -----------------------');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم النقر على الصفحة الرئيسية')),
            );
          },
        ),
        CircularMenuItem(
          icon: _buildMenuItem(
            Assets.adIcon,
          ),
          onPressed: () {
            log('----------------------- Ad -----------------------');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم النقر على الصفحة الرئيسية')),
            );
          },
        ),
        CircularMenuItem(
          icon: _buildMenuItem(
            Assets.starRedIcon,
          ),
          onPressed: () {
            log('----------------------- Star -----------------------');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم النقر على الصفحة الرئيسية')),
            );
          },
        ),
        CircularMenuItem(
          icon: _buildMenuItem(
            Assets.speakerIcon,
          ),
          onPressed: () {
            log('----------------------- Speaker -----------------------');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم النقر على الصفحة الرئيسية')),
            );
          },
        ),
        CircularMenuItem(
          icon: _buildMenuItem(
            Assets.starYellowIcon,
          ),
          onPressed: () {
            log('----------------------- Star -----------------------');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم النقر على الصفحة الرئيسية')),
            );
          },
        ),
        CircularMenuItem(
          icon: _buildMenuItem(
            Assets.saveIcon,
          ),
          onPressed: () {
            log('----------------------- Save -----------------------');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم النقر على الصفحة الرئيسية')),
            );
          },
        ),
      ],
    );
    // final circularMenu = CircularMenu(items: [
    //   CircularMenuItem(
    //       icon: Icons.home,
    //       onTap: () {
    //         // callback
    //       }),
    //   CircularMenuItem(
    //       icon: Icons.search,
    //       onTap: () {
    //         //callback
    //       }),
    //   CircularMenuItem(
    //       icon: Icons.settings,
    //       onTap: () {
    //         //callback
    //       }),
    //   CircularMenuItem(
    //       icon: Icons.star,
    //       onTap: () {
    //         //callback
    //       }),
    //   CircularMenuItem(
    //       icon: Icons.pages,
    //       onTap: () {
    //         //callback
    //       }),
    // ]);
    // return CircularMenu(
    //     backgroundWidget: Container(
    //       height: 40,
    //       width: 40,
    //       decoration: const BoxDecoration(
    //         color: const Color(0xFFD9D9D9),
    //         shape: BoxShape.circle,
    //       ),
    //     ),
    //     // radius: 100,
    //     // toggleButtonColor: Colors.pink,
    //     toggleButtonMargin: 10.0,
    //     toggleButtonPadding: 10.0,
    //     toggleButtonSize: 40.0,
    //     items: [
    //       CircularMenuItem(
    //           icon: Icons.home,
    //           onTap: () {
    //             // callback
    //           }),
    //       CircularMenuItem(
    //           icon: Icons.search,
    //           onTap: () {
    //             //callback
    //           }),
    //       CircularMenuItem(
    //           icon: Icons.settings,
    //           onTap: () {
    //             //callback
    //           }),
    //       CircularMenuItem(
    //           icon: Icons.star,
    //           onTap: () {
    //             //callback
    //           }),
    //       CircularMenuItem(
    //           icon: Icons.pages,
    //           onTap: () {
    //             //callback
    //           }),
    //     ]);
    // return InkWell(
    //   onTap: () {
    //     circularMenu.
    //   },
    //   child: Container(
    //     height: 40,
    //     width: 40,
    //     decoration: const BoxDecoration(
    //       color: const Color(0xFFD9D9D9),
    //       shape: BoxShape.circle,
    //     ),
    //     child: const Icon(Icons.favorite, color: Colors.red),
    //   ),
    // );
  }
}

// class CircularMenu extends StatefulWidget {
//   final Widget mainIcon;
//   final List<Widget> menuItems;
//   final double radius;
//   final Color overlayColor;
//
//   const CircularMenu({
//     Key? key,
//     required this.mainIcon,
//     required this.menuItems,
//     this.radius = 100.0,
//     this.overlayColor = Colors.black54,
//   }) : super(key: key);
//
//   @override
//   _CircularMenuState createState() => _CircularMenuState();
// }
//
// class _CircularMenuState extends State<CircularMenu> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool _isOpen = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _toggleMenu() {
//     setState(() {
//       _isOpen = !_isOpen;
//       if (_isOpen) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // الطبقة الخلفية المظللة التي تظهر عند فتح القائمة
//         if (_isOpen)
//           Positioned.fill(
//             child: GestureDetector(
//               onTap: _toggleMenu,
//               child: AnimatedOpacity(
//                 opacity: _isOpen ? 1.0 : 0.0,
//                 duration: const Duration(milliseconds: 300),
//                 child: Container(
//                   color: widget.overlayColor,
//                 ),
//               ),
//             ),
//           ),
//
//         // الأيقونات الدائرية
//         Positioned(
//           right: 16.0,
//           bottom: 16.0,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               // الأيقونات الفرعية
//               AnimatedBuilder(
//                 animation: _animation,
//                 builder: (context, child) {
//                   return Stack(
//                     alignment: Alignment.center,
//                     children: List.generate(widget.menuItems.length, (index) {
//                       // حساب موقع كل أيقونة بناءً على زاوية معينة
//                       final double angle = (2 * pi / widget.menuItems.length) * index;
//
//                       // حساب الموقع باستخدام دوال الزاوية
//                       final double x = widget.radius * cos(angle);
//                       final double y = widget.radius * sin(angle);
//
//                       return Transform.translate(
//                         offset: Offset(x, y) * _animation.value,
//                         child: Transform.scale(
//                           scale: _animation.value,
//                           child: Opacity(
//                             opacity: _animation.value,
//                             child: widget.menuItems[index],
//                           ),
//                         ),
//                       );
//                     }),
//                   );
//                 },
//               ),
//
//               // الأيقونة الرئيسية
//               GestureDetector(
//                 onTap: _toggleMenu,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 5.0,
//                         spreadRadius: 1.0,
//                       ),
//                     ],
//                   ),
//                   child: widget.mainIcon,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
