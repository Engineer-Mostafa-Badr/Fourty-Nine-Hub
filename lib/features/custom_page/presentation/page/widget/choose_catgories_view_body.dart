import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../core/widget/custom_floating_action_button.dart';
import 'page_preview.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../helpers/manage_vibration.dart';

class ChooseCategoriesViwBody extends StatefulWidget {
  const ChooseCategoriesViwBody({super.key});

  @override
  State<ChooseCategoriesViwBody> createState() =>
      _ChooseCategoriesViwBodyState();
}

class _ChooseCategoriesViwBodyState extends State<ChooseCategoriesViwBody> {
  late int _selectedItem;

  @override
  initState() {
    _selectedItem = CacheManager.getInt(CacheManager.selectedCategoryView) ?? 0;
    super.initState();
  }

   List<Widget> _icons({Color? color}) => [
     Icon(
      Icons.list,
      color:color?? Colors.grey,
    ),
     Icon(
      Icons.grid_view,
       color:color?? Colors.grey,
    ),
     Icon(
      Icons.view_carousel,
       color:color?? Colors.grey,
    ),
    Image.asset(
      Assets.grid,
      width: 24,
      height: 24,
      color:color?? Colors.grey,
    ),
  ];
  List<String> _items(BuildContext context) => [
    context.isArabic?'عرض القائمة':'List View',
    context.isArabic?'عرض الصفحة الرئيسية': 'Home View',
    context.isArabic?'عرض شريط التمرير': 'Slider View',
    context.isArabic?'عرض الشبكة': 'Grid View',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            // title: Text(LocaleKeys.chooseCategoryView.localize),
            subtitle: Text(LocaleKeys.youCanChooseOneWayAtLeast.localize,style: Styles.headerText(fontSize: 32),),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items(context).length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Radio<int>(
                    value: index,
                    groupValue: _selectedItem,
                    activeColor: AppColors.getButtonPrimaryColor(context),
                    onChanged: (int? value) {
                      setState(() {
                        _selectedItem = value!;
                      });
                    },
                  ),
                  title: Text(
                    _items(context)[index],
                    style: Styles.mediumText(
                      fontSize: 65.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  trailing: _icons(color: _selectedItem == index ? AppColors.getButtonPrimaryColor(context) : Colors.grey)[index],
                  selected: _selectedItem == index,
                  selectedTileColor: Colors.transparent,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
      ManageVibration.vibrate();
          CacheManager.setInt(CacheManager.selectedCategoryView, _selectedItem);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const PagePreview(
                isButtonsVisible: true,
              ),
            ),
          );
        },
        text: LocaleKeys.next.localize,
      ),
      // floatingActionButton: CustomElevatedButton(
      //   child: Text(
      //     LocaleKeys.next.localize,
      //     style: const TextStyle(color: AppColors.whiteColor),
      //   ),
      //   onPressed: () {
      //     CacheManager.setInt(
      //         CacheManager.selectedCategoryView, _selectedItem);
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(
      //         builder: (context) => const PagePreview(
      //           isButtonsVisible: true,
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}