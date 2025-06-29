import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class UseSoundBody extends StatelessWidget {
  const UseSoundBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 44.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "contains: amr diab",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          context.isArabic ? "عمرو دياب " : "Amr Diab",
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 6.h),
                          width: 22.w,
                          height: 22.w,
                          decoration: const BoxDecoration(
                            color: Color(0xff20D5EC),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(Assets.checkIcon),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Icon(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.SECONDARY_COLOR,
                          Icons.add,
                          size: 20,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          context.isArabic ? "متابعة" : "Follow",
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.SECONDARY_COLOR,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.pauseIcon,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "36s",
                    style: TextStyle(fontSize: 28.sp),
                  ),
                  SizedBox(width: 15.w),
                  Image.asset(Assets.linePng),
                  SizedBox(width: 15.w),
                  Text(
                    context.isArabic
                        ? "الصوت الأصلي بواسطة:"
                        : "original sound by: ",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Amr Diab",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 90.w),
                  Text(
                    context.isArabic ? "126" : "126",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: context.isDarkMode ? Colors.white : Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      context.isArabic ? "المنشورات" : "posts",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: context.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: SvgPicture.asset(Assets.addFavIcon),
            label: Text(
              context.isArabic ? "اضافة للمفضلة" : "Add to favourites",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.black,
              elevation: 0,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 1,
            ),
            itemCount: 50,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      'https://randomuser.me/api/portraits/men/${index + 10}.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  if (index == 0)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(
                            0.5), // غير اللون والـ opacity زي ما تحب
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  if (index == 0)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Original",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
