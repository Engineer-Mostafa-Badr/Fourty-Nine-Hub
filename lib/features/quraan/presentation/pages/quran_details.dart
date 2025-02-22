import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_cubit.dart';
import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../core/widget/custom_scaffold.dart';

class QuranViewPage extends StatefulWidget {
  final int surahId;
  final int pageNumber;

  const QuranViewPage({
    super.key,
    required this.surahId,
    required this.pageNumber,
  });

  @override
  State<QuranViewPage> createState() => _QuranViewPageState();
}

class _QuranViewPageState extends State<QuranViewPage> {
  late PageController _pageController;
  late QuranCubit _quranCubit;
  List<List<SurahEntity>> pages = [];
  int currentSurahId = 1;

  @override
  void initState() {
    super.initState();
    _quranCubit = serviceLocator<QuranCubit>();
    currentSurahId = widget.surahId;
    _pageController = PageController(initialPage: widget.pageNumber);
    _fetchSurah(currentSurahId);
  }

  void _fetchSurah(int surahId) {
    _quranCubit.fetchSurah(id: surahId);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'القران الكريم',
              style: TextStyle(fontSize: 40.sp),
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Pop the current screen
              },
            ),
          ],
        ),
      ),
      body: BlocProvider.value(
        value: _quranCubit, // Provide the existing instance of QuranCubit
        child: BlocConsumer<QuranCubit, QuranState>(
          listener: (context, state) {
            if (state.status == QuranStates.success) {
              setState(() {
                pages = _paginateAyahs(context, state.surah!);
              });
            }
          },
          builder: (context, state) {
            if (state.status == QuranStates.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == QuranStates.success &&
                pages.isNotEmpty) {
              return PageView.builder(
                controller: _pageController,
                itemCount: pages.length + 1, // +1 for loading the next surah
                reverse: true,
                onPageChanged: (index) {
                  if (index == pages.length) {
                    _loadNextSurah();
                  }
                },
                itemBuilder: (context, index) {
                  if (index == pages.length) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Loading next surah
                  }
                  return buildPageContent(index, pages[index]);
                },
              );
            }
            return Container(); // Placeholder for other states
          },
        ),
      ),
    );
  }

  void _loadNextSurah() {
    setState(() {
      currentSurahId++;
      pages = [];
    });
    _fetchSurah(currentSurahId); // Fetch the next Surah
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<List<SurahEntity>> _paginateAyahs(
      BuildContext context, List<SurahEntity> ayahs) {
    List<List<SurahEntity>> pages = [];
    List<SurahEntity> currentPage = [];
    double availableHeight = MediaQuery.of(context).size.height - 200.h;
    double currentHeight = 0;

    for (var ayah in ayahs) {
      double ayahHeight = _estimateAyahHeight(context, ayah);
      if (currentHeight + ayahHeight > availableHeight) {
        pages.add(currentPage);
        currentPage = [];
        currentHeight = 0;
      }
      currentPage.add(ayah);
      currentHeight += ayahHeight;
    }
    if (currentPage.isNotEmpty) pages.add(currentPage);
    return pages;
  }

  double _estimateAyahHeight(BuildContext context, SurahEntity ayah) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: ayah.ayahAr,
        style: TextStyle(
          fontSize: 40.sp,
          fontFamily: 'Amiri',
        ),
      ),
      maxLines: null,
      textDirection: TextDirection.rtl,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 16);

    return textPainter.size.height + 50.h;
  }

  Widget buildPageContent(int pageIndex, List<SurahEntity> pageAyahs) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (pageIndex == 0)
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
                    text: 'سُورَةٌ ${pageAyahs[0].surahNameAr}',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 45.sp,
                    ),
                  ),
                ],
              ),
            if (pageIndex == 0 &&
                pageAyahs[0].surahNameAr != 'الفاتحة' &&
                pageAyahs[0].surahNameAr != 'التوبة')
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
                children: pageAyahs.map((ayah) {
                  return Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: ayah.ayahAr,
                            style: TextStyle(
                              fontSize: 45.sp,
                              height: 2.0,
                              fontFamily: 'Amiri',
                              color: Theme.of(context).primaryColor,
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
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';
// import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_cubit.dart';
// import 'package:fourtyninehub/features/quraan/presentation/cubit/quraan_state.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
//
// class QuranViewPage extends StatefulWidget {
//   final int surahId;
//   final int pageNumber;
//
//   QuranViewPage({
//     Key? key,
//     required this.surahId,
//     required this.pageNumber,
//   }) : super(key: key);
//
//   @override
//   State<QuranViewPage> createState() => _QuranViewPageState();
// }
//
// class _QuranViewPageState extends State<QuranViewPage> {
//   late PageController _pageController;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: widget.pageNumber);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       body: BlocProvider<QuranCubit>(
//         create: (context) => serviceLocator()..fetchSurah(id: widget.surahId),
//         child: BlocBuilder<QuranCubit, QuranState>(
//           builder: (context, state) {
//             if (state.status == QuranStates.loading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state.status == QuranStates.success) {
//               final pages = _paginateAyahs(context, state.surah!);
//               return PageView.builder(
//                 controller: _pageController,
//                 itemCount: pages.length,
//                 reverse: true,
//                 itemBuilder: (context, index) {
//                   return buildPageContent(index, pages[index]);
//                 },
//               );
//             }
//             return Container(); // Placeholder for other states
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   List<List<SurahEntity>> _paginateAyahs(BuildContext context, List<SurahEntity> ayahs) {
//     List<List<SurahEntity>> pages = [];
//     List<SurahEntity> currentPage = [];
//     double availableHeight = MediaQuery.of(context).size.height - 200.h; // Adjust height based on other elements
//     double currentHeight = 0;
//
//     for (var ayah in ayahs) {
//       double ayahHeight = _estimateAyahHeight(context, ayah);
//       if (currentHeight + ayahHeight > availableHeight) {
//         pages.add(currentPage);
//         currentPage = [];
//         currentHeight = 0;
//       }
//       currentPage.add(ayah);
//       currentHeight += ayahHeight;
//     }
//     if (currentPage.isNotEmpty) pages.add(currentPage);
//     return pages;
//   }
//
//   double _estimateAyahHeight(BuildContext context, SurahEntity ayah) {
//     final textPainter = TextPainter(
//       text: TextSpan(
//         text: ayah.ayahAr,
//         style: TextStyle(
//           fontSize: 40.sp,
//           fontFamily: 'Amiri',
//         ),
//       ),
//       maxLines: null,
//       textDirection: TextDirection.rtl,
//     )..layout(maxWidth: MediaQuery.of(context).size.width - 16); // Adjust padding if needed
//
//     return textPainter.size.height + 50.h; // Extra height for Ayah marker
//   }
//
//   Widget buildPageContent(int pageIndex, List<SurahEntity> pageAyahs) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             if (pageIndex == 0)
//               Stack(
//                 alignment: AlignmentDirectional.center,
//                 children: [
//                   SizedBox(
//                     height: 100.h,
//                     child: Image.asset(
//                       "assets/images/888-02.png",
//                       height: 100.h,
//                       width: double.infinity,
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                   Label(
//                     text: 'سُورَةٌ${pageAyahs[0].surahNameAr}',
//                     style: TextStyle(
//                       fontFamily: 'Amiri',
//                       fontSize: 45.sp,
//                     ),
//                   )
//                 ],
//               ),
//             if (pageIndex == 0 && pageAyahs[0].surahNameAr != 'الفاتحة' && pageAyahs[0].surahNameAr != 'التوبة')
//               SizedBox(
//                 height: 90.h,
//                 child: Image.asset(
//                   "assets/images/Basmala.png",
//                   height: 90.h,
//                   color: Theme.of(context).primaryColor,
//                   width: double.infinity,
//                 ),
//               ),
//             Directionality(
//               textDirection: TextDirection.rtl,
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 children: pageAyahs.map((ayah) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: ayah.ayahAr,
//                             style: TextStyle(
//                               fontSize: 40.sp,
//                               height: 2.0,
//                               fontFamily: 'Amiri',
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           WidgetSpan(
//                             alignment: PlaceholderAlignment.middle,
//                             child: Stack(
//                               alignment: AlignmentDirectional.center,
//                               children: [
//                                 Image.asset(
//                                   'assets/images/ayah.png',
//                                   height: 50.h,
//                                   width: 50.w,
//                                 ),
//                                 Text(
//                                   '${ayah.ayahNoSurah}',
//                                   style: TextStyle(
//                                     fontSize: 25.sp,
//                                     color: AppColors.PRIMARY_COLOR,
//                                     fontFamily: 'Amiri',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
