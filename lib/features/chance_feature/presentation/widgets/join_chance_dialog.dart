import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../domain/entity/chance_ad_entity.dart';
import '../../domain/use_case/join_chance_ad_use_case.dart';
import '../controller/cubit/chance_cubit.dart';
import '../controller/cubit/chance_states.dart';

class JoinChanceDialog extends StatefulWidget {
  final ChanceAdEntity chanceAd;

  const JoinChanceDialog({super.key, required this.chanceAd});

  @override
  State<JoinChanceDialog> createState() => _JoinChanceDialogState();
}

class _JoinChanceDialogState extends State<JoinChanceDialog> {
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _joinChance() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text);
      if (amount != null && amount > 0) {
        context.read<ChanceCubit>().joinChanceAd(
          JoinChanceAdParams(
            adId: widget.chanceAd.id,
            amount: amount,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChanceCubit, ChanceState>(
      listener: (context, state) {
        if (state.status == ChanceStates.joinSuccess) {
          Navigator.of(context).pop();
          showSuccessMessage(context, 'Successfully joined the chance ad!');
        } else if (state.status == ChanceStates.error) {
          showErrorMessage(context, 'Failed to join chance ad. Please try again.');
        }
      },
      child: AlertDialog(
        title: Text(
          'Join ${widget.chanceAd.title}',
          style: Styles.headerText(),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price: ${widget.chanceAd.price.toStringAsFixed(0)} EGP',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.SECONDARY_COLOR,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Progress: ${widget.chanceAd.adPercentage.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 14.sp),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: widget.chanceAd.adPercentage / 100,
                backgroundColor: AppColors.GREY_LIGHT_COLOR,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.chanceAd.adPercentage >= 100 ? Colors.green : AppColors.SECONDARY_COLOR,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Enter your contribution amount:',
                style: TextStyle(fontSize: 14.sp),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Amount in EGP',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              LocaleKeys.cancel.localize,
              style: const TextStyle(color: AppColors.GREY_NORMAL_COLOR),
            ),
          ),
          BlocBuilder<ChanceCubit, ChanceState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.status == ChanceStates.loading ? null : _joinChance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.SECONDARY_COLOR,
                ),
                child: state.status == ChanceStates.loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Join',
                        style: const TextStyle(color: Colors.white),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}