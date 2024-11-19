import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/ride_services_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../../../../res/style/styles.dart';
import '../../cubit/driver_register_cubit.dart';
import 'enter_car_info.dart';

class EnterPersonalInfo extends StatelessWidget {
  final int length, index;
  final String label;

  const EnterPersonalInfo(
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
                Row(
                  children: [
                    Expanded(
                      child: FormTextField(
                        // prefix: ,
                        controller: controller.driverNameTextController,
                        label: 'First Name',
                        prefix: const Icon(Icons.person),
                        info: 'This name will appear to clients',
                      ),
                    ),
                    const Sizer(),
                    Expanded(
                      child: FormTextField(
                        // prefix: ,
                        controller: controller.driverNameTextController,
                        label: 'Last Name',
                        prefix: const Icon(Icons.person),
                        info: 'This name will appear to clients',
                      ),
                    ),
                  ],
                ),
                const Sizer(),
                FormTextField(
                  // prefix: ,
                  controller: controller.driverPhoneTextController,

                  label: 'Phone Number',
                  prefix: const Icon(Icons.phone_android_rounded),
                ),
                const Sizer(),
                if (controller.enterPrice())
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
                const EnterCarInfo(),
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
      final controller = context.read<DriverRegisterCubit>();
      if (controller.captainOptions.isEmpty) {
        return const SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: 'I register in ${context.isArabic?state.subCategory?.nameAr:state.subCategory?.nameEn ?? ''}',
            style: Styles.headerText(),
          ),
          GridView.builder(
              itemCount: controller.captainOptions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 4),
              itemBuilder: (context, index) {
                final option = controller.captainOptions[index];
                return Row(
                  children: [
                    Checkbox(
                        value: state.selectedOptions?.contains(option) ?? false,
                        onChanged: (v) =>
                            controller.changeOptions(item: option)),
                    Expanded(child: Label(text: option.title())),
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
