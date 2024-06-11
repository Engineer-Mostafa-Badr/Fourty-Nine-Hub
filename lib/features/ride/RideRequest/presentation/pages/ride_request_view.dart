import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/maps/map_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/address_search_params_entity.dart';
import '../cubit/riderequest_cubit.dart';
import '../widgets/common/driver_dashboard_banner.dart';
import '../widgets/customer/createOrder/options_bottom_sheet.dart';

class RideRequestView extends StatelessWidget {
  const RideRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              Positioned.fill(
                child: BlocBuilder<RiderequestCubit, RiderequestState>(
                  builder: (context, state) {
                    final rideCubit = context.read<RiderequestCubit>();
                    if (state.fromAddress != null && state.toAddress != null) {
                      return MapPicker(
                        lat: state.fromAddress?.lat,
                        lng: state.fromAddress?.lng,
                        destLat: state.toAddress?.lat,
                        destLng: state.toAddress?.lng,
                      );
                    }
                    return MapPicker(
                      lat: state.fromAddress?.lat,
                      lng: state.fromAddress?.lng,
                      onAddressPicked: (AddressSearchParamsEntity v) =>
                          rideCubit.selectPickUpLocation(item: v),
                    );
                  },
                ),
              ),
              const Positioned(
                  bottom: 10,
                  right: 10,
                  left: 10,
                  child: DriverDashboardBanner()),
            ],
          )),
          const RideOptionsBottomSheet(),
        ],
      ),
    );
  }
}
