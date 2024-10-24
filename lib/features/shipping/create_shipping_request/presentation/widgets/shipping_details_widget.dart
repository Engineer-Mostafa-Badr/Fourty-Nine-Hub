import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class ShippingDetailsWidget extends StatelessWidget {
  const ShippingDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(label: LocaleKeys.shippingDetails.tr()),
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
            text: LocaleKeys.whereToDeliver.tr(),
            style: Styles.headerText(),
          ),
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: FormTextField(
                    controller: controller.toAddressTextController,
                    hint: LocaleKeys.toAddress.tr(),
                    prefix: const Icon(Icons.location_on),
                  )),
              const Sizer(),
              Expanded(
                  child: FormTextField(
                hint: LocaleKeys.entrance.tr(),
                controller: controller.toEntranceTextController,
              )),
            ],
          ),
          const Sizer(),
          FormTextField(
            hint: LocaleKeys.phoneNumber.tr(),
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
            text: LocaleKeys.whatToDeliver.tr(),
            style: Styles.headerText(),
          ),
          FormTextField(
            hint: LocaleKeys.notes.tr(),
            maxLines: 3,
            controller: controller.toPhoneTextController,
          ),
          const Sizer(),
          FormTextField(
            hint: LocaleKeys.offerPrice.tr(),
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
                    text: LocaleKeys.premiumRequest.tr(),
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
                          text: LocaleKeys.normalRequest.tr(),
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
            text: LocaleKeys.whereToPickUp.tr(),
            style: Styles.headerText(),
          ),
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: FormTextField(
                    controller: controller.fromAddressTextController,
                    hint: LocaleKeys.fromAddress.tr(),
                    prefix: const Icon(Icons.location_on),
                  )),
              const Sizer(),
              Expanded(
                  child: FormTextField(
                hint: LocaleKeys.entrance.tr(),
                controller: controller.fromEntranceTextController,
              )),
            ],
          ),
          const Sizer(),
          FormTextField(
            hint: LocaleKeys.phoneNumber.tr(),
            prefix: const Icon(Icons.phone),
            controller: controller.fromPhoneTextController,
          ),
        ],
      );
    });
  }
}
