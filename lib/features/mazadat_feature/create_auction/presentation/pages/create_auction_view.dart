import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../cubit/create_auction_cubit.dart';

class CreateAuctionView extends StatelessWidget {
  final String adId;
  const CreateAuctionView({super.key, required this.adId});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreateAuctionCubit>();
    return BlocConsumer<CreateAuctionCubit, BasicState<bool>>(
        builder: (context, state) {
      return Scaffold(
        appBar: const BackAppBar(
          label: 'Create Auction',
        ),
        bottomNavigationBar: AppButton(
            label: 'Save Auction',
            margin: 10,
            onPressed: () => controller.createAuction(adId: adId)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.formState,
            child: ListView(
              children: [
                FormTextField(
                  label: 'Description',
                  action: (v) => controller.description = v,
                ),
                const Sizer(),
                FormTextField(
                  label: 'Starting Price',
                  type: TextInputType.number,
                  action: (v) => controller.startPrice = v,
                ),
                const Sizer(),
                FormTextField(
                  label: 'Minimum Increase',
                  type: TextInputType.number,
                  action: (v) => controller.minimumIncrease = v,
                ),
              ],
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state.isError && state.failure != null) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure!,
            context,
          ),
        );
      } else if (state.isSuccess) {
        context.go(Routes.MYADDS);
        showSuccessMessage(context, Labels.success);
      }
    });
  }
}
