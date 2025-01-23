import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainCategoriesFlipCardsView extends StatelessWidget {
  const MainCategoriesFlipCardsView({super.key, this.isAppBarShow = true});
  final bool isAppBarShow;
  @override
  Widget build(BuildContext context) {
    print(context.read<MainCategoriesCubit>().state.data?[0].image);
    return Scaffold(
      appBar: isAppBarShow ? const BackAppBar() : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CardSwiper(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.h),
              cardsCount:
                  context.read<MainCategoriesCubit>().state.data?.length ?? 0,
              cardBuilder:
                  (context, index, percentThresholdX, percentThresholdY) {
                return GestureDetector(
                  onTap: () {
                    context.push(Routes.SUBCATEGORIES,
                        extra: context
                            .read<MainCategoriesCubit>()
                            .state
                            .data?[index]);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(context
                                .read<MainCategoriesCubit>()
                                .state
                                .data?[index]
                                .cover ??
                            ''),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      child: Text(
                                        context
                                                .read<MainCategoriesCubit>()
                                                .state
                                                .data?[index]
                                                .name ??
                                            '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 60.sp,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    // Text(
                                    //   ' ${context.read<MainCategoriesCubit>().state.data?[index].total ?? 0} Ads',
                                    //   style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize: 32.sp,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    //   textAlign: TextAlign.end,
                                    // ),
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
