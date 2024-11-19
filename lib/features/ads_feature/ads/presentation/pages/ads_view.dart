import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/ad_card.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/mobile_ad_card.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/provider_ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/user_ads_view.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AdsView extends StatefulWidget {
  final AdsViewParams params;
  const AdsView({
    super.key,
    required this.params,
  });

  @override
  State<AdsView> createState() => _AdsViewState();
}

class _AdsViewState extends State<AdsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.params.mainCategory.nameEn == 'Dating') {
      context.read<AdvertisementCubit>().loadData(
          subCategoryId: widget.params.subCategory.id,
          filter: 'male',
          fromTab: true);
    } else {
      context.read<AdvertisementCubit>().loadData(
          subCategoryId: widget.params.subCategory.id,
          filter: widget.params.subCategory.hasAuction == true
              ? 'sale'
              : 'provider',
          fromTab: true);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userType = '';
    if (_tabController.index == 0 &&
        widget.params.mainCategory.nameEn == 'Dating') {
      userType = 'male';
    } else if (_tabController.index == 1 &&
        widget.params.mainCategory.nameEn == 'Dating') {
      userType = 'female';
    } else if (_tabController.index == 0 &&
        widget.params.subCategory.hasAuction == true) {
      userType = 'sale';
    } else if (_tabController.index == 1 &&
        widget.params.subCategory.hasAuction == true) {
      userType = 'rent';
      print('provider');
    } else if (_tabController.index == 0 &&
        widget.params.subCategory.hasAuction == false) {
      userType = 'provider';
      print('provider');
    } else {
      userType = 'user';
      print('user');
    }
    print(_tabController.index);
    return Scaffold(
      appBar: const HomeAppbar(),
      body: BlocConsumer<AdvertisementCubit, AdsState>(
          listener: (context, state) {
        if (state.status == AdsStates.loading) {
          print("state.status${state.status}");
        } else if (state.status == AdsStates.error) {
          print("state.status${state.status}");
        } else if (state.status == AdsStates.success) {
          print("state.status${state.status}");
        }
      }, builder: (context, state) {
        final controller = context.read<AdvertisementCubit>();
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  const Sizer(),
                  SizedBox(
                      width: double.infinity,
                      child: MainCategoryBanner(
                        category: widget.params.mainCategory,
                        onFavorite: () {},
                        isFavorite: widget.params.mainCategory.isFavorite,
                      )),
                  const Sizer(),
                  Label(
                    text: widget.params.subCategory.name,
                    style: Styles.headerText(),
                  ),
                  const Sizer(),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.SECONDARY_COLOR,
                    unselectedLabelColor: Theme.of(context).primaryColor,
                    indicatorColor: AppColors.SECONDARY_COLOR,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: Styles.headerText(),
                    onTap: (i) {
                      if (i == 1) {
                        state.city = '';
                        state.governorate = '';
                        if (widget.params.mainCategory.nameEn == 'Dating') {
                          controller.loadData(
                              subCategoryId: widget.params.subCategory.id,
                              filter: 'female',
                              fromTab: true);
                        } else {
                          controller.loadData(
                              subCategoryId: widget.params.subCategory.id,
                              filter:
                                  widget.params.subCategory.hasAuction == true
                                      ? 'rent'
                                      : 'user',
                              fromTab: true);
                        }
                      } else {
                        if (widget.params.mainCategory.nameEn == 'Dating') {
                          controller.loadData(
                              subCategoryId: widget.params.subCategory.id,
                              filter: 'male',
                              fromTab: true);
                        } else {
                          controller.loadData(
                              subCategoryId: widget.params.subCategory.id,
                              filter:
                                  widget.params.subCategory.hasAuction == true
                                      ? 'sale'
                                      : 'provider',
                              fromTab: true);
                        }
                      }
                    },
                    tabs: [
                      Tab(
                          text: widget.params.mainCategory.nameEn == 'Dating'
                              ? LocaleKeys.maleUser.localize
                              : widget.params.subCategory.hasAuction == true
                                  ? LocaleKeys.sale.localize
                                  : LocaleKeys.provider.localize),
                      Tab(
                          text: widget.params.mainCategory.nameEn == 'Dating'
                              ? LocaleKeys.femaleUser.localize
                              : widget.params.subCategory.hasAuction == true
                                  ? LocaleKeys.rent.localize
                                  : LocaleKeys.user.localize),
                    ],
                  ),
                  state.status == AdsStates.loading
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            ProviderAdsView(
                              params: widget.params,
                              userType: userType,
                              controller: controller,
                            ),
                            UserAdsView(
                              params: widget.params,
                              userType: userType,
                            ),
                          ],
                        ))
                ],
              ),
              if (state.isFilterLoading)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
        );
      }),
    );
  }
}

class AdsViewParams {
  final MainCategoryEntity mainCategory;
  final SubCategoryEntity subCategory;

  AdsViewParams({required this.mainCategory, required this.subCategory});
}

enum Categories {
  craft,
  talent,
  homeService,
  homeEssentials,
  healthyTools,
  scenery,
  realEstate,
  cars,
  vehicles,
  spareParts,
  fashionBeauty,
  accessories,
  jewelryWatches,
  collectiblesGifts,
  animals,
  computersCameras,
  mobilesTablets,
  musicalInstruments,
  fitness,
  education,
  libraries,
  packaging,
  equipment,
  rawMaterials,
  remnants,
  marketingSales,
  accountantJob,
  doctorJob,
  engineerJob,
  otherJob,
  events,
  health,
  dating,
}

extension CategoriesExtension on Categories {
  Widget view(
      {required AdEntity item,
      required Function(String) onFav,
      required Function(String) onRemoveFav}) {
    switch (this) {
      case Categories.craft:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.talent:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.homeService:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.homeEssentials:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.healthyTools:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.scenery:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.realEstate:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.cars:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.vehicles:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.spareParts:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.fashionBeauty:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.accessories:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.jewelryWatches:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.collectiblesGifts:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.animals:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.computersCameras:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.mobilesTablets:
        return MobileAdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.musicalInstruments:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.fitness:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.education:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.libraries:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.packaging:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.equipment:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.rawMaterials:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.remnants:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.marketingSales:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.accountantJob:
        return MobileAdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.doctorJob:
        return MobileAdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.engineerJob:
        return MobileAdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.otherJob:
        return MobileAdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.events:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.health:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      case Categories.dating:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
      default:
        return AdCard(item: item, onFav: onFav, onRemoveFav: onRemoveFav);
    }
  }

  static Categories fromNameEn(String nameEn) {
    switch (nameEn) {
      case "Craft":
        return Categories.craft;
      case "Talent":
        return Categories.talent;
      case "Home Service":
        return Categories.homeService;
      case "Home Essentials":
        return Categories.homeEssentials;
      case "Healthy Tools":
        return Categories.healthyTools;
      case "Scenery":
        return Categories.scenery;
      case "Real Estate":
        return Categories.realEstate;
      case "Cars":
        return Categories.cars;
      case "Vehicles":
        return Categories.vehicles;
      case "Spare Parts":
        return Categories.spareParts;
      case "Fashion/Beauty":
        return Categories.fashionBeauty;
      case "Accessories":
        return Categories.accessories;
      case "Jewelry/Watches":
        return Categories.jewelryWatches;
      case "Collectibles/Gifts":
        return Categories.collectiblesGifts;
      case "Animals":
        return Categories.animals;
      case "Computers/Cameras":
        return Categories.computersCameras;
      case "Mobiles/Tablets":
        return Categories.mobilesTablets;
      case "Musical Instruments":
        return Categories.musicalInstruments;
      case "Fitness":
        return Categories.fitness;
      case "Education":
        return Categories.education;
      case "Libraries":
        return Categories.libraries;
      case "Packaging":
        return Categories.packaging;
      case "Equipment":
        return Categories.equipment;
      case "Raw Materials":
        return Categories.rawMaterials;
      case "Remnants":
        return Categories.remnants;
      case "Marketing/Sales":
        return Categories.marketingSales;
      case "Accountant Job":
        return Categories.accountantJob;
      case "Doctor Job":
        return Categories.doctorJob;
      case "Engineer Job":
        return Categories.engineerJob;
      case "Other Job":
        return Categories.otherJob;
      case "Events":
        return Categories.events;
      case "Health":
        return Categories.health;
      case "Dating":
        return Categories.dating;
      default:
        throw ArgumentError("Invalid category nameEn: $nameEn");
    }
  }
}
