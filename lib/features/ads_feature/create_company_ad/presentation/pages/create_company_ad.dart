import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/custom_container.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/pages/widgets/show_post_company_advertise.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/company_advertise/company_advertise_cubit.dart';
import '../cubit/company_advertise_price/advertise_price_cubit.dart';
import '../cubit/company_advertise_price/advertise_price_state.dart';
import 'create_posts_company.dart';

class CreateCompanyAdView extends StatefulWidget {
  const CreateCompanyAdView({super.key});

  @override
  State<CreateCompanyAdView> createState() => _CreateCompanyAdViewState();
}

class _CreateCompanyAdViewState extends State<CreateCompanyAdView> {
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<CompanyAdvertiseCubit>()
          .fetchAdvertiseCompany(context, 'written');
      context
          .read<CompanyAdvertiseCubit>()
          .fetchAdvertiseCompany(context, 'photo');
      context
          .read<CompanyAdvertiseCubit>()
          .fetchAdvertiseCompany(context, 'photo_written');
      context
          .read<CompanyAdvertiseCubit>()
          .fetchAdvertiseCompany(context, 'reel');
    });
  }

  void _updateTotalPrice(int price) {
    setState(() {
      _totalPrice += price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        centerTitle: false,
        label: 'Company Advertise',
        actions: [
          IconButton(
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
              ))
        ],
      ),
      body: BlocBuilder<AdvertisePriceCubit, AdvertisePriceState>(
        builder: (context, state) {
          if (state is AdvertisePriceSuccess) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CustomContainerAdvertise(
                          filter: 'written',
                          title: 'Text only',
                          price: state.advertisePriceModel.data!
                              .advertisementPostPrice!,
                          context: context,
                          function: () {
                            _updateTotalPrice(state.advertisePriceModel.data!
                                .advertisementPostPrice!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreatePostCompany(
                                        picture: false,
                                        title: 'Create Text Post',
                                        type: 'written',
                                        totalPrice: state.advertisePriceModel
                                            .data!.advertisementPostPrice!,
                                      )),
                            );
                          },
                        ),
                        CustomContainerAdvertise(
                          filter: 'photo',
                          title: 'Picture only',
                          price: state.advertisePriceModel.data!
                              .advertisementPhotoPrice!,
                          context: context,
                          function: () {
                            _updateTotalPrice(state.advertisePriceModel.data!
                                .advertisementPhotoPrice!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreatePostCompany(
                                        text: false,
                                        title: 'Create Picture Post',
                                        type: 'photo',
                                        totalPrice: state.advertisePriceModel
                                            .data!.advertisementPhotoPrice!,
                                      )),
                            );
                          },
                        ),
                        CustomContainerAdvertise(
                          filter: 'photo_written',
                          title: 'Text with pictures',
                          price: state.advertisePriceModel.data!
                              .advertisementPostAndPhotoPrice!,
                          context: context,
                          function: () {
                            _updateTotalPrice(state.advertisePriceModel.data!
                                .advertisementPostAndPhotoPrice!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreatePostCompany(
                                        title: 'Create Post',
                                        type: 'photo_written',
                                        totalPrice: state
                                            .advertisePriceModel
                                            .data!
                                            .advertisementPostAndPhotoPrice!,
                                      )),
                            );
                          },
                        ),
                        CustomContainerAdvertise(
                          filter: 'reel',
                          title: 'Reel',
                          price: state.advertisePriceModel.data!
                              .advertisementReelPrice!,
                          context: context,
                          function: () {
                            _updateTotalPrice(state.advertisePriceModel.data!
                                .advertisementReelPrice!);
                            // Handle reel creation logic here
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10, horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Total',
                                style: Styles.headerText(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                              const Spacer(),
                              Text(
                                '$_totalPrice',
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
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10, horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.SECONDARY_COLOR,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Pay',
                              style: Styles.headerText(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is AdvertisePriceError) {
            return Center(
              child: Text(
                state.errMessage,
                textAlign: TextAlign.center,
                style: Styles.mediumText(),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
