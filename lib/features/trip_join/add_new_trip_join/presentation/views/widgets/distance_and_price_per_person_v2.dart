import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import 'custom_row_v2.dart';
import '../../../../../../res/style/styles.dart';

class DistanceAndPricePerPersonV2 extends StatelessWidget {
  const DistanceAndPricePerPersonV2({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPriceDistanceCubit, FetchPriceDistanceState>(
      builder: (context, state) {
        FetchPriceDistanceCubit fetchPriceDistanceCubit =
            context.read<FetchPriceDistanceCubit>();
        double distance = fetchPriceDistanceCubit.tripInfoEntity?.distance ?? 0;
        String distanceFormated = ' ${(distance / 1000).toStringAsFixed(1)} ';
        double price = fetchPriceDistanceCubit.tripInfoEntity?.price ?? 0;
        String priceFormated = price.toStringAsFixed(1);
        return CustomRow(
          children: [
            Icon(Icons.directions_car, size: size),
            Text('$distanceFormated ${LocaleKeys.KM.localize}',
                style: Styles.headerText()),
            Icon(Icons.person, size: size),
            Text(
              priceFormated,
              style: Styles.headerText(
                color: Colors.green[500],
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ],
        );
      },
    );
  }
}
