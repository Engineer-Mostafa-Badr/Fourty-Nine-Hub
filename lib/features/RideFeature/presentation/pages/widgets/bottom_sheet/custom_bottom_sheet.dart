import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';

import '../../../../../../res/style/app_colors.dart';

Future<dynamic> customBottomSheet(context, RideCubit rideCubit,
    {required child, height = 150, required String title}) {
  return showModalBottomSheet(
    backgroundColor: AppColors.whiteColor,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
    isScrollControlled: true,
    builder: (context) => BlocProvider.value(
      value: rideCubit,
      child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: AppColors.whiteColor,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Text(title,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                    IconButton(
                      icon: SvgPicture.asset('assets/icons/close.svg'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                  ],
                ),
              ),
              child,
            ],
          ),
        )
    ),
  );
}