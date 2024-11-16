import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/presentation/cubit/ad_requests_cubit.dart';

class DoctorReviews extends StatefulWidget {
  const DoctorReviews({super.key, });

  @override
  State<DoctorReviews> createState() => _DoctorReviewsState();
}

class _DoctorReviewsState extends State<DoctorReviews> {
  late ScrollController _scrollController;
  late AdRequestsCubit _cubit;
  bool isFirstSearchListenerCall = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _cubit = context.read<AdRequestsCubit>();
  //   _scrollController = ScrollController()..addListener(_onScroll);
  //   _cubit.loadInitialData(widget.id, widget.search);
  //
  //   _cubit.searchController.addListener(() {
  //     if (isFirstSearchListenerCall) {
  //       isFirstSearchListenerCall = false;
  //       return;
  //     }
  //     _cubit.loadInitialData(widget.id, _cubit.searchController.text);
  //   });
  // }
  //
  // void _onScroll() {
  //   if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
  //     _cubit.fetchAdRequests(widget.id, _cubit.searchController.text);
  //   }
  // }

  // @override
  // void dispose() {
  //   _scrollController.removeListener(_onScroll);
  //   _scrollController.dispose();
  //   _cubit.searchController.dispose(); // Don't forget to dispose the controller
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(label: LocaleKeys.adRequests.localize),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
