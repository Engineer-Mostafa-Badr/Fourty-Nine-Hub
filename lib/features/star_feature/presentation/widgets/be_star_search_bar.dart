import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

// class BeStarSearchBar extends StatelessWidget {
//   final TextEditingController controller;

//   const BeStarSearchBar({
//     super.key,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return SliverToBoxAdapter(
//       child: Container(
//         color: context.isDarkMode ? Colors.black : Colors.white,
//         padding: EdgeInsets.all(size.width * 0.04),
//         child: TextField(
//           controller: controller,
//           autofocus: true,
//           textDirection: context.textDirection,
//           textAlign: context.isArabic ? TextAlign.right : TextAlign.left,
//           decoration: InputDecoration(
//             hintText: context.isArabic ? 'البحث في المواهب...' : 'Search talents...',
//             hintTextDirection: context.textDirection,
//             prefixIcon: context.isArabic ? null : const Icon(Icons.search),
//             suffixIcon: context.isArabic ? const Icon(Icons.search) : IconButton(
//               icon: const Icon(Icons.clear),
//               onPressed: () {
//                 ManageVibration.vibrate();
//                 controller.clear();
//               },
//             ),
//             suffixIconConstraints: BoxConstraints(
//               minWidth: size.width * 0.12,
//               minHeight: size.width * 0.12,
//             ),
//             prefixIconConstraints: BoxConstraints(
//               minWidth: size.width * 0.12,
//               minHeight: size.width * 0.12,
//             ),
//             contentPadding: EdgeInsets.symmetric(
//               horizontal: size.width * 0.04,
//               vertical: size.height * 0.015,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(size.width * 0.063),
//               borderSide: const BorderSide(color: Colors.grey),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(size.width * 0.063),
//               borderSide: const BorderSide(color: AppColors.PRIMARY_COLOR),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(size.width * 0.063),
//               borderSide: BorderSide(color: Colors.grey.shade400),
//             ),
//           ),
//           style: TextStyle(
//             fontSize: size.width * 0.04,
//             color: context.isDarkMode ? Colors.white : Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }

//!

class BeStarSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onTalentSearch;
  final Function(String)? onProfileSearch;
  final bool showProfileSearch;

  const BeStarSearchBar({
    super.key,
    required this.controller,
    this.onTalentSearch,
    this.onProfileSearch,
    this.showProfileSearch = false,
  });

  @override
  State<BeStarSearchBar> createState() => _BeStarSearchBarState();
}

class _BeStarSearchBarState extends State<BeStarSearchBar> {
  bool _isSearchingProfiles = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: context.isDarkMode ? Colors.black : Colors.white,
      padding: EdgeInsets.all(size.width * 0.04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search toggle buttons if both search types are available
          if (widget.showProfileSearch) ...[
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearchingProfiles = false;
                      });
                      if (widget.onTalentSearch != null) {
                        widget.onTalentSearch!(widget.controller.text);
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      decoration: BoxDecoration(
                        color: !_isSearchingProfiles
                            ? AppColors.PRIMARY_COLOR
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: !_isSearchingProfiles
                                ? AppColors.PRIMARY_COLOR
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        context.isArabic
                            ? 'البحث في المواهب'
                            : 'Search Talents',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_isSearchingProfiles
                              ? Colors.white
                              : (context.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearchingProfiles = true;
                      });
                      if (widget.onProfileSearch != null) {
                        widget.onProfileSearch!(widget.controller.text);
                      }
                    },
                    child: Container(
                      // padding:
                      //     EdgeInsets.symmetric(vertical: size.height * 0.02),
                      decoration: BoxDecoration(
                        color: _isSearchingProfiles
                            ? AppColors.PRIMARY_COLOR
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: _isSearchingProfiles
                                ? AppColors.PRIMARY_COLOR
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        context.isArabic
                            ? 'البحث في الملفات الشخصية'
                            : 'Search Profiles',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isSearchingProfiles
                              ? Colors.white
                              : (context.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
          ],

          SizedBox(height: size.height * 0.01),

          // Search TextField
          TextField(
            controller: widget.controller,
            autofocus: true,
            textDirection: context.textDirection,
            textAlign: context.isArabic ? TextAlign.right : TextAlign.left,
            onChanged: (value) {
              if (_isSearchingProfiles && widget.onProfileSearch != null) {
                widget.onProfileSearch!(value);
              } else if (widget.onTalentSearch != null) {
                widget.onTalentSearch!(value);
              }
            },
            decoration: InputDecoration(
              hintText: _isSearchingProfiles
                  ? (context.isArabic
                      ? 'البحث في الملفات الشخصية...'
                      : 'Search profiles...')
                  : (context.isArabic
                      ? 'البحث في المواهب...'
                      : 'Search talents...'),
              hintTextDirection: context.textDirection,
              prefixIcon: context.isArabic ? null : const Icon(Icons.search),
              suffixIcon: context.isArabic
                  ? const Icon(Icons.search)
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ManageVibration.vibrate();
                        widget.controller.clear();
                        if (_isSearchingProfiles &&
                            widget.onProfileSearch != null) {
                          widget.onProfileSearch!('');
                        } else if (widget.onTalentSearch != null) {
                          widget.onTalentSearch!('');
                        }
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
        ],
      ),
    );
  }
}
