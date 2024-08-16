import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class ShippingDetailsWidget extends StatelessWidget {
  const ShippingDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(label: 'Shipping Details'),
      body: ListView(
        children: [
          _buildPickUpFromWidget(context: context),
          const Sizer(),
          _buildDropOffWidget(context: context),
          const Sizer(),
          _buildDescriptionWidget(context: context),
        ],
      ),
    );
  }

  Widget _buildDropOffWidget({required BuildContext context}) {
    final controller = context.read<CreateShippingRequestCubit>();
    return BlocBuilder<CreateShippingRequestCubit, CreateShippingRequestState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: 'Where to deliver',
            style: Styles.headerText(),
          ),
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: FormTextField(
                    controller: controller.toAddressTextController,
                    hint: 'To Address',
                    prefix: const Icon(Icons.location_on),
                  )),
              const Sizer(),
              Expanded(
                  child: FormTextField(
                hint: 'Entrance',
                controller: controller.toEntranceTextController,
              )),
            ],
          ),
          const Sizer(),
          FormTextField(
            hint: 'Phone Number',
            prefix: const Icon(Icons.phone),
            controller: controller.toPhoneTextController,
          ),
        ],
      );
    });
  }

  Widget _buildDescriptionWidget({required BuildContext context}) {
    final controller = context.read<CreateShippingRequestCubit>();
    return BlocBuilder<CreateShippingRequestCubit, CreateShippingRequestState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: 'What to deliver',
            style: Styles.headerText(),
          ),
          FormTextField(
            hint: 'Notes',
            maxLines: 3,
            controller: controller.toPhoneTextController,
          ),
          const Sizer(),
          FormTextField(
            hint: 'Offer Price',
            prefix: const Icon(Icons.monetization_on_outlined),
            controller: controller.offerTextController,
          ),
          const Sizer(),
          Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {},
                child: Container(
                  height: kToolbarHeight * .7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red),
                  child: Center(
                      child: Label(
                    text: 'Premium Request',
                    style: Styles.mediumText(color: Colors.white),
                  )),
                ),
              )),
              const Sizer(),
              Expanded(
                  child: InkWell(
                onTap: () => controller.addNormalRequest(context: context),
                child: Container(
                  height: kToolbarHeight * .7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.PRIMARY_COLOR),
                  child: Center(
                      child: Label(
                          text: 'Normal Request',
                          style: Styles.mediumText(color: Colors.white))),
                ),
              )),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildPickUpFromWidget({required BuildContext context}) {
    final controller = context.read<CreateShippingRequestCubit>();
    return BlocBuilder<CreateShippingRequestCubit, CreateShippingRequestState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: 'Where to pick up',
            style: Styles.headerText(),
          ),
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: FormTextField(
                    controller: controller.fromAddressTextController,
                    hint: 'From Address',
                    prefix: const Icon(Icons.location_on),
                  )),
              const Sizer(),
              Expanded(
                  child: FormTextField(
                hint: 'Entrance',
                controller: controller.fromEntranceTextController,
              )),
            ],
          ),
          const Sizer(),
          FormTextField(
            hint: 'Phone Number',
            prefix: const Icon(Icons.phone),
            controller: controller.fromPhoneTextController,
          ),
        ],
      );
    });
  }
}
