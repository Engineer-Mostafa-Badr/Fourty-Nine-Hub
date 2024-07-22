import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/pages/empty.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/requests_history/presentation/widgets/trip_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/enums/ride_services_enum.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../domain/usecases/request_come_with_me_usecase.dart';
import '../widgets/ad_card.dart';

class AdsView extends StatefulWidget {
  final String subCategoryId;
  const AdsView({super.key, required this.subCategoryId});

  @override
  State<AdsView> createState() => _AdsViewState();
}

class _AdsViewState extends State<AdsView> {
  @override
  void initState() {
    context.read<AdsCubit>().loadData(subCategoryId: widget.subCategoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdsCubit, AdsState>(builder: (context, state) {
      if (getRideServiceEnum(value: widget.subCategoryId) ==
          RideServicesEnum.pickMe) {
        return Scaffold(
          appBar: const BackAppBar(
            label: 'Pick Me',
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0), child: _buildPickMeTrips()),
        );
      } else if (getRideServiceEnum(value: widget.subCategoryId) ==
          RideServicesEnum.comeWithYou) {
        return Scaffold(
          appBar: const BackAppBar(
            label: 'Come With Me',
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildComeWithMeTrips()),
        );
      } else {
        return Scaffold(
          appBar: const BackAppBar(),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCommonAdsWidget()),
        );
      }
    }, listener: (context, state) {
      if (state.isError && state.failure != null) {
        showErrorMessage(
          context,
          getFailureMessage(
            state.failure!,
            context,
          ),
        );
      } else if (state.isSuccess) {
        showSuccessMessage(context, Labels.success);
      }
    });
  }

  Widget _buildCommonAdsWidget() {
    return BlocBuilder<AdsCubit, AdsState>(builder: (context, state) {
      if (state.isLoading) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      } else if (state.ads?.isEmpty ?? true) {
        return const EmptyPage(
          label: 'There is no ADs',
        );
      }
      return GridView.builder(
          itemBuilder: (context, index) => AdCard(
                item: state.ads![index],
              ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: .8,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 2),
          itemCount: state.ads?.length ?? 0);
    });
  }

  Widget _buildComeWithMeTrips() {
    return BlocBuilder<AdsCubit, AdsState>(builder: (context, state) {
      final controller = context.read<AdsCubit>();

      if (state.isLoading) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
      return ListView.separated(
          itemBuilder: (context, index) => TripCard(
                trip: state.comeWithMeAds![index],
                onRequest: (RequestParams params) =>
                    controller.requestComeWithMeAd(params: params),
              ),
          separatorBuilder: (context, index) {
            return const Sizer();
          },
          itemCount: state.comeWithMeAds?.length ?? 0);
    });
  }

  Widget _buildPickMeTrips() {
    return BlocBuilder<AdsCubit, AdsState>(builder: (context, state) {
      final controller = context.read<AdsCubit>();
      if (state.isLoading) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
      return ListView.separated(
          itemBuilder: (context, index) => TripCard(
                trip: state.pickMeAds![index],
                onRequest: (RequestParams params) =>
                    controller.requestPickMeAd(params: params),
              ),
          separatorBuilder: (context, index) {
            return const Sizer();
          },
          itemCount: state.pickMeAds?.length ?? 0);
    });
  }
}
