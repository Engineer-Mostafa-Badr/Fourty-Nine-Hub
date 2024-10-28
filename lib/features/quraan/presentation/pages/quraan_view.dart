import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_cubit.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_state.dart';
import 'package:fourtyninehub/features/quraan/presentation/pages/quran_details.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class QuraanView extends StatefulWidget {
  const QuraanView({super.key});

  @override
  State<QuraanView> createState() => _QuraanViewState();
}

class _QuraanViewState extends State<QuraanView> {
  late ScrollController _scrollController;
  late QuranCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<QuranCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadInitialData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchQuranSurah();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(label: 'Quran'), // AppBar remains the same
      body: Directionality(
        textDirection: TextDirection.rtl, // Set the whole screen to RTL
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (BuildContext context, state) {
            if(state.status ==QuranStates.loading){
              return const CustomLoading();
            }
            var controller=context.read<QuranCubit>();
            return Padding(
                padding: EdgeInsets.all(12.w),
                // child: InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => QuranViewPage(
                //           surahId: state.quranSurah![index].surahNo, pageNumber: 1,),
                //       ),
                //     );
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.only(bottom: 8.0),
                //     child: buildItem(
                //       context,
                //       state.quranSurah![index],
                //     ),
                //   ),
                // )
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context,index) {
                  if (index == _cubit.quran.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuranViewPage(
                            surahId: state.quranSurah![index].surahNo, pageNumber: 0,),
                        ),
                      );
                    },
                    child: buildItem(context,state.quranSurah![index]));
                },
                separatorBuilder: (context,index)=>const Divider(color: AppColors.GREY_NORMAL_COLOR,),
                itemCount: state.quranSurah?.length ??0,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildItem(context,QuranSurahEntity model) =>
      Row(
        children: [
          Container(
            width: 80.w,
             height: 80.h,
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Label(
                  text: '${model.surahNo}',
                  style: Styles.headerText(
                      color: Theme
                          .of(context)
                          .scaffoldBackgroundColor),
                ),
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
                       '${ model.total_ayah_surah}',
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
                   model.place_of_revelation=='Meccan'? Assets.maka:Assets.madina,
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
