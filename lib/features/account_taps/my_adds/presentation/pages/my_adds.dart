import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../widgets/my_ad_card.dart';

class MyAddsView extends StatelessWidget {
  const MyAddsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: 'My Ads',
      ),
      body: BlocConsumer<MyAddsCubit, MyAddsState>(
        listener: (context, state) {
          if (state.status == MyAddsStates.error && state.failure != null) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure!,
                context,
              ),
            );
          }
        },
        builder: (context, state) {
          return ListView.builder(
              itemCount: state.myAds?.length ?? 0,
              itemBuilder: (context, index) {
                return MyAdCard(
                  item: state.myAds![index],
                );
              });
        },
      ),
    );
  }
}
