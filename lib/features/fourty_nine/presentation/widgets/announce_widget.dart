import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/carousel_slider.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/slider_item_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/slider_cubit.dart/slider_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/states/basic_state.dart';
import '../../../../routes/routes.dart';
import '../../../payment/presentation/pages/widgets/payment_yellow_card.dart';

class AnnounceWidget extends StatelessWidget {
  const AnnounceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderCubit, BasicState<List<SliderItemEntity>>>(
        builder: (context, state) {
      if (state.isLoading) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[100]!,
          highlightColor: Colors.white24,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.grey),
            width: double.infinity,
            height: 200.h,
          ),
        );
      } else {
        if (state.data?.isEmpty ?? false) {
          // print('data is empty');
          return const SizedBox();
        } else {
          return CarouselSliderWidget(
              height: 150.h,
              autoPlay: true,
              widgets: state.data?.map((e) {
                    return _buildAnnounceItem(item: e, context: context);
                  }).toList() ??
                  []);
        }
      }
    });
  }

  Widget _buildAnnounceItem(
      {required SliderItemEntity item, required BuildContext context}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: () {
            print(item.id);
            print(item.titleEn);
            if (UserCubit.to.isLoggedIn == false) {
              context.push(Routes.LOGIN);
              return;
            }
            if (item.id == '67700fc734004152c40f8b71') {
              context.push(Routes.GIFT);
            } else if (item.id == '6770102e34004152c40f8b9a') {
              context.push(Routes.CASHBACK);
            } else if (item.id == '67700f4934004152c40f8b48') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentYellowCard(
                            fromSlider: true,
                          )));
              //    Navigator.push(
              // context,
              // MaterialPageRoute(
              // builder: (context) => BlocProvider<PaymentCubit>(
              // create: (BuildContext context) =>
              // serviceLocator(),
              // child: const PaymentCashOut(),
              // ),
              // ),
              // );
            }
            // context.push(Routes.GIFT);
          },
          child: Stack(
            children: [
              Positioned.fill(
                  child: Image.network(
                item.image,
                fit: BoxFit.cover,
              )),
              Positioned.fill(
                  child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.black.withOpacity(.4),
                      Colors.black.withOpacity(.6),
                      Colors.black.withOpacity(.8),
                    ])),
              )),
              Positioned.fill(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Label(
                        style: Styles.headerText(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                        text: context.isArabic ? item.titleAr : item.titleEn),
                    const Sizer(),
                    Label(
                        style: Styles.smallText(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                        text: context.isArabic
                            ? item.subTitleAr
                            : item.subTitleEn),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
