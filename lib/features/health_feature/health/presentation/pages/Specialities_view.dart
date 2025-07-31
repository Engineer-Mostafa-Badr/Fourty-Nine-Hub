import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/page_name_row.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/specialities_search/Specialities_search_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SpecialitiesView extends StatefulWidget {
  const SpecialitiesView({super.key,});
  @override
  State<SpecialitiesView> createState() => _SpecialitiesViewState();

}

class _SpecialitiesViewState extends State<SpecialitiesView> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: BlocBuilder<HealthCubit, HealthState>(
  builder: (context, state) {
    return Padding(
        padding:  EdgeInsets.all(16.0.w),
        child: Column(
          children: [
            PageNameRow(title:LocaleKeys.speciality.localize ,),
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
            const Sizer(),
            Expanded(
              child: ListView.separated(
                shrinkWrap: false,
                controller: _scrollController,
                separatorBuilder: (context, index) => const Sizer(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) =>SpecialitiesSearchCard(subCategory: state.subCategories![index]),
                itemCount:
                state.subCategories?.length ?? 0,
              ),
            )
          ],
        ),
      );
  },
),
    );
  }
}
