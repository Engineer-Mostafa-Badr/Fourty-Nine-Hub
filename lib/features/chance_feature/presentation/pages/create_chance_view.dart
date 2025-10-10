import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../../../service_locator/service_locator.dart';
import '../controller/cubit/chance_cubit.dart';
import '../controller/cubit/chance_states.dart';
import '../widgets/create_chance_view_body.dart';

class CreateChanceView extends StatelessWidget {
  const CreateChanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChanceCubit>(
      create: (BuildContext context) => serviceLocator(),
      child: CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: BackAppBar(
            label: LocaleKeys.CreateChance.localize,
          ),
        ),
        body: BlocBuilder<ChanceCubit, ChanceState>(
          builder: (BuildContext context, state) {
            return SafeArea(
              child: const CreateChanceViewBody(),
            );
          },
        ),
      ),
    );
  }
}
