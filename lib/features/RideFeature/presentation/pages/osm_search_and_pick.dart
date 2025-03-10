// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
class RideOpenStreetMapSearchAndPickParams{
  final RideCubit rideCubit;
  final bool isFrom;
  final bool isTo;
  final bool isToOneWay;
  final bool isToTwoWay;
  const RideOpenStreetMapSearchAndPickParams({required this.rideCubit, this.isFrom = false, this.isTo = false, this.isToOneWay = false, this.isToTwoWay = false});
}
class RideOpenStreetMapSearchAndPick extends StatefulWidget {
  final RideOpenStreetMapSearchAndPickParams params;
  const RideOpenStreetMapSearchAndPick({super.key, required this.params});

  @override
  State<RideOpenStreetMapSearchAndPick> createState() => _RideOpenStreetMapSearchAndPickState();
}

class _RideOpenStreetMapSearchAndPickState extends State<RideOpenStreetMapSearchAndPick> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SharedScaffold(
          mainCategoryId: 2,
          body: NestedAppbar(
            scrollController: _scrollController,
            appBars: const [],
            body: BlocProvider.value(
              value: widget.params.rideCubit,
              child: Builder(
                builder: (context) {
                  return OpenStreetMapSearchAndPick(
                      buttonText: context.isArabic? 'تعيين الموقع المحدد' : 'Set Selected Location',
                      buttonColor: AppColors.PRIMARY_COLOR,
                      buttonTextStyle:
                      const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
                      onPicked: (pickedData) async {
                        print("Latitude: ${pickedData.latLong.latitude}");
                        print("Longitude: ${pickedData.latLong.longitude}");
                        print("Address: ${pickedData.address}");
                        print("Address Name: ${pickedData.addressName}");
                        if(widget.params.isFrom){
                          widget.params.rideCubit.updateFromLocation(lat: pickedData.latLong.latitude, lng: pickedData.latLong.longitude, address: pickedData.addressName,);
                        }
                        if(widget.params.isTo){
                          log('to selected');
                          widget.params.rideCubit.updateToLocation(lat: pickedData.latLong.latitude, lng: pickedData.latLong.longitude, address: pickedData.addressName,);
                          await widget.params.rideCubit.fetchRideExpectedPrice(id: 'id');
                        }
                        context.pop();
                      },
                      buttonTextColor: Colors.white,
                      currentLocationIcon: Icons.my_location,
                      hintText: context.isArabic? 'ابحث عن موقع' : 'Search for a location...',
                      locationPinIcon: Icons.location_on,
                      locationPinIconColor: Colors.red,
                      locationPinText: context.isArabic? 'الموقع المحدد' : 'Selected Location',
                      locationPinTextStyle:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      zoomInIcon: Icons.zoom_in,
                      zoomOutIcon: Icons.zoom_out,
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}
