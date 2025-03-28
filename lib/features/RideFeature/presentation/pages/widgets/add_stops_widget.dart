import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/osm_search_and_pick.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';

class AddStopsWidget extends StatefulWidget {
  const AddStopsWidget({super.key, required this.rideCubit});
  final RideCubit rideCubit;

  @override
  State<AddStopsWidget> createState() => _AddStopsWidgetState();
}

class _AddStopsWidgetState extends State<AddStopsWidget> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.rideCubit,
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _customLocationField(
                  isTo: false,
                  color: Colors.green,
                  text: state.currentLocation?.address,
                  onPressed: () async {
                    context.push(Routes.RIDEOPENSTREETMAPSEARCHANDPICK, extra: RideOpenStreetMapSearchAndPickParams(
                      onPicked: (pickedData) async {
                        context.read<RideCubit>().updateFromLocation(lat: pickedData.latLong.latitude, lng: pickedData.latLong.longitude, address: pickedData.addressName,);
                        context.pop();
                        },
                    ));
                  },
                ),
                _customLocationField(
                  isTo: true,
                  color: Colors.blue,
                  text: state.toLocation?.address,
                  onPressed: () async {
                    context.push(Routes.RIDEOPENSTREETMAPSEARCHANDPICK, extra: RideOpenStreetMapSearchAndPickParams(
                      onPicked: (pickedData) async {
                        context.read<RideCubit>().updateToLocation(lat: pickedData.latLong.latitude, lng: pickedData.latLong.longitude, address: pickedData.addressName,);
                        await context.read<RideCubit>().fetchRideExpectedPrice(id: 'id');
                        context.pop();
                      },
                    ));
                  },
                  onAddPressed: () {
                    setState(() {
                      context.read<RideCubit>().showWaypointOne = true;
                    });
                  },
                  showAddIcon: state.toLocation != null && !context.read<RideCubit>().showWaypointOne,
                ),
                if (context.read<RideCubit>().showWaypointOne)
                  _customLocationField(
                    isTo: true,
                    color: Colors.blue,
                    text: state.wayPointOne?.address,
                    onPressed: () async {
                      context.push(Routes.RIDEOPENSTREETMAPSEARCHANDPICK, extra: RideOpenStreetMapSearchAndPickParams(
                        onPicked: (pickedData) async {
                          context.read<RideCubit>().updateWayPointOne(lat: pickedData.latLong.latitude, lng: pickedData.latLong.longitude, address: pickedData.addressName,);
                          await context.read<RideCubit>().fetchRideExpectedPrice(id: 'id');
                          context.pop();
                        },
                      ));
                    },
                    onAddPressed: () {
                      setState(() {
                        context.read<RideCubit>().showWaypointTwo = true;
                      });
                    },
                    showAddIcon: state.wayPointOne != null && !context.read<RideCubit>().showWaypointTwo,
                  ),

                if (context.read<RideCubit>().showWaypointTwo)
                  _customLocationField(
                    isTo: true,
                    color: Colors.blue,
                    text: state.wayPointTwo?.address,
                    onPressed: () async {
                      context.push(Routes.RIDEOPENSTREETMAPSEARCHANDPICK, extra: RideOpenStreetMapSearchAndPickParams(
                        onPicked: (pickedData) async {
                          context.read<RideCubit>().updateWayPointTwo(lat: pickedData.latLong.latitude, lng: pickedData.latLong.longitude, address: pickedData.addressName,);
                          await context.read<RideCubit>().fetchRideExpectedPrice(id: 'id');
                          context.pop();
                        },
                      ));
                    },
                  ),
                _locationInfoBox(state.toLocation?.address),
          if (context.read<RideCubit>().showWaypointOne)
          _locationInfoBox(state.wayPointOne?.address),
          if (context.read<RideCubit>().showWaypointTwo)
          _locationInfoBox(state.wayPointTwo?.address),
                const SizedBox(height: 10),
                AppButton(
                  label: context.isArabic ? 'تم' : 'Done',
                  onPressed: () {
                    context.pop();
                  },
                  width: MediaQuery.of(context).size.width / 2,
                  backColor: AppColors.PRIMARY_COLOR,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _locationInfoBox(String? address) {
    if (address == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_sharp, size: 30),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customLocationField({
    required Color color,
    required String? text,
    required bool isTo,
    required Function()? onPressed,
    Function()? onAddPressed,
    bool showAddIcon = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFEEEEEE),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 10,
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 5,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  text ?? (isTo ? (context.isArabic ? "إلى" : "To") : (context.isArabic ? "من" : "From")),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showAddIcon)
                GestureDetector(
                  onTap: onAddPressed,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add, size: 18),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

