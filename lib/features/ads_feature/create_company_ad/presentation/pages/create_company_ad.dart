import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/company_advertise/company_advertise_state.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../data/repositories/company_advertise_repo/company_advertise_repo_impl.dart';
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
  var postContentTextController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        centerTitle: false,
        label: 'Company Advertise', //adds files
      ),
      body: BlocBuilder<AdvertisePriceCubit, AdvertisePriceState>(
        builder: (context, state) {
          // final controller = context.read<CreateCompanyAdCubit>();
          if (state is AdvertisePriceSuccess) {
           return BlocProvider(
             create: (context) =>
             CompanyAdvertiseCubit(serviceLocator.get<CompanyAdvertiseRepoImpl>())
               ..fetchAdvertiseCompany(context,'written'),
             child: BlocConsumer<CompanyAdvertiseCubit,CompanyAdvertiseState>(
               listener: (BuildContext context, state) {
                 if (state is AddCompanyAdvertiseSuccess) {
                   showSuccessMessage(context, 'Post Successfully');
                   Navigator.of(context).pop();
                   //postContentTextController.clear();
                 } else if (state is AddCompanyAdvertiseError) {
                   showSuccessMessage(context, state.errMessage);
                 }
               },
               builder: (BuildContext context, Object? advertise) {
                 if( advertise is FetchAllCompanyAdvertiseSuccess) {
                   final pricePerPost = state.advertisePriceModel.data!.advertisementPostPrice;
                   final numberOfAdvertises = advertise.advertiseCompanyModel.data!.advertises!.length;

                   final totalPrice = pricePerPost! * numberOfAdvertises;
                   return Form(
                   key: formKey,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       children: [
                         Expanded(
                           child: Column(
                             children: [
                               _buildContainer(
                                 numberOfAdvertises: numberOfAdvertises,
                                 advertise: advertise.advertiseCompanyModel.data!.advertises!.isNotEmpty,
                                 title: 'Text only',
                                 price: '$totalPrice',
                                 context: context,
                                 function: () {
                                      if (formKey.currentState!.validate()) {
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => CreatePostCompany(
                                           picture: false,
                                           title: 'Create Text Post',
                                           postContentTextController:
                                           postContentTextController,
                                           function: () {
                                             CompanyAdvertiseCubit.get(
                                                 context)
                                                 .addPostCompanyAdvertise(
                                               context: context,
                                               post:
                                               postContentTextController
                                                   .text,
                                               type: 'written',
                                               totalPrice: state
                                                   .advertisePriceModel
                                                   .data!
                                                   .advertisementPostPrice!,
                                             );
                                           },
                                         )),
                                   );
                                    }
                                 },
                               ),
                               _buildContainer(
                                 numberOfAdvertises: numberOfAdvertises,
                                 advertise: advertise.advertiseCompanyModel.data!.advertises!.isNotEmpty,

                                 title: 'Picture only',
                                 price: '${state.advertisePriceModel.data!.advertisementPhotoPrice}',
                                 context: context,
                                 function: () {
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => CreatePostCompany(
                                           text: false,
                                           title: 'Create Picture Post',
                                           function: () {
                                             CompanyAdvertiseCubit.get(
                                                 context)
                                                 .addPostCompanyAdvertise(
                                               context: context,
                                               media: [],
                                               type: 'written',
                                               totalPrice: state
                                                   .advertisePriceModel
                                                   .data!
                                                   .advertisementPostPrice!,
                                             );
                                           },
                                         )),
                                   );
                                 },
                               ),
                               _buildContainer(
                                 numberOfAdvertises: numberOfAdvertises,
                                 advertise: advertise.advertiseCompanyModel.data!.advertises!.isNotEmpty,

                                 title: 'Text with pictures',
                                 price:
                                 '${state.advertisePriceModel.data!.advertisementPostAndPhotoPrice}',
                                 context: context,
                                 function: () {
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => CreatePostCompany(
                                           title: 'Create Post',
                                           function: () {},
                                         )),
                                   );
                                 },
                               ),
                               _buildContainer(
                                 numberOfAdvertises: numberOfAdvertises,
                                 advertise: advertise.advertiseCompanyModel.data!.advertises!.isNotEmpty,

                                 title: 'Reel',
                                 price:
                                 '${state.advertisePriceModel.data!.advertisementReelPrice}',
                                 context: context,
                                 function: () {
                                 },
                               ),
                             ],
                           ),
                         ),
                         Row(
                           children: [
                             Expanded(
                               child: Container(
                                 margin: EdgeInsetsDirectional.only(bottom: 35.zH),
                                 padding: const EdgeInsetsDirectional.symmetric(
                                     vertical: 10, horizontal: 10),
                                 width: double.infinity,
                                 decoration: BoxDecoration(
                                   color: Theme.of(context).primaryColor,
                                   borderRadius: BorderRadius.circular(20.zR),
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
                                       '10',
                                       style: Styles.mediumText(
                                           color: Theme.of(context)
                                               .scaffoldBackgroundColor),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                             const SizedBox(
                               width: 5,
                             ),
                             Expanded(
                               child: Container(
                                 margin: EdgeInsetsDirectional.only(bottom: 35.zH),
                                 padding: const EdgeInsetsDirectional.symmetric(
                                     vertical: 10, horizontal: 10),
                                 width: double.infinity,
                                 decoration: BoxDecoration(
                                   color: AppColors.SECONDARY_COLOR,
                                   borderRadius: BorderRadius.circular(20.zR),
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
                   ),
                 );
                 }return const SizedBox.shrink();
               },
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

  Widget _buildContainer({
    required String title,
    required String price,
    required Function function,
    int? numberOfAdvertises,
    advertise,
    context,
  }) =>
      GestureDetector(
        onTap: () {
          function();
        },
        child: Container(
          margin: EdgeInsetsDirectional.only(bottom: 35.zH),
          padding: const EdgeInsetsDirectional.symmetric(
              vertical: 7, horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20.zR),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: Styles.headerText(
                    color: Theme.of(context).scaffoldBackgroundColor),
              ),
              const SizedBox(
                width: 6,
              ),
              if(advertise)
                Text(
                  '($numberOfAdvertises)',
                  style: Styles.mediumText(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              const Spacer(),
              if(advertise)
              Text(
                price,
                style: Styles.mediumText(
                    color: Theme.of(context).scaffoldBackgroundColor),
              ),
              IconButton(
                onPressed: () {},
                icon:  Icon(
                  Icons.check_circle,
                  color:advertise? AppColors.SECONDARY_COLOR:Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      );
}
