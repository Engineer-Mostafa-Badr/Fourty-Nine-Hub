import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';

class CreateAuctionView extends StatelessWidget {
  const CreateAuctionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Create Auction',
      ),
      bottomNavigationBar: AppButton(
          label: 'Save Auction',
          margin: 10,
          onPressed: () => context.push(Routes.MAZADDETAILS)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            FormTextField(
              label: 'Starting Price',
              type: TextInputType.number,
            ),
            Sizer(),
            FormTextField(
              label: 'Minimum Increase',
              type: TextInputType.number,
            ),
            Sizer(),
            FormTextField(
              label: 'Auto Sell Price',
              type: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
