import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/carousel_slider.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/slider_item_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/slider_cubit.dart/slider_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../core/states/basic_state.dart';

class AnnounceWidget extends StatelessWidget {
  const AnnounceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderCubit, BasicState<List<SliderItemEntity>>>(
        builder: (context, state) {
      if (state.data?.isEmpty ?? false) {
        // print('data is empty');
        return const SizedBox();
      } else {
        return CarouselSliderWidget(
            height: 200.h,
            autoPlay: true,
            widgets: state.data?.map((e) {
                  return _buildAnnounceItem(item: e);
                }).toList() ??
                []);
      }
    });
  }

  Widget _buildAnnounceItem({required SliderItemEntity item}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
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
                    Colors.black.withOpacity(.2),
                    Colors.black.withOpacity(.4),
                    Colors.black.withOpacity(.6),
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
                      text: item.title),
                  Label(
                      style: Styles.smallText(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                      text: item.subTitle),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
