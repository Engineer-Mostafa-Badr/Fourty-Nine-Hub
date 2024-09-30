import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../../res/style/styles.dart';
import '../../../domain/entities/company_ad_entity.dart';
import '../../cubit/create_company_ad_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildItemTextPost extends StatelessWidget {
  BuildItemTextPost(
      {super.key,
      required this.advertises,
      this.isScalable = true,
      required this.onDeleteItem});

  final CompanyAdEntity advertises;
  final Function(String) onDeleteItem;
  bool? isScalable;

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = DateTime.parse(advertises.createdAt!);
    final DateTime egyptTime = createdAt.toUtc().add(const Duration(hours: 3));
    final String formattedDayTime =
        DateFormat('EEEE, h:mm a').format(egyptTime);

    return BlocProvider<CreateCompanyAdCubit>(
      create: (BuildContext context) => serviceLocator(),
      child: BlocConsumer<CreateCompanyAdCubit, CreateCompanyAdState>(
        listener: (BuildContext context, state) {
          if (state.status == StateStatus.success) {
            showSuccessMessage(context, LocaleKeys.deleteSuccessfully.localize);
          }
        },
        builder: (BuildContext context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 5.h),
              isScalable!
                  ? Slidable(
                      key: ValueKey(advertises.sId),
                      endActionPane: ActionPane(
                        dragDismissible: false,
                        extentRatio: 0.2,
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {
                              onDeleteItem(advertises.sId!);
                            },
                            child: Container(
                              constraints: BoxConstraints(minHeight: 120.h),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 40.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Theme.of(context).primaryColor),
                              child: Icon(
                                Icons.delete_outlined,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      child: buildItem(context),
                    )
                  : buildItem(context),
              SizedBox(height: 2.h),
              Text(formattedDayTime),
            ],
          );
        },
      ),
    );
  }

  Widget buildItem(context) {
    return Container(
      constraints:  BoxConstraints(minHeight: 120.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Theme.of(context).primaryColor,
      ),
      child: Text(
        advertises.post!,
        style: Styles.mediumText(
         // fontSize: 34.sp,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
