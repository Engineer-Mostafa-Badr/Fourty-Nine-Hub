import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/more_information_register_card_widget.dart';

class MoreInfoPartScreen extends StatelessWidget {
  const MoreInfoPartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharedScaffold(
      mainCategoryId: 1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Sizer(
                height: 30,
              ),
            MoreInformationRegisterCardWidget(),
              Sizer(
                height: 30,
              ),
          ],
        ),
      ),
    );
  }
}
