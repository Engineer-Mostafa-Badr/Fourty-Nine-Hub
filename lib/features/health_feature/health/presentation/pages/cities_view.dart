import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/page_name_row.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CitiesView extends StatefulWidget {
  const CitiesView({
    super.key,
  });

  @override
  State<CitiesView> createState() => _CitiesViewState();
}

class _CitiesViewState extends State<CitiesView> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    List<String> cities = [
      'Sixth of October',
      'Giza',
      'Cheikh Zayed',
      'Hawamdiyah',
      'Saf',
      'Atfih',
      'Al Ayat',
      'Al-Bawaiti',
      'Manshiyet Al Qanater',
      'Oaseem',
      'Kerdasa',
      'Abu Nomros',
    ];

    return SharedScaffold(
        mainCategoryId: 1,
        body: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              PageNameRow(title:LocaleKeys.city.localize ,),
              const Sizer(),
              FormTextField(
                height: 88.h,
                prefix: const Icon(Icons.search),
                hint: LocaleKeys.search.localize,
                style: Styles.mediumText(
                    fontWeight: FontWeight.w600, fontSize: 32),
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                borderColor: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              const Sizer(
                height: 30,
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: false,
                  controller: _scrollController,
                  separatorBuilder: (context, index) => const Sizer(
                    height: 30,
                  ),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => Label(
                    text: cities[index],
                    style: Styles.headerText(fontWeight: FontWeight.w600),
                  ),
                  itemCount: cities.length,
                ),
              )
            ],
          ),
        ));
  }
}
