import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../widgets/create_chance_view_body.dart';


class CreateChanceView extends StatelessWidget {
  const CreateChanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BackAppBar(
        label: "Create Chance ",
      ),
      body: CreateChanceViewBody(),
    );
  }
}
