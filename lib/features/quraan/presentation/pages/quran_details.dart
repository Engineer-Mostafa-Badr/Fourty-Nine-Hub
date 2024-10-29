library quran;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_cubit.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
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
              return ListView.builder(
                controller: _pageController,
                itemCount: 1,
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
                    height: 100.h,
                    child: Image.asset(
                      "assets/images/888-02.png",
                      height: 100.h,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Label(
                    text: 'سُورَةٌ${ayahs[index].surahNameAr}',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 45.sp,
                    ),
                  )
                ],
              ),
            if (ayahs[index].surahNameAr != 'الفاتحة' &&ayahs[index].surahNameAr != 'التوبة')
              SizedBox(
                height: 90.h,
                child: Image.asset(
                  "assets/images/Basmala.png",
                  height: 90.h,
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                ),
              ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: ayahs.map((ayah) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: ayah.ayahAr,
                            style: TextStyle(
                              fontSize: 40.sp,
                              height: 2.0,
                              fontFamily: 'Amiri',
                              color:Theme.of(context).primaryColor
                            ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Image.asset(
                                  'assets/images/ayah.png',
                                  height: 50.h,
                                  width: 50.w,
                                ),
                                Text(
                                  '${ayah.ayahNoSurah}',
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    color: AppColors.PRIMARY_COLOR,
                                    fontFamily: 'Amiri',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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