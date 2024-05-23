import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/maps/map_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/RideRequest/domain/entity/address_search_params_entity.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../cubit/riderequest_cubit.dart';
import '../widgets/customer/createOrder/options_bottom_sheet.dart';

class RideRequestView extends StatelessWidget {
  const RideRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: Column(
        children: [
          Expanded(child: BlocBuilder<RiderequestCubit, RiderequestState>(
            builder: (context, state) {
              final rideCubit = context.read<RiderequestCubit>();
              if (state.isFromAndToLocationSelected) {
                return MapPicker(
                  lat: state.fromAddress?.lat,
                  lng: state.fromAddress?.lng,
                  destLat: state.toAddress?.lat,
                  destLng: state.toAddress?.lng,
                );
              }
              return MapPicker(
                lat: state.fromAddress?.lat ?? 30.9050401,
                lng: state.fromAddress?.lng ?? 31.031774,
                onAddressPicked: (AddressSearchParamsEntity v) =>
                    rideCubit.selectPickUpLocation(item: v),
              );
            },
          )),
          const RideOptionsBottomSheet(),
        ],
      ),
    );
  }
}
