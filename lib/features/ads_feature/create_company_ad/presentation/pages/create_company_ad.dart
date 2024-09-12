import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/custom_container.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/show_post_company_advertise.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../payment/presentation/cubit/payment_cubit.dart';
import '../../../../payment/presentation/pages/payment_view.dart';
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
    return Scaffold(
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
                  icon: Icon(
                    Icons.access_time_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: context.read<UserCubit>().isLoggedIn
          ? BlocBuilder<CreateCompanyAdCubit, CreateCompanyAdState>(
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
                                      voiceUrl: '',
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
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  vertical: 10, horizontal: 14),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
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
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: GestureDetector(
                              onTap:totalPrice > 0? (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider<PaymentCubit>(
                                      create: (BuildContext context) =>
                                          serviceLocator(),
                                      child: PaymentView(
                                        amountId: '',
                                        amount: totalPrice,
                                      ),
                                    ),
                                  ),
                                );
                              }:(){},
                              child: Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    vertical: 10, horizontal: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: totalPrice > 0
                                      ? AppColors.SECONDARY_COLOR
                                      : AppColors.SECONDARY_COLOR.withOpacity(.5),
                                  borderRadius: BorderRadius.circular(20),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () => context.push(Routes.LOGIN),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Please Login, Register to enjoy the app',
                        style: Styles.headerText(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
