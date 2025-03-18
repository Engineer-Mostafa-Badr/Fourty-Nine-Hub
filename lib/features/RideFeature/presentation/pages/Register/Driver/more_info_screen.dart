import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../widgets/close_widget.dart';
import '../widgets/register_floating_action_button.dart';

class MoreInfoScreen extends StatelessWidget {
  const MoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const HomeAppbar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 32,
                  left: 16,
                  right: 16,
                ),
                child:
                    BlocBuilder<RideCubit, RideState>(builder: (context, state) {
                  var cubit = context.read<RideCubit>();
                  return Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      closeWidget(context),
                      Label(
                        text: LocaleKeys.moreInfo.localize,
                        style: Styles.headerText(
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    ],
                  );
                }),
              ),
            ),
          ),
          const RegisterNextRow(
            index: 5,
          ),
        ],
      ),
    );
  }
}
