import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/register/driver_register/presentation/widgets/upload_image.dart';
import '../../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../../res/style/styles.dart';
import '../../cubit/driver_register_cubit.dart';

class EnterCarInfo extends StatelessWidget {
  final int length, index;
  final String label;
  final controller = TextEditingController();
  final focusNode = FocusNode();
  EnterCarInfo(
      {super.key,
      required this.length,
      required this.index,
      required this.label});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DriverRegisterCubit>();
    return Scaffold(
      appBar: BackAppBar(
        label: label,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: index / length,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(10),
                ),
                const Sizer(),
                FormTextField(
                  // prefix: ,
                  controller: controller.driverNameTextController,
                  label: 'Name',
                  prefix: const Icon(Icons.person),
                  info: 'This name will appear to clients',
                ),
                const Sizer(),
                FormTextField(
                  // prefix: ,
                  controller: controller.driverPhoneTextController,
            
                  label: 'Phone Number',
                  prefix: const Icon(Icons.phone_android_rounded),
                ),
                const Sizer(),
                Row(
                  children: [
                    const Expanded(child: Label(text: 'KM Price')),
                    Expanded(
                        flex: 2,
                        child: FormTextField(
                            controller: controller.kmPriceTextController,
                            hint: 'xx',
                            label: 'Price',
                            type: TextInputType.number,
                            action: (v) {}))
                  ],
                ),
                const Sizer(),
                _buildCategoriesWidget(context: context),
                _buildCarTypesWidget(context: context),
                const Sizer(),
                Row(
                  children: [
                    const Expanded(child: Label(text: 'Car Module')),
                    const Sizer(),
                    Expanded(
                        child: FormTextField(
                      action: (v) {},
                      label: 'Mark',
                    )),
                    const Sizer(),
                    Expanded(
                        child: FormTextField(
                      action: (v) {},
                      label: 'Type',
                    )),
                  ],
                ),
                const Sizer(),
                Row(
                  children: [
                    const Expanded(child: Label(text: 'Metal Plate')),
                    const Sizer(),
                    Expanded(
                        child: FormTextField(
                      action: (v) {},
                      label: 'Chars',
                      type: TextInputType.text,
                    )),
                    const Sizer(),
                    Expanded(
                        child: FormTextField(
                      action: (v) {},
                      label: 'Numbers',
                      type: TextInputType.number,
                    )),
                  ],
                ),
                const Sizer(),
                Row(
                  children: [
                    const Expanded(child: Label(text: 'Air Conditioner')),
                    Switch(value: false, onChanged: (v) {})
                  ],
                ),
                const Label(text: 'Car Images'),
                Row(
                  children: [
                    Expanded(
                        child: UploadImageWidget(action: () {}, label: 'Front')),
                    // const Sizer(),
                    Expanded(
                        child: UploadImageWidget(action: () {}, label: 'Back')),
                    // const Sizer(),
                    Expanded(
                        child: UploadImageWidget(action: () {}, label: 'Right')),
                    // const Sizer(),
                    Expanded(
                        child: UploadImageWidget(action: () {}, label: 'Left')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesWidget({required BuildContext context}) {
    final controller = context.read<DriverRegisterCubit>();

    return BlocBuilder<DriverRegisterCubit, DriverRegisterState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: 'I register in ${state.subCategory?.name ?? ''}',
            style: Styles.headerText(),
          ),
          GridView.builder(
              itemCount: state.subCategories?.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 4),
              itemBuilder: (context, index) {
                final subCategory = state.subCategories![index];
                return Row(
                  children: [
                    Checkbox(
                        value: subCategory == state.subCategory,
                        onChanged: (v) => controller.changeSubCategorySelection(
                            item: subCategory)),
                    Expanded(child: Label(text: subCategory.name)),
                  ],
                );
              }),
        ],
      );
    });
  }

  Widget _buildCarTypesWidget({required BuildContext context}) {
    final controller = context.read<DriverRegisterCubit>();

    return BlocBuilder<DriverRegisterCubit, DriverRegisterState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text:
                'My Vechile is  ${state.carType?.brand ?? ''} - ${state.carType?.model ?? ''}',
            style: Styles.headerText(),
          ),
          GridView.builder(
              itemCount: state.carTypes?.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 4),
              itemBuilder: (context, index) {
                final carType = state.carTypes![index];
                return Row(
                  children: [
                    Checkbox(
                        value: carType == state.carType,
                        onChanged: (v) =>
                            controller.changeCarTypeSelection(item: carType)),
                    Expanded(
                        child:
                            Label(text: '${carType.brand} - ${carType.model}')),
                  ],
                );
              }),
        ],
      );
    });
  }
}
