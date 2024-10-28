library quran;



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_cubit.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class QuranViewPage extends StatefulWidget {
  final int surahId;
  final int pageNumber;

  QuranViewPage({
    Key? key,
    required this.surahId,
    required this.pageNumber,
  }) : super(key: key);

  @override
  State<QuranViewPage> createState() => _QuranViewPageState();
}

class _QuranViewPageState extends State<QuranViewPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<QuranCubit>(
        create: (context) => serviceLocator()..fetchSurah(id: widget.surahId),
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state.status == QuranStates.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.status == QuranStates.success) {
              return PageView.builder(
                controller: _pageController,
                itemCount: state.surah?.length,
                itemBuilder: (context, index) {
                  return buildPageContent(index, state.surah!);
                },
              );
            }
            return Container(); // Placeholder for other states
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildPageContent(index, List<SurahEntity> ayahs) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (index == 0)
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SizedBox(
                    height: 70.h,
                    // color: const Color(0xffFFFCE7),
                    child: Image.asset(
                      "assets/images/888-02.png",
                      // fit: BoxFit.fill,
                      height: 70.h,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    left: 120.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // Minimize the space taken by the Column
                      textBaseline: TextBaseline.alphabetic,
                      // Align texts to baseline
                      children: [
                        Text(
                          'آيَاتُهَا',
                          style: Styles.smallText(fontSize: 30.sp),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                        ),
                        Text(
                          '${ayahs.length}',
                          style: Styles.smallText(fontSize: 30.sp),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 120.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // Minimize the space taken by the Column
                      textBaseline: TextBaseline.alphabetic,
                      // Align texts to baseline
                      children: [
                        Text(
                          'تَرْتِيبُهَا',
                          style: Styles.smallText(fontSize: 30.sp),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                        ),
                        Text(
                          '${ayahs[index].surahNo}',
                          style: Styles.smallText(fontSize: 30.sp),
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Label(
                    text: 'سُورَةٌ${ayahs[index].surahNameAr}',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 30.sp,
                    ),
                  )
                ],
              ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: ayahs.map((ayah) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            ayah.ayahAr,
                            textAlign: TextAlign.center,
                            maxLines: 100,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 50.sp,
                              height: 2.0,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Image.asset(
                              'assets/images/ayah.png',
                              height: 50.h,
                              width: 50.w,
                            ),
                            Text(
                              '${ayah.ayahNoSurah}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25.sp,
                                height: 2.0,
                                color: AppColors.PRIMARY_COLOR,
                                fontFamily: 'Amiri',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )

          ],
        ),
      ),
    );
  }
}