import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/shared/fourty_nine_shared_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainCategoriesFlipCardsView extends StatelessWidget {
  const MainCategoriesFlipCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final mainCategories = FourtyNineSharedData.instance.mainCategories;
    return Scaffold(
      appBar: const BackAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // InkWell(
          //     onTap: ()=>context.pop(),
          //     child: Icon(Icons.arrow_back,size: 40.w,)),
          Expanded(
            child: CardSwiper(
              padding: EdgeInsets.only(left: 10.w,right: 10.w,bottom: 20.h),
              cardsCount: mainCategories.length,
              cardBuilder:
                  (context, index, percentThresholdX, percentThresholdY) {
                return GestureDetector(
                  onTap: () {
                    context.push(Routes.SUBCATEGORIES,
                        extra: mainCategories[index]);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
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
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 0,
                            child: CachedNetworkImage(
                              imageUrl: mainCategories[index].cover,
                              fit: BoxFit.cover,
                            ),
                          ),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      child: Text(
                                        mainCategories[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 60.sp,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Text(
                                      ' ${mainCategories[index].total} Ads',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
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
