import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_shipping_request_cubit.dart';

import '../../../../../common/widgets/stateful/maps/map_picker.dart';
import '../../../../ride/RideRequest/domain/entity/address_search_params_entity.dart';
import '../widgets/from_and_to_widget.dart';

class CreateShippingView extends StatelessWidget {
  const CreateShippingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 1,
        body: Column(
          children: [
            Expanded(child: _buildMapWidget(context: context)),
            const FromAndToWidget(),
          ],
        ));
  }

  Widget _buildMapWidget({
    required BuildContext context,
  }) {
    final controller = context.read<CreateShippingRequestCubit>();
    return BlocBuilder<CreateShippingRequestCubit, CreateShippingRequestState>(
        builder: (context, state) {
      return MapPicker(
        lat: state.fromAddress?.lat,
        lng: state.fromAddress?.lng,
        onAddressPicked: (AddressSearchParamsEntity v) =>
            controller.selectPickUpLocation(item: v),
      );
    });
  }
}
