import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/messages/messages.dart';
import '../cubits/get_status_all_services_notifications/get_status_all_services_notifications_cubit.dart';

class ResponseStatusBuilder extends StatefulWidget {
  const ResponseStatusBuilder({super.key});

  @override
  State<ResponseStatusBuilder> createState() => _ResponseStatusBuilderState();
}

class _ResponseStatusBuilderState extends State<ResponseStatusBuilder> {
  @override
  void initState() {
    GetStatusAllServicesNotificationsCubit getUserTripsNotificationsCubit =
        context.read<GetStatusAllServicesNotificationsCubit>();
    getUserTripsNotificationsCubit.getStatusAllServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;/// بيجبر الwidgets تعمل rebuild لما اللغة تتغير (setState لما اللغه تتغير)
    return BlocConsumer<GetStatusAllServicesNotificationsCubit,
        GetStatusAllServicesNotificationsState>(
      listener: (context, state) {
        if (state is GetUserTripsNotificationsFailed) {
          showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<GetStatusAllServicesNotificationsCubit>();
        if (state is GetUserTripsNotificationsLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[100]!,
            highlightColor: Colors.white24,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  14,
                  (index) => Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is GetUserTripsNotificationsSuccess) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: cubit.status.length,
            itemBuilder: (context, index) {
              return Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      constraints:  BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                      ),
                      // color: Colors.red,
                      child: Label(
                        text: context.isArabic
                            ? cubit.status[index]['nameAr']!
                            : cubit.status[index]['nameEn']!,
                        style: Styles.mediumText(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: context.isDarkMode?Colors.white:Colors.black,
                        ),
                      ),
                    ),
                    // Spacer(),
                    Flexible(
                      child: Label(
                        text: context.isArabic
                            ? cubit.status[index]['valueAr']!
                            : cubit.status[index]['valueEn']!,
                        maxLines: 2,
                        textAlign: TextAlign.end,
                        style: Styles.mediumText(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: context.isDarkMode?Colors.white70: AppColors.PRIMARY_COLOR),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Sizer(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
