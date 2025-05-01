import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostsGrid extends StatelessWidget {
  const PostsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GridView.builder( padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 14,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 2.0, // spacing between rows
          crossAxisSpacing: 2.0, // spacing between columns
        ),
        itemBuilder: (context, index) => Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/spotlight_profil_reel.png',
              fit: BoxFit.cover,
            ),
            if (index == 2 || index == 4)
              Positioned(
                  right: 5.h,
                  top: 15.h,
                  child: Image.asset(
                      'assets/icons/userReelLight.png')),
            if (index == 3 || index == 5)
              Positioned(
                  right: 5.h,
                  top: 15.h,
                  child: Image.asset(
                      'assets/icons/postLight.png')),
          ],
        ),
      ),
    );
  }
}
