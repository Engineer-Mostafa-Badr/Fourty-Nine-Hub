import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/custom_container.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/show_post_company_advertise.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/widget/custom_text_no_login.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../cubit/create_company_ad_cubit.dart';
import 'create_posts_company.dart';

class CreateCompanyAdView extends StatefulWidget {
  const CreateCompanyAdView({super.key});

  @override
  State<CreateCompanyAdView> createState() => _CreateCompanyAdViewState();
}

class _CreateCompanyAdViewState extends State<CreateCompanyAdView> {
  num totalPrice = 0; // Initialize total price
  Map<String, num> containerPrices = {
    'written': 0,
    'photo': 0,
    'photo_written': 0,
    'reel': 0
  }; // Store prices of all containers

  void updateTotalPrice(String filter, num price) {
    setState(() {
      // Update the price of the corresponding container
      containerPrices[filter] = price;

      // Recalculate the total price
      totalPrice = containerPrices.values.fold(0, (sum, item) => sum + item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(
        centerTitle: false,
        label: LocaleKeys.companyAdvertise.localize,
        actions: [
          context.read<UserCubit>().isLoggedIn
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShowPostCompanyAdvertise(),
                      ),
                    );
                  },
                  icon: Image.asset(Assets.clock,width: 40.w,),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: context.read<UserCubit>().isLoggedIn
          ? BlocConsumer<CreateCompanyAdCubit, CreateCompanyAdState>(
              listener: (BuildContext context, CreateCompanyAdState state) {
                if (state.status == StateStatus.error) {
                  showErrorMessage(
                    context,
                    getFailureMessage(
                      state.failure!,
                      context,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            CustomContainerAdvertise(
                              filter: 'written',
                              title: LocaleKeys.textOnly.localize,
                              price: state.price?.postPrice ?? 0,
                              context: context,
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatePostCompany(
                                      picture: false,
                                      title: LocaleKeys.createTextPost.localize,
                                      type: 'written',
                                      totalPrice: state.price?.postPrice ?? 0,
                                    ),
                                  ),
                                );
                              },
                              onTotalPriceUpdated: (price) {
                                updateTotalPrice('written', price);
                              }, // Toggle total price
                            ),
                            CustomContainerAdvertise(
                              filter: 'photo',
                              title: LocaleKeys.pictureOnly.localize,
                              price: state.price?.photoPrice ?? 0,
                              context: context,
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatePostCompany(
                                      text: false,
                                      title:
                                          LocaleKeys.createPicturePost.localize,
                                      type: 'photo',
                                      totalPrice: state.price?.photoPrice ?? 0,
                                    ),
                                  ),
                                );
                              },
                              onTotalPriceUpdated: (price) {
                                updateTotalPrice('photo', price);
                              }, // Toggle total price
                            ),
                            CustomContainerAdvertise(
                              filter: 'photo_written',
                              title: LocaleKeys.textWithPictures.localize,
                              price: state.price?.postAndPhotoPrice ?? 0,
                              context: context,
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatePostCompany(
                                      title: LocaleKeys.createPost.localize,
                                      type: 'photo_written',
                                      totalPrice:
                                          state.price?.postAndPhotoPrice ?? 0,
                                    ),
                                  ),
                                );
                              },
                              onTotalPriceUpdated: (price) {
                                updateTotalPrice('photo_written', price);
                              }, // Toggle total price
                            ),
                            CustomContainerAdvertise(
                              filter: 'reel',
                              title: LocaleKeys.reel.localize,
                              price: state.price?.reelPrice ?? 0,
                              context: context,
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReelsRecordingScreen(
                                      voiceMediaId: '',
                                      totalPrice:
                                          '${state.price?.reelPrice ?? 0}',
                                      advertisementType: 'reel',
                                      comeFromCompany: 'company',
                                    ),
                                  ),
                                );
                              },
                              onTotalPriceUpdated: (price) {
                                updateTotalPrice('reel', price);
                              }, // Toggle total price
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 15.h, horizontal: 15.w),
                            width: 196,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  LocaleKeys.total.localize,
                                  style: Styles.headerText(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                                const Spacer(),
                                Text(
                                  '$totalPrice', // Display the total price here
                                  style: Styles.mediumText(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: totalPrice > 0
                                ? () {
                                    // context
                                    //     .read<CreateCompanyAdCubit>()
                                    //     .payCompanyAd(
                                    //       PayCompanyAdParams(amount: totalPrice),
                                    //     );
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => BlocProvider<PaymentCubit>(
                                    //       create: (BuildContext context) => serviceLocator(),
                                    //       child: PaymentView(
                                    //         amountId: '',
                                    //         amount: totalPrice,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // );
                                  }
                                : () {},
                            child: Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                  vertical: 15.h, horizontal: 15.w),
                              width: 196,
                              decoration: BoxDecoration(
                                color: totalPrice > 0
                                    ? AppColors.SECONDARY_COLOR
                                    : AppColors.SECONDARY_COLOR
                                        .withValues(alpha: .5),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.pay.localize,
                                  style: Styles.headerText(
                                    color: AppColors.AUTH_CONTAINER_COLOR,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : const CustomNotLogged(),
    );
  }
}
