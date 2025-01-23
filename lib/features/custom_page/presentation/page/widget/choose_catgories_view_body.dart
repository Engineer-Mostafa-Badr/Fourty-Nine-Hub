import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/page_preview.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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

  final List<Icon> _icons = const [
    Icon(
      Icons.list,
    ),
    Icon(
      Icons.grid_view,
    ),
    Icon(
      Icons.view_carousel,
    ),
  ];
  final List<String> _items = [
    'List View',
    'Gride View',
    'Slider View',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            ListTile(
              title: Text('اختر طريقه عرض القسام الرئيسيه للخدمات'),
              subtitle: Text('يمكنك اختيار بحد أقصى طريقه عرض واحده'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Radio<int>(
                      value: index,
                      groupValue: _selectedItem,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedItem = value!;
                        });
                      },
                    ),
                    title: Text(
                      _items[index],
                      style: Styles.mediumText(
                        fontSize: 65.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    trailing: _icons[index],
                    selected: _selectedItem == index,
                    selectedTileColor: Colors.transparent,
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: CustomElevatedButton(
          child: Text(
            LocaleKeys.next.localize,
            style: const TextStyle(color: AppColors.whiteColor),
          ),
          onPressed: () {
            CacheManager.setInt(
                CacheManager.selectedCategoryView, _selectedItem);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const PagePreview(
                  isButtonsVisible: true,
                ),
              ),
            );
          },
        ));
  }
}
