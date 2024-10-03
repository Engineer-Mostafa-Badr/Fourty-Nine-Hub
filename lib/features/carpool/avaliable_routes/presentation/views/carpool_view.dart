import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/car_pool_body.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/car_pool_floating_action_button.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class CarPoolView extends StatelessWidget {
  const CarPoolView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Text(
              'Carpool',
              style: Styles.headerText(),
            ),
          ),
        ),
        body: const CarPoolBody(),
      ),
    );
  }
}
