import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/widget/call_message_buttons.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../add_new_trip_join/presentation/views/widgets/card.dart';
import '../../../get_requests_pick_me/data/models/get_requests_pick_me_model.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';

class PickMeRequestHistoryCard extends StatefulWidget {
  const PickMeRequestHistoryCard({
    super.key,
    required this.pickMeRequest,
  });

  final PickMeRequest pickMeRequest;

  @override
  State<PickMeRequestHistoryCard> createState() =>
      _PickMeRequestHistoryCardState();
}

class _PickMeRequestHistoryCardState extends State<PickMeRequestHistoryCard> {
  final userId = serviceLocator<UserCubit>().isLoggedIn
      ? serviceLocator<UserCubit>().state.data?.id
      : '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: CustomCard(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300]!, offset: const Offset(3, 3)),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  widget.pickMeRequest.gender == 'female'
                      ? Assets.femaleImagePlacehlder
                      : Assets.maleImagePlaceholder,
                  fit: BoxFit.cover,
                ),
              ),
              Sizer(width: 30.w),
              Text(widget.pickMeRequest.firstName ?? 'Unknown',
                  style: Styles.headerText()),
            ],
          ),
          const Sizer(),
          CallMessageButtons(
            id: userId ?? "",
            otherUserId: widget.pickMeRequest.userId!,
            phone: widget.pickMeRequest.phone!,
            subcategoryId: "62ea008d69ea29c91dfc3908",
            clientId: userId ?? "",
            hasReport: true,
          ),
          const Sizer(),
        ],
      ),
    );
  }
}
