import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_wallet_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/spin_wheel_cubit/spin_wheel_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/wheel_cubit/wheel_cubit.dart';
import 'package:fourtyninehub/features/lucky_wheel/presentation/controllers/wheel_wallet_cubit/wheel_wallet_cubit.dart';

import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import '../../../../core/enums/wheel.dart';
import '../../domain/entities/wheel_item_entity.dart';

class LuckyWheelView extends StatelessWidget {
  const LuckyWheelView({super.key});

  @override
  Widget build(BuildContext context) {
    final spinWheelCubit = BlocProvider.of<SpinWheelCubit>(context);
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Lucky Wheel',
      ),
      body: BlocBuilder<WheelCubit, BasicState<WheelEntity>>(
        builder: (context, state) {
          if (state.status != StateStatus.success) {
            return const Center(child: CircularProgressIndicator());
          }
          return BlocBuilder<SpinWheelCubit, BasicState<WheelItemEntity>>(
            builder: (_, priceState) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  BlocBuilder<WheelWalletCubit, BasicState<WheelWalletEntity>>(
                    builder: (_, state) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Balance: ${state.data?.amount ?? 0} L.E',
                        ),
                        Text(
                          'Points: ${state.data?.points ?? 0}',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FortuneWheel(
                      selected: spinWheelCubit.controller.stream,
                      animateFirst: false,
                      duration: const Duration(seconds: 3),
                      hapticImpact: HapticImpact.heavy,
                      onAnimationEnd: () {
                        spinWheelCubit.showPrize(context);
                        context.read<WheelWalletCubit>().getWheelWallet();
                      },
                      items: state.data!.items
                          .map(
                            (e) => FortuneItem(
                              child: Text(e.type == WheelItemTypes.point
                                  ? '${e.value} Points'
                                  : '${e.value} L.E'),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  AppButton(
                    height: 50,
                    width: 300,
                    label: 'Spin',
                    onPressed: () => spinWheelCubit.spin(state.data!),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
