import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/locales.dart';
import '../../../../core/widget/custom_scaffold.dart';

class MainCategoriesFlipCardsView extends StatefulWidget {
  const MainCategoriesFlipCardsView(
      {super.key, this.isAppBarShow = true, this.data});
  final bool isAppBarShow;
  final List<MainCategoryEntity>? data;

  @override
  _MainCategoriesFlipCardsViewState createState() =>
      _MainCategoriesFlipCardsViewState();
}

class _MainCategoriesFlipCardsViewState
    extends State<MainCategoriesFlipCardsView> {
  late MainCategoriesCubit mainCategoriesCubit;

  String labelName = "";

  @override
  void initState() {
    super.initState();
    mainCategoriesCubit = context.read<MainCategoriesCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    labelName = context.locale == Locales.english
        ? mainCategoriesCubit.state.data != null
            ? mainCategoriesCubit.state.data![0].nameEn.toString()
            : widget.data![0].nameEn.toString()
        : mainCategoriesCubit.state.data != null
            ? mainCategoriesCubit.state.data![0].name.toString()
            : widget.data![0].name.toString();
  }

  @override
  Widget build(BuildContext context) {
    var mainCategories = mainCategoriesCubit.state.data ?? [];
    // mainCategories = widget.data!;

    return CustomScaffold(
      appBar: widget.isAppBarShow
          ? BackAppBar(
              label: mainCategories.isNotEmpty ? labelName : '',
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CardSwiper(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
              cardsCount: mainCategories.length,
              onSwipe: (previousIndex, currentIndex, direction) {
                setState(() {
                  labelName = context.locale == Locales.english
                      ? mainCategoriesCubit.state.data![currentIndex!].nameEn
                          .toString()
                      : mainCategoriesCubit.state.data![currentIndex!].name
                          .toString();
                });
                return true;
              },
              cardBuilder:
                  (context, index, percentThresholdX, percentThresholdY) {
                return GestureDetector(
                  onTap: () {
                    if(mainCategories[index].id=='62c8b5b09332225799fe335e'){
                      context.push(Routes.MARRIAGESUBCATEGORIES,
                          extra: mainCategories[index]);
                    }else{
                      context.push(
                        Routes.SUBCATEGORIES,
                        extra: mainCategories[index],
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
                          mainCategories[index].cover,
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
                                padding: const EdgeInsetsDirectional.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.23),
                                              spreadRadius: 0.03,
                                              blurRadius: 6,
                                            ),
                                          ]),
                                      child: Text(
                                        mainCategories[index].name ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 60.sp,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 100,
                                    )
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
