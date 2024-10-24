import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_quran_surah_use_case.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_cubit.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_state.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class QuraanView extends StatelessWidget {
  const QuraanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(label: 'Quran'), // AppBar remains the same
      body: Directionality(
        textDirection: TextDirection.rtl, // Set the whole screen to RTL
        child: BlocProvider<QuranCubit>(
          create: (BuildContext context) => serviceLocator()..loadData(),
          child: BlocBuilder<QuranCubit, QuranState>(
            builder: (BuildContext context, state) {
              var controller=context.read<QuranCubit>();
              return Padding(
                  padding: EdgeInsets.all(12.w),
                  child: PagedListView<int, QuranSurahEntity>(
                    pagingController: controller.quranSurahPagingController,
                    builderDelegate: PagedChildBuilderDelegate<
                        QuranSurahEntity>(
                      itemBuilder: (context, item, index) {
                        return InkWell(
                          onTap: () {
                            // context.push(Routes.SUBCATEGORIES,
                            //     extra: state.search![index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: buildItem(
                              context,
                               item,
                            ),
                          ),
                        );
                      },
                      noMoreItemsIndicatorBuilder: (context) => Container(),
                      firstPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator(),
                      newPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator(),
                    ),
                  ),
                // child: ListView.separated(
                //   itemBuilder: (context,index)=>buildItem(context),
                //   separatorBuilder: (context,index)=>const Divider(color: AppColors.GREY_NORMAL_COLOR,),
                //   itemCount: 10,
                // ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildItem(context,QuranSurahEntity model) =>
      Row(
        children: [
          Container(
            width: 100.w,
             height: 100.h,
             // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Label(
                text: '${model.surahNo}',
                style: Styles.headerText(
                    color: Theme
                        .of(context)
                        .scaffoldBackgroundColor),
              )),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Text(
                    model.surahNameAr,
                    style: Styles.headerText(
                        color: Theme
                            .of(context)
                            .primaryColor),
                    textAlign: TextAlign.right,
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        'اياتها',
                        style: Styles.headerText(
                            color: Theme
                                .of(context)
                                .primaryColor),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        '7',
                        style: Styles.headerText(
                            color: Theme
                                .of(context)
                                .primaryColor),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const Sizer(),
                  Image.asset(
                    Assets.maka,
                    height: 70.h,
                    width: 70.w,
                  )
                ],
              ),
            ),
          ),
        ],
      );
}
