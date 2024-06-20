import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/presentation/cubit/create_ad_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'ad_dynamic_inputs.dart';

class EnterAdDetails extends StatelessWidget {
  const EnterAdDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: 'Enter Ad Details',
        ),
        body: BlocBuilder<CreateAdCubit, CreateAdState>(
            builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                _buildImagePicker(),
                const Sizer(),
                FormTextField(
                  label: 'title',
                  height: kToolbarHeight * .8,
                  hint: 'Type here',
                  action: (v) {},
                ),
                const Sizer(),
                FormTextField(
                  label: 'Description',
                  // height: kToolbarHeight * .8,
                  hint: 'Type here',
                  action: (v) {},
                  maxLines: 3,
                ),
                const Sizer(),
                AdDynamicInputs(
                  properties: state.adProperties ?? [],
                ),
                const Sizer(),
                FormTextField(
                  label: 'Price',
                  type: TextInputType.number,
                  hint: 'Type here',
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Label(
                        text: 'EGP',
                        style: Styles.mediumText(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  action: (v) {},
                ),
                const Sizer(),
                AppButton(
                    label: 'Publish',
                    onPressed: () => context.push(Routes.MYADDS)),
              ],
            ),
          );
        }));
  }

  Widget _buildImagePicker() {
    return Container(
      height: kToolbarHeight * 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(
              Icons.image_aspect_ratio_outlined,
              size: 25,
            ),
            BadgedLabel(
              label: 'Add Images',
              style: Styles.smallText(color: Colors.white),
              color: AppColors.SECONDARY_COLOR,
            ),
            Label(
              text:
                  '5MB maximum file size accepted in the following formats: jpg, Jpeg, png, gif',
              style: Styles.smallText(color: Colors.grey),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
