import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../core/localization/locales.dart';
import '../../../subcategories/presentation/pages/custom_page_sub_categories_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class MainCategoriesCardsParams {
  final List<MainCategoryEntity>? data;
  final bool isCustomPage;

  MainCategoriesCardsParams({
    this.data,
    required this.isCustomPage,
  });
}

class MainCategoriesFlipCardsView extends StatefulWidget {
  const MainCategoriesFlipCardsView({
    super.key,
    this.isAppBarShow = true,
    required this.mainCategoriesCardsParams,
  });

  final bool isAppBarShow;
  final MainCategoriesCardsParams mainCategoriesCardsParams;

  @override
  _MainCategoriesFlipCardsViewState createState() =>
      _MainCategoriesFlipCardsViewState();
}

class _MainCategoriesFlipCardsViewState
    extends State<MainCategoriesFlipCardsView> {
  late MainCategoriesCubit mainCategoriesCubit;

  // ✅ إضافة Controller للكارد
  final CardSwiperController _cardController = CardSwiperController();

  String labelName = "";
  bool _hasShownHint = false; // ✅ للتأكد من عرض الحركة مرة واحدة فقط

  @override
  void initState() {
    super.initState();
    mainCategoriesCubit = context.read<MainCategoriesCubit>();

    // ✅ تحريك الكارد بشكل بسيط بعد ثانية من الدخول
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_hasShownHint) {
        _showSwipeHint();
      }
    });
  }

  // ✅ دالة لتحريك الكارد قليلاً ثم إرجاعها
  void _showSwipeHint() async {
    _hasShownHint = true;

    // تحريك الكارد قليلاً لليمين
    _cardController.swipe(CardSwiperDirection.right);

    // الانتظار قليلاً
    await Future.delayed(const Duration(milliseconds: 200));

    // إرجاع الكارد لمكانها
    if (mounted) {
      _cardController.undo();
    }
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.mainCategoriesCardsParams.data != null) {
      labelName = context.isArabic
          ? (widget.mainCategoriesCardsParams.data != null &&
                  widget.mainCategoriesCardsParams.data!.isNotEmpty)
              ? widget.mainCategoriesCardsParams.data![0].name ?? ''
              : ''
          : (widget.mainCategoriesCardsParams.data != null &&
                  widget.mainCategoriesCardsParams.data!.isNotEmpty)
              ? widget.mainCategoriesCardsParams.data![0].nameEn ?? ''
              : '';
    }
    if (mainCategoriesCubit.state.customPage != null) {
      labelName = context.isArabic
          ? mainCategoriesCubit.state.customPage![0].name.toString()
          : mainCategoriesCubit.state.customPage![0].nameEn.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    var mainCategories = <MainCategoryEntity>[];
    print(
        'BuildContext data is ${widget.mainCategoriesCardsParams.data?.first.nameEn}');
    if (widget.mainCategoriesCardsParams.data != null) {
      mainCategories = widget.mainCategoriesCardsParams.data!;
    } else if (mainCategoriesCubit.state.customPage != null) {
      mainCategories = mainCategoriesCubit.state.customPage!;
    }

    return Scaffold(
      appBar: widget.isAppBarShow
          ? PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: BackAppBar(
                label: mainCategories.isNotEmpty ? labelName : '',
              ),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: widget.isAppBarShow
                ? MediaQuery.sizeOf(context).height * .7
                : 400,
            child: mainCategories.isEmpty
                ? Center(
                    child: Label(
                      text: LocaleKeys.noCategoriesAvailable.localize,
                    ),
                  )
                : CardSwiper(
                    controller: _cardController, // ✅ إضافة الـ controller
                    padding:
                        EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
                    cardsCount: mainCategories.length,
                    isLoop: false, // ✅ لمنع التكرار اللانهائي
                    allowedSwipeDirection: const AllowedSwipeDirection.all(),
                    onSwipe: (previousIndex, currentIndex, direction) {
                      if (currentIndex != null &&
                          currentIndex >= 0 &&
                          currentIndex < mainCategories.length) {
                        setState(() {
                          labelName = (context.locale == Locales.english
                              ? mainCategories[currentIndex].nameEn
                              : mainCategories[currentIndex].name)!;
                        });
                      }
                      return true;
                    },
                    onUndo: (previousIndex, currentIndex, direction) {
                      // ✅ للتعامل مع حالة الـ undo
                      if (currentIndex >= 0 &&
                          currentIndex < mainCategories.length) {
                        setState(() {
                          labelName = (context.locale == Locales.english
                              ? mainCategories[currentIndex].nameEn
                              : mainCategories[currentIndex].name)!;
                        });
                      }
                      return true;
                    },
                    cardBuilder:
                        (context, index, percentThresholdX, percentThresholdY) {
                      return GestureDetector(
                        onTap: () {
                          ManageVibration.vibrate();
                          final item = mainCategories[index];
                          print('item id is ${item.id}');
                          if (item.id == '62c8b5b09332225799fe335e') {
                            context.push(Routes.MARRIAGESUBCATEGORIES,
                                extra: item);
                          } else {
                            context.push(
                              Routes.CustomPageSubCategoriesView,
                              extra: CustomPageSubCategoriesParams(
                                mainCategory: item,
                                isCustomPage: widget
                                    .mainCategoriesCardsParams.isCustomPage,
                              ),
                            );
                          }
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                mainCategories[index].banner,
                              ),
                            ),
                            gradient: const LinearGradient(
                              colors: [Colors.black, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black38,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  spreadRadius: 0.03,
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              context.isArabic
                                                  ? mainCategories[index]
                                                          .name ??
                                                      ''
                                                  : mainCategories[index]
                                                          .nameEn ??
                                                      '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 60.sp,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          const SizedBox(height: 100),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}



          // Expanded(
          //   child: CardSwiper(
          //     padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
          //     cardsCount: mainCategories.length,
          //     onSwipe: (previousIndex, currentIndex, direction) {
          //       setState(() {
          //         labelName = context.locale == Locales.english
          //             ? mainCategoriesCubit
          //                 .state.customPage![currentIndex!].nameEn
          //                 .toString()
          //             : mainCategoriesCubit
          //                 .state.customPage![currentIndex!].name
          //                 .toString();
          //       });
          //       return true;
          //     },
          //     cardBuilder:
          //         (context, index, percentThresholdX, percentThresholdY) {
          //       return GestureDetector(
          //         onTap: () {
          //           if (mainCategories[index].id ==
          //               '62c8b5b09332225799fe335e') {
          //             context.push(Routes.MARRIAGESUBCATEGORIES,
          //                 extra: mainCategories[index]);
          //           } else {
          //             context.push(
          //               Routes.CustomPageSubCategoriesView,
          //               extra: mainCategories[index],
          //             );
          //           }
          //         },
          //         child: DecoratedBox(
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(16.0),
          //             image: DecorationImage(
          //               fit: BoxFit.fill,
          //               image: CachedNetworkImageProvider(
          //                 mainCategories[index].banner,
          //               ),
          //             ),
          //             gradient: const LinearGradient(
          //               colors: [Colors.black, Colors.white],
          //               begin: Alignment.topCenter,
          //               end: Alignment.bottomCenter,
          //             ),
          //           ),
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(16.0),
          //             child: Stack(
          //               children: [
          //                 Positioned.fill(
          //                   child: DecoratedBox(
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(10),
          //                       boxShadow: const [
          //                         BoxShadow(
          //                           color: Colors.black38,
          //                         ),
          //                       ],
          //                     ),
          //                     child: Padding(
          //                       padding: const EdgeInsetsDirectional.all(8),
          //                       child: Column(
          //                         mainAxisAlignment: MainAxisAlignment.end,
          //                         crossAxisAlignment: CrossAxisAlignment.center,
          //                         children: [
          //                           Container(
          //                             decoration: BoxDecoration(
          //                                 borderRadius:
          //                                     BorderRadius.circular(10),
          //                                 boxShadow: const [
          //                                   BoxShadow(
          //                                     color: Colors.black26,
          //                                     spreadRadius: 0.03,
          //                                     blurRadius: 6,
          //                                   ),
          //                                 ]),
          //                             child: Text(
          //                               mainCategories[index].name ?? '',
          //                               style: TextStyle(
          //                                 fontWeight: FontWeight.bold,
          //                                 fontSize: 60.sp,
          //                                 color: Colors.white,
          //                               ),
          //                               textAlign: TextAlign.start,
          //                             ),
          //                           ),
          //                           const SizedBox(
          //                             height: 100,
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),