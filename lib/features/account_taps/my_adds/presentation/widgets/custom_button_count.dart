import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/presentation/cubit/my_adds_cubit.dart';
import '../../../../../common/widgets/stateless/pages/empty.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/call_message_buttons.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../domain/entity/get_all_counts_trip_join_entity.dart';
import '../../domain/usecases/get_all_counts_usecase.dart';

class CustomButtonCount extends StatelessWidget {
  const CustomButtonCount({super.key, required this.id, required this.status});

  final String id;
  final String status;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.requestTripJoin.localize,
        ),
      ),
      body: BlocProvider<MyAddsCubit>(
        create: (BuildContext context) => serviceLocator()
          ..getAllCount(params: Params(id: id, status: status))
          ..getMyTripJoin(),
        child: BlocConsumer<MyAddsCubit, MyAddsState>(
          listener: (BuildContext context, MyAddsState state) {},
          builder: (BuildContext context, state) {
            if (state.status == MyAddsStates.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == MyAddsStates.initState) {
              if (state.allCounts == null || state.allCounts!.isEmpty) {
                return const EmptyPage();
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return buildItem(
                      context,
                      state.allCounts![index],
                    );
                  },
                  separatorBuilder: (context, index) => const Sizer(),
                  itemCount: state.allCounts?.length ?? 0,
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget buildItem(
    context,
    GetAllCountsTripJoinEntity model,
  ) =>
      Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: kToolbarHeight * 2.5.h,
                  width: kToolbarHeight * 2.5.w,
                  child: ImageFromInternet(
                    isCircle: true,
                    image: model.gender == 'male'
                        ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwC-ZR1TdJ7VIAMeqhjm-u29-HB0PyAuSFFQ&s'
                        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKc-oaCL6lH4WNLuY-A6H7UyEJmZQ5HdN6Os89NNXXANez6DAEM9SJdKu-Drj6L2LSfpM&usqp=CAU',
                  ),
                ),
                const Sizer(),
                Label(
                  text: model.firstName,
                  style: Styles.headerText(),
                ),
              ],
            ),
            Sizer(
              height: 10.h,
            ),
            CallMessageButtons(
              otherUserId: model.userIdId,
              subcategoryId: model.categoryId,
              phone: model.phone,
              id: model.tripId,
              hasReport: true,
            ),
          ],
        ),
      );
}
