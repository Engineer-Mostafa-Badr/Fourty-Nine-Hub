import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/models/get_requests_pick_me_model.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/presentation/widgets/pick_me_request_history_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class GetRequestsPickMeView extends StatelessWidget {
  final List<PickMeRequest> pickMeRequests;
  const GetRequestsPickMeView({super.key, required this.pickMeRequests});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
        child: Column(
          children: [
            pickMeRequests.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: Center(
                      child: Text(LocaleKeys.noTripRequests.localize),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: pickMeRequests.length,
                      itemBuilder: (context, index) {
                        return PickMeRequestHistoryCard(
                          pickMeRequest: pickMeRequests[index],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
