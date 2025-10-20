import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/widgets/custom_header_form.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/presentation/pages/widgets/filter_ad_dynamic_inputs.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class FilterAdsParams {
  final CategorizationEntity categorization;
  final String userType;
  FilterAdsParams({required this.categorization, required this.userType});
}

class FilterAdsView extends StatefulWidget {
  final FilterAdsParams filterAdsParams;

  const FilterAdsView({super.key, required this.filterAdsParams});

  @override
  State<FilterAdsView> createState() => _FilterAdsViewState();
}

class _FilterAdsViewState extends State<FilterAdsView> {
  @override
  void initState() {
    debugPrint('MainCatId ${widget.filterAdsParams.categorization.mainCategory.id}');
    debugPrint('SubCatId ${widget.filterAdsParams.categorization.subCategory.id}');
    context.read<CreateAdCubit>().loadPropsData(
        subCategoryId:
            widget.filterAdsParams.categorization.fromMarriage == false
                ? widget.filterAdsParams.categorization.subCategory.id
                : widget.filterAdsParams.categorization.subCategory.id,
        fromMarriage:
            widget.filterAdsParams.categorization.fromMarriage ?? false);
    super.initState();
  }

  String _convertToArabicDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], arabic[i]);
    }
    return output;
  }

  String _convertToEnglishDigits(String input) {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    String output = input;
    for (int i = 0; i < arabic.length; i++) {
      output = output.replaceAll(arabic[i], english[i]);
    }
    return output;
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
      print("state.filterAdProperties?.length ${state.filterAdProperties?.length}");
      return CustomScaffold(
        enableCustomAppBar: true,
        appBar: BackAppBar(label: LocaleKeys.filter.localize),
        body: Form(
          key: controller.formState,
          child: BlocBuilder<CreateAdCubit, CreateAdState>(
              builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CustomLoadingSearchWidget(),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: Column(
                // shrinkWrap: true,
                // padding: const EdgeInsets.all(16.0),
                children: [
                  CustomHeaderForm(
                    categorization: widget.filterAdsParams.categorization,
                    isCreateAd: false,
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
                  Expanded(
                    child:state.isLoading?const Center(child: CustomCircularProgressIndicator(),): (state.filterAdProperties==null||(state.filterAdProperties?.isEmpty??false))?Center(
                      child: CustomEmptyWidget(label: context.isArabic?"لا يوجد خصائص":"No Properties"),
                    ):Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.filterAdProperties?.length ?? 0,
                            itemBuilder: (context, index) {
                              final property = state.filterAdProperties![index];
                              return FilterAdDynamicInputWidget(
                                  property: property,
                                  onChanged: (SelectionEntity v) =>
                                      controller.onChanged(v: v, index: index),
                                  onTextChanged: (String v, bool from, String type) {
                                    print('arabicValue $v');

                                    controller.onTextChanged(
                                        v: v,
                                        index: index,
                                        isNumber: property.type == 'number',
                                        from: from,
                                        type: type);
                                  });
                            },
                            // separatorBuilder: (context, index) => const Sizer(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ClickableWidget(
                            onTap: () {
                              ManageVibration.vibrate();
                              controller.filterAds(
                                  categorize: widget.filterAdsParams.categorization,
                                  userType: widget.filterAdsParams.userType,
                                  context: context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                color: AppColors.getButtonPrimaryColor(context),
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
                                style: Styles.headerText(
                                    color: AppColors.getReversedTextColor(context)),
                              ),
                            )),

                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
