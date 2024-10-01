import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/widgets/trip_join_request_history_builder.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinRequestHistoryView extends StatefulWidget {
  const TripJoinRequestHistoryView({
    super.key,
    required this.extra,
  });
  final Map<String, dynamic> extra;

  @override
  State<TripJoinRequestHistoryView> createState() =>
      _TripJoinRequestHistoryViewState();
}

class _TripJoinRequestHistoryViewState
    extends State<TripJoinRequestHistoryView> {
  late final String id;
  @override
  void initState() {
    id = widget.extra['id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Transform(
          transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
          child: Text(
            LocaleKeys.TripJoinRequestHistory.localize,
            style: Styles.headerText(),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: TripJoinRequestHistoryBuilder(id: id),
      ),
    );
  }
}
