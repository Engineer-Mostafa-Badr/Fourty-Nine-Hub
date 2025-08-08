import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/driver/widget/running_trip_client_widget.dart';

class BuildRouteClientsSheet extends StatelessWidget {
  const BuildRouteClientsSheet({super.key, required this.clients});
  final List<BookingClientEntity> clients;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.2,
      maxChildSize: 0.6,
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
                          cubit.goToClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[0].id, otp: otp, context: context);
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
                          cubit.goToClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[1].id, otp: otp, context: context);
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
                          cubit.goToClient(routeId: state.runningRoute?.id ?? '', passengerId: clients[2].id, otp: otp, context: context);
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
