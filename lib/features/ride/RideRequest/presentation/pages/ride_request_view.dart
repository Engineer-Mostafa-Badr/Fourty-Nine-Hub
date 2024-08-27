import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateful/maps/map_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/address_search_params_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../cubit/riderequest_cubit.dart';
import '../widgets/common/dashboard_banner.dart';
import '../widgets/customer/createOrder/options_bottom_sheet.dart';

class RideRequestView extends StatelessWidget {
  const RideRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MainCategoryBanner(
            category: MainCategoryEntity.fake(),
            canRegister:  true ,
            onRegister: () {
              if (context.read<UserCubit>().isLoggedIn) {
                context.push(Routes.CREATERESTURANT);
              } else {
                context.push(Routes.REGISTER);
              }
            }, onFavorite: () {  },),
          ),
          Expanded(
              child: Stack(
            children: [
              Positioned.fill(
                child: BlocProvider(
                  create: (BuildContext context) =>
                      serviceLocator<RiderequestCubit>(),
                  child: BlocBuilder<RiderequestCubit, RiderequestState>(
                    builder: (context, state) {
                      final rideCubit = context.read<RiderequestCubit>();
                      if (state.fromAddress != null &&
                          state.toAddress != null) {
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
              ),
              const Positioned(
                  bottom: 10,
                  right: 10,
                  left: 10,
                  child: DashboardBanner(
                    title: 'Driver Dashboard\n',
                    subTitle:
                        'New trips are waiting you, go to driver dashboard and explore more!',
                    route: Routes.RIDERDASHBOARD,
                  )),
            ],
          )),
          BlocProvider.value(
              value: serviceLocator<RiderequestCubit>(),
              child: const RideOptionsBottomSheet()),
        ],
      ),
    );
  }
}
