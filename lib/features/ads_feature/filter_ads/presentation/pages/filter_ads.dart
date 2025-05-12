import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/widgets/custom_header_form.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/widgets/filter_ad_dynamic_inputs.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class FilterAdsView extends StatefulWidget {
  final CategorizationEntity categorization;

  const FilterAdsView({super.key, required this.categorization});

  @override
  State<FilterAdsView> createState() => _FilterAdsViewState();
}

class _FilterAdsViewState extends State<FilterAdsView> {
  @override
  void initState() {
    context.read<CreateAdCubit>().loadData(
        subCategoryId: widget.categorization.fromMarriage == false
            ? widget.categorization.mainCategory.id
            : widget.categorization.subCategory.id,
        fromMarriage: widget.categorization.fromMarriage ?? false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAdCubit, CreateAdState>(
        listener: (context, state) {
      if (state.isError) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure!,
            context,
          ),
        );
      }
    }, builder: (context, state) {
      final controller = context.read<CreateAdCubit>();
      return CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: BackAppBar(label: LocaleKeys.filter.localize),
        ),
        body: Form(
          key: controller.formState,
          child: BlocBuilder<CreateAdCubit, CreateAdState>(
              builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  // shrinkWrap: true,
                  // padding: const EdgeInsets.all(16.0),
                  children: [
                    CustomHeaderForm(
                      categorization: widget.categorization,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(
                      thickness: 2,
                      height: 0,
                      color: Color(0xFFD9D9D9),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.filterAdProperties?.length ?? 0,
                      itemBuilder: (context, index) {
                        final property = state.filterAdProperties![index];
                        return FilterAdDynamicInputWidget(
                          property: property,
                          onChanged: (SelectionEntity v) =>
                              controller.onChanged(v: v, index: index),
                          onTextChanged: (String v, bool from, String type) =>
                              controller.onTextChanged(
                                  v: v,
                                  index: index,
                                  isNumber: property.type == 'number',
                                  from: from,
                                  type: type),
                        );
                      },
                      // separatorBuilder: (context, index) => const Sizer(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ClickableWidget(
                        onTap: () {
                          controller.filterAds(
                              categorize: widget.categorization,
                              context: context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: ShapeDecoration(
                            color: AppColors.PRIMARY_COLOR,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          // decoration: BoxDecoration(
                          //   color: AppColors.PRIMARY_COLOR,
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          child: Label(
                            text: LocaleKeys.filter.localize,
                            style: Styles.headerText(color: Colors.white),
                          ),
                        )),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
