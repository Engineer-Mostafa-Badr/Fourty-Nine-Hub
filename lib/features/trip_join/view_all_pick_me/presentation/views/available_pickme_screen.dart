import 'package:easy_localization/easy_localization.dart' as EasyLocale;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card_bottom_section.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AvailablePickMeCard extends StatefulWidget {
  const AvailablePickMeCard({
    super.key,


  });

  @override
  State<AvailablePickMeCard> createState() => _AvailablePickMeCardState();
}

class _AvailablePickMeCardState extends State<AvailablePickMeCard> {

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();

  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // context.read<ViewAllTripJoinCubit>().getTripJoin();

    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  final Map<String, DateTime> _lastTapTimes = {};


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: 20,
        itemBuilder: (context,index){
          return  Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
            ),
            child:SizedBox(),
          );
        });
  }


}



