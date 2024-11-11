import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_price_carpool/get_price_carpool_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

void showCreateRouteModalSheet(BuildContext context, {bool isComfort = false}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return CreateRouteBottomSheet(isComfort: isComfort);
    },
  );
}

class CreateRouteBottomSheet extends StatefulWidget {
  final bool isComfort;

  const CreateRouteBottomSheet({super.key, required this.isComfort});

  @override
  _CreateRouteBottomSheetState createState() => _CreateRouteBottomSheetState();
}

class _CreateRouteBottomSheetState extends State<CreateRouteBottomSheet> {
  late bool isComfort;

  @override
  void initState() {
    super.initState();
    isComfort = widget.isComfort; // Initialize the state variable
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ensure the column takes up minimal space
        children: [
          Text(LocaleKeys.bookSeat.localize, style: Styles.headerText()),
          const Sizer(),
          Text(LocaleKeys.pricePerSeat.localize, style: Styles.mediumText()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // BlocBuilder<GetPriceCarpoolCubit, GetPriceCarpoolState>(
              //   builder: (context, state) {
              //     return
              Text(
                "75",
                style: Styles.headerText(
                    fontWeight: FontWeight.bold, fontSize: 50),
              ),
              //   },
              // ),
              Text(
                LocaleKeys.egp.localize,
                style: Styles.mediumText(
                    fontWeight: FontWeight.bold,
                    color: AppColors.SECONDARY_COLOR),
              ),
            ],
          ),
          const Sizer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.comfort.localize, style: Styles.headerText()),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: isComfort,
                  onChanged: (value) {
                    setState(() {
                      isComfort = value; // Update the state
                    });
                  },
                  activeColor: AppColors.PRIMARY_COLOR,
                  trackOutlineColor: MaterialStatePropertyAll(Colors.grey),
                  activeTrackColor: Colors.grey,
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: Colors.grey,
                ),
              ),
            ],
          ),
          const Sizer(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.book.localize,
                  color: AppColors.PRIMARY_COLOR,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
