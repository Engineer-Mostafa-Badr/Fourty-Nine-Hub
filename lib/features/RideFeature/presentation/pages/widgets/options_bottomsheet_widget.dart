import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class OptionsBottomsheetWidget extends StatefulWidget {
  const OptionsBottomsheetWidget({super.key, required this.rideCubit, required this.selectedCategoryPrice, required this.selectedCategoryName});

  final RideCubit rideCubit;
  final double selectedCategoryPrice;
  final String selectedCategoryName;

  @override
  State<OptionsBottomsheetWidget> createState() =>
      _OptionsBottomsheetWidgetState();
}

class _OptionsBottomsheetWidgetState extends State<OptionsBottomsheetWidget> {
  late bool _isComfort;
  late bool _isNonSmoker;
  late bool _isAutoAccept;
  late bool _isRecord;

  @override
  void initState() {
    super.initState();
    _isComfort = widget.rideCubit.isComfort;
    _isNonSmoker = widget.rideCubit.isNonSmoker;
    _isAutoAccept = widget.rideCubit.isAutoAccept;
    _isRecord = widget.rideCubit.isRecord;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.rideCubit,
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                switchWidget(
                  text: LocaleKeys.comfort.tr(),
                  value: _isComfort,
                  index: 1,
                  onChanged: (value) {
                    setState(() {
                      _isComfort = value;
                    });
                  },
                ),
                switchWidget(
                  text: LocaleKeys.noSmoker.tr(),
                  value: _isNonSmoker,
                  index: 2,
                  onChanged: (value) {
                    setState(() {
                      _isNonSmoker = value;
                    });
                  },
                ),
                switchWidget(
                  text: LocaleKeys.autoAccept.tr(),
                  value: _isAutoAccept,
                  index: 3,
                  onChanged: (value) {
                    setState(() {
                      _isAutoAccept = value;
                    });
                  },
                ),
                // switchWidget(
                //   text: LocaleKeys.record.tr(),
                //   value: _isRecord,
                //   onChanged: (value) {
                //     setState(() {
                //       _isRecord = value;
                //     });
                //   },
                // ),
                AppButton(
                  width: double.infinity,
                  label: context.isArabic ? "تفعيل" : "Apply",
                  onPressed: () {
      ManageVibration.vibrate();
                    widget.rideCubit.isComfort = _isComfort;
                    widget.rideCubit.isNonSmoker = _isNonSmoker;
                    widget.rideCubit.isAutoAccept = _isAutoAccept;
                    widget.rideCubit.isRecord = _isRecord;
                    widget.rideCubit.emitRefreshState();
                    Navigator.pop(context);
                  },
                  backColor: AppColors.PRIMARY_COLOR,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget switchWidget({
    required String? text,
    required bool value,
    required int index,
    required Function(bool)? onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text ?? '',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        if(index == 1)
          Image.asset(Assets.airConditioner,
            height: 20,
            width: 40,),
        if(index == 2)
          Image.asset(Assets.noSmokingIcon,
            height: 20,
            width: 40,),
        if(index == 3)
          SizedBox(width: 6,),
        if(index == 3)
          Icon(Icons.autorenew, size: 20,),
        Spacer(),
        Transform.scale(
          scale: 0.75,
          child: Switch(
            value: value,
            padding: const EdgeInsets.all(0),
            activeColor: AppColors.PRIMARY_COLOR,
            inactiveThumbColor: AppColors.PRIMARY_COLOR,
            trackOutlineColor: WidgetStateProperty.all<Color>(
              AppColors.PRIMARY_COLOR,
            ),
            activeTrackColor: const Color(0xff19D176),
            inactiveTrackColor: AppColors.whiteColor,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
