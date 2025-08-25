import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class BeStarSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const BeStarSearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Container(
        color: context.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.all(size.width * 0.04),
        child: TextField(
          controller: controller,
          autofocus: true,
          textDirection: context.textDirection,
          textAlign: context.isArabic ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            hintText: context.isArabic ? 'البحث في المواهب...' : 'Search talents...',
            hintTextDirection: context.textDirection,
            prefixIcon: context.isArabic ? null : const Icon(Icons.search),
            suffixIcon: context.isArabic ? const Icon(Icons.search) : IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.clear();
              },
            ),
            suffixIconConstraints: BoxConstraints(
              minWidth: size.width * 0.12,
              minHeight: size.width * 0.12,
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: size.width * 0.12,
              minHeight: size.width * 0.12,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.015,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(size.width * 0.063),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(size.width * 0.063),
              borderSide: const BorderSide(color: AppColors.PRIMARY_COLOR),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(size.width * 0.063),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          style: TextStyle(
            fontSize: size.width * 0.04,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}