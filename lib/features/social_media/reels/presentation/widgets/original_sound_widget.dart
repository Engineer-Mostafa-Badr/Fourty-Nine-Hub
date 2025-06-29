import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class OriginalSoundWidget extends StatelessWidget {
  const OriginalSoundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              Assets.songEx, // حط مسار الصورة بتاعتك هنا
              width: 58,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Part 826 | #Gdxhxfngjcjiubhfgdxf#Bxcbxf Dhfgdxf#Bxcbxf #Cgh Dzgvbdbb',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color:
                        context.isDarkMode ? Colors.white : Color(0xff000000),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '00:30',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.isArabic ? '7.9M مشاهدات' : '7.9M Views',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
