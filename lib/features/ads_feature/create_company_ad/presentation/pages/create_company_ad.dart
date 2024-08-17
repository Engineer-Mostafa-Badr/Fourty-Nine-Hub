import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/file_picker_helper.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_entity.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/create_company_ad_cubit.dart';

class CreateCompanyAdView extends StatelessWidget {
  const CreateCompanyAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Advertise Your Company',
      ),
      body: BlocConsumer<CreateCompanyAdCubit, CreateCompanyAdState>(
          listener: (context, state) {},
          builder: (context, state) {
            final controller = context.read<CreateCompanyAdCubit>();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                   FormTextField(
                    style:  TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor
                    ),
                    label: 'Slogan',
                    hint: 'Type your slogan (Not more 100 letter)',
                  ),
                  const Sizer(),
                  Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return _buildOptionWidget(
                                adOption: state.adOptions![index]);
                          },
                          separatorBuilder: (context, index) {
                            return const Sizer();
                          },
                          itemCount: state.adOptions?.length ?? 0)),
                  AppButton(
                      style: const TextStyle(
                          color: AppColors.AUTH_CONTAINER_COLOR
                      ),
                      label:
                          'Proceed to Payment (${controller.totalPrice()} ${Labels.currency})',
                      backColor: (state.selectedOptions?.isEmpty ?? true)
                          ? AppColors.SECONDARY_COLOR.withAlpha(150)
                          : AppColors.SECONDARY_COLOR,
                      onPressed: () {})
                ],
              ),
            );
          }),
    );
  }

  Widget _buildOptionWidget({required CompanyAdEntity adOption}) {
    return BlocBuilder<CreateCompanyAdCubit, CreateCompanyAdState>(
        builder: (context, state) {
      final controller = context.read<CreateCompanyAdCubit>();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Label(
                  text: adOption.title,
                  style: Styles.headerText(),
                ),
              ),
              IconAppButton(
                  icon: Icons.upload,
                  isCircle: true,
                  onPressed: () async => FilePickerHelper().pickMedia()),
            ],
          ),
          ListView.builder(
              itemCount: adOption.options.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final option = adOption.options[index];
                return Row(
                  children: [
                    Checkbox(
                        value: controller.optionSelected(option),
                        onChanged: (v) => controller.onSelection(option)),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          text: option.title,
                          style: Styles.mediumText(fontWeight: FontWeight.w400),
                        ),
                        Label(
                          text: option.subTitle,
                          style: Styles.mediumText(fontWeight: FontWeight.w300),
                        ),
                      ],
                    )),
                  ],
                );
              })
        ],
      );
    });
  }
}
