import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/widgets/filter_ad_dynamic_inputs.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class FilterAdsView extends StatefulWidget {
  final CategorizationEntity categorization;
  const FilterAdsView({super.key, required this.categorization});

  @override
  State<FilterAdsView> createState() => _FilterAdsViewState();
}

class _FilterAdsViewState extends State<FilterAdsView> {
  @override
  void initState() {
    context
        .read<CreateAdCubit>()
        .loadData(subCategoryId: widget.categorization.mainCategory.id);
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
      return Scaffold(
        appBar: BackAppBar(label: LocaleKeys.filter.localize),
        body: Form(
          key: controller.formState,
          child: BlocBuilder<CreateAdCubit, CreateAdState>(
              builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              children: [
                Row(
                  children: [
                    SquareImage(
                      width: kToolbarHeight * .8,
                      height: kToolbarHeight * .8,
                      radius: 10,
                      url: widget.categorization.subCategory.image,
                    ),
                    const Sizer(),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          text: context.isArabic
                              ? widget.categorization.subCategory.nameAr
                              : widget.categorization.subCategory.nameEn,
                          style: Styles.mediumText(fontWeight: FontWeight.bold),
                        ),
                        Label(
                            text:
                                widget.categorization.mainCategory.name ?? ""),
                      ],
                    )),
                  ],
                ),
                const Divider(),
                const Sizer(),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
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
                  separatorBuilder: (context, index) => const Sizer(),
                  shrinkWrap: true,
                  itemCount: state.filterAdProperties?.length ?? 0,
                ),
                const Sizer(),
                DefaultButton(
                    label: LocaleKeys.filter.localize,
                    onPressed: () {
                      controller.filterAds(
                          categorize: widget.categorization, context: context);
                    }),
              ],
            );
          }),
        ),
      );
    });
  }
}
