import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../service_locator/service_locator.dart';
import '../controllers/client_trips_cubit/client_trips_cubit.dart';
import 'dashboards/widgets/client_offers_widget.dart';

class RideLoadingRequestScreen extends StatefulWidget {
  final bool isTruk;
  const RideLoadingRequestScreen({super.key, required this.isTruk});

  @override
  State<RideLoadingRequestScreen> createState() => _RideLoadingRequestScreenState();
}

class _RideLoadingRequestScreenState extends State<RideLoadingRequestScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isTruk) {
      serviceLocator<ClientTripsCubit>().getLoadingOffers(context);
    } else {
      serviceLocator<ClientTripsCubit>().getClientOffers(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leadingWidth: 30,
          title: Label(
              text: LocaleKeys.rideRequest.tr(),
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 20))),
      body: BlocBuilder<ClientTripsCubit, ClientTripsState>(
        builder: (context, state) {
          return state.isLoading ?Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ): state.isError 
              ? Center(
                  child: Label(
                      text: state.failure!.toString(),
                      style: const TextStyle(color: Colors.red)),
                )
              : state.offers == null || state.offers!.isEmpty
                  ? const Center(
                      child: Label(
                          text: 'You don\'t have any offers yet',
                          style: TextStyle(color: Colors.red,fontSize: 18)),
                    )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child:state.offers == null||state.offers!.isEmpty? const EmptyPage(): ListView.separated(
                  itemBuilder: (context, index) =>  ClientOffersWidget(
                    offers: state.offers?[index],
                  ),
                  separatorBuilder:(context, index) =>  const SizedBox(height: 5),
                  itemCount: state.offers?.length??0),
            );
        },
      ),
    );
  }
}
