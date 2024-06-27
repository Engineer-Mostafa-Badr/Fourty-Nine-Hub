import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/models/public/state_model.dart';

class SelectState extends StatelessWidget {
  final List<StateModel> states;
  final Function(StateModel) onSelected;
  const SelectState(
      {super.key, required this.states, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final state = states[index];
            return ListTile(
              title: Label(text: state.name),
              onTap: () {
                onSelected(state);
                context.pop();
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(),
          itemCount: states.length),
    );
  }
}
