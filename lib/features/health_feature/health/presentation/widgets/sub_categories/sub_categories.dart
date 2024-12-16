import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_category_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/localization/locale_keys.g.dart';

class HealthSubCategories extends StatefulWidget {
  const HealthSubCategories({
    super.key,
  });

  @override
  State<HealthSubCategories> createState() => _HealthSubCategoriesState();
}

class _HealthSubCategoriesState extends State<HealthSubCategories> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
        return SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state.subCategories==null?
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Label(
                  text: LocaleKeys.specialities.localize,
                  style: Styles.headerText(),
                ),
              ) :state.subCategories==[]?
              const SizedBox.shrink():Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Label(
                    text: context.isArabic?'التخصصات':'Specialities',
                    style: Styles.headerText(),
                  ),
                  ClickableWidget(
                    onTap: (){
                      _scrollController?.animateTo(
                        (_scrollController?.position.pixels??0) + 0.8.sw,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                      );
                    },
                      child: Row(
                        children: [
                          Label(
                            text: context.isArabic?'مشاهدة المزيد':'See More',
                            style: Styles.mediumText(decoration: TextDecoration.underline,color: AppColors.PRIMARY_COLOR_DARK),),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.PRIMARY_COLOR_DARK,
                            size: 0.06.sw,
                          ),
                        ],
                      ),
              ),]),
              const Sizer(),
              Expanded(
                child: (state.subCategories!=null&&state.subCategories!=[])?ListView.separated(
                  controller: _scrollController,
                  separatorBuilder: (context, index) => const Sizer(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => HealthSubCategoryCard(
                      subCategory: state.subCategories![index]),
                  itemCount: state.subCategories?.length??0,
                ):state.subCategories==null?Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: ListView.separated(
                    controller: _scrollController,
                    separatorBuilder: (context, index) => const Sizer(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: AppColors.AUTH_CONTAINER_COLOR,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    itemCount: 3,
                  ),
                ):const SizedBox.shrink(),
              ),
            ],
          ),
        );

    });
  }
}
