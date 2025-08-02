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

class GovernoratesView extends StatefulWidget {
  const GovernoratesView({super.key,});
  @override
  State<GovernoratesView> createState() => _GovernoratesViewState();

}

class _GovernoratesViewState extends State<GovernoratesView> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    List<String>governorate=['Cairo','Giza','Alexandria','Dakahlia','Qena','Siwa','Herghada','Fayoum','Minya','Beheira','Ismailia','Luxor','Aswan'];

    return SharedScaffold(
      mainCategoryId: 1,
      body: Padding(
            padding:  EdgeInsets.all(16.0.w),
            child: Column(
              children: [
                PageNameRow(title:LocaleKeys.governorate.localize ,),
                const Sizer(),
                FormTextField(
                  height: 88.h,
                  prefix:const Icon(Icons.search),
                  hint: LocaleKeys.search.localize,
                  style: Styles.mediumText(fontWeight: FontWeight.w600,fontSize: 32),
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  borderColor: Colors.black,
                  borderRadius: BorderRadius.circular(15),

                ),
                const Sizer(height: 30,),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: false,
                    controller: _scrollController,
                    separatorBuilder: (context, index) => const Sizer(height: 30,),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) =>Label(text: governorate[index],style: Styles.headerText(fontWeight: FontWeight.w600),),
                    itemCount:governorate.length,
                  ),
                )
              ],
            ),
          )

    );
  }
}
