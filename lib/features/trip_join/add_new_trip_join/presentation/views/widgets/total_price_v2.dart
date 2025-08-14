import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import '../../cubits/trip_join_view/trip_join_view_cubit.dart';
import '../../../../../../res/style/styles.dart';

class TotalPriceV2 extends StatelessWidget {
  const TotalPriceV2({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(Icons.money, size: size),
        ),
        Expanded(
          flex: 2,
          child:
              Text(LocaleKeys.totalPrice.localize, style: Styles.headerText()),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsetsDirectional.only(start: 15),
            child: BlocBuilder<TripJoinViewCubit, TripJoinViewState>(
              buildWhen: (previous, current) =>
                  current is TripJoinViewSeatNumberState,
              builder: (context, state) {
                int seatNumber =
                    context.read<TripJoinViewCubit>().numberOfSeats;
                double price = context
                        .watch<FetchPriceDistanceCubit>()
                        .tripInfoEntity
                        ?.price ??
                    0;
                String totalPrice = (seatNumber * price).toStringAsFixed(1);
                return Text(totalPrice, style: Styles.headerText());
              },
            ),
          ),
        ),
      ],
    );
  }
}
