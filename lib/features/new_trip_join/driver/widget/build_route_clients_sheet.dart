import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/driver/widget/running_trip_client_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class BuildRouteClientsSheet extends StatelessWidget {
  const BuildRouteClientsSheet({super.key, required this.clients});
  final List<BookingClientEntity> clients;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return BlocBuilder<CaptainShareDashboardCubit, CaptainShareDashboardState>(
          builder: (context,state) {
            var cubit = context.read<CaptainShareDashboardCubit>();
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    if (clients.isNotEmpty)
                      RunningTripClientWidget(
                        client: clients[0],
                        index: 0,
                        onPickClient: (otp) {
                          cubit.goToClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[0].id, otp: otp, context: context, index: 0);
                        },
                        onDropOffClient: () {
                          cubit.dropOffClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[0].id, context: context);
                        },
                        onDriverArrived: () {
                          cubit.onDriverArrivedToClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[0].id);
                        },
                        onClientNotShown: () {
                          cubit.onClientNotShown(routeId: state.runningRoute?.id ?? '', passengerId: clients[0].id);
                        },
                      ),
                
                    if (clients.isNotEmpty&&clients.length>1)
                      RunningTripClientWidget(
                        client: clients[1],
                        index: 1,
                        onPickClient: (otp) {
                          cubit.goToClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[1].id, otp: otp, context: context, index: 1);
                        },
                        onDropOffClient: () {
                          cubit.dropOffClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[1].id, context: context);
                        },
                        onDriverArrived: () {
                          cubit.onDriverArrivedToClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[1].id);
                        },
                        onClientNotShown: () {
                          cubit.onClientNotShown(routeId: state.runningRoute?.id ?? '', passengerId: clients[1].id);
                        },
                      ),
                
                    if (clients.isNotEmpty&&clients.length>2)
                      RunningTripClientWidget(
                        client: clients[2],
                        index: 2,
                        onPickClient: (otp) {
                          cubit.goToClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[2].id, otp: otp, context: context, index: 2);
                        },
                        onDropOffClient: () {
                          cubit.dropOffClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[2].id, context: context);
                        },
                        onDriverArrived: () {
                          cubit.onDriverArrivedToClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[2].id);
                        },
                        onClientNotShown: () {
                          cubit.onClientNotShown(routeId: state.runningRoute?.id ?? '', passengerId: clients[2].id);
                        },
                      ),
                    if(clients.every((c) =>
                    c.status == 'cancelled' ||
                        c.status == 'completed',
                    ))ClickableWidget(
                      onTap: (){
                        ManageVibration.vibrate();
                        cubit.onCompleteRoute(id: cubit.state.runningRoute?.id??'', context: context);
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 12),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.SECONDARY_COLOR,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          context.isArabic?'انهاء الرحله':'Finish Trip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }
}
