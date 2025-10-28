import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_loading_search_widget.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_category_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/medical_services/medical_service_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class HealthFavoritesView extends StatefulWidget {
  const HealthFavoritesView({super.key});

  @override
  State<HealthFavoritesView> createState() => _HealthFavoritesViewState();
}

class _HealthFavoritesViewState extends State<HealthFavoritesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Label(
          text: context.isArabic ? 'المفضلة' : 'Favorites',
          style: Styles.headerText(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: AppColors.getTextColor(context),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.SECONDARY_COLOR,
          unselectedLabelColor:
              AppColors.getTextColor(context).withOpacity(0.6),
          indicatorColor: AppColors.SECONDARY_COLOR,
          tabs: [
            Tab(
              text: context.isArabic ? 'التخصصات' : 'Specialties',
            ),
            Tab(
              text: context.isArabic ? 'الخدمات الطبية' : 'Medical Services',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoritesSubcategories(),
          _buildFavoritesMedicalServices(),
        ],
      ),
    );
  }

  Widget _buildFavoritesSubcategories() {
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
        if (state.status == HealthStates.loading) {
          return const CustomLoadingSearchWidget();
        }

        // Filter favorite subcategories
        final favoriteSubcategories = state.subCategories
                ?.where((subcategory) => subcategory.isFavorite == true)
                .toList() ??
            [];

        if (favoriteSubcategories.isEmpty) {
          return _buildEmptyState(
            context.isArabic
                ? 'لا توجد تخصصات مفضلة'
                : 'No favorite specialties',
            context.isArabic
                ? 'اضغط على القلب لإضافة تخصصات للمفضلة'
                : 'Tap the heart to add specialties to favorites',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<HealthCubit>().getSubCategories();
          },
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: favoriteSubcategories.length,
            separatorBuilder: (context, index) => const Sizer(),
            itemBuilder: (context, index) {
              return HealthSubCategoryCard(
                subCategory: favoriteSubcategories[index],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFavoritesMedicalServices() {
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
        if (state.status == HealthStates.loading) {
          return const CustomLoadingSearchWidget();
        }

        // Filter favorite medical services
        final favoriteMedicalServices = state.medicalServices
                ?.where((service) => service.isFavorite == true)
                .toList() ??
            [];

        if (favoriteMedicalServices.isEmpty) {
          return _buildEmptyState(
            context.isArabic
                ? 'لا توجد خدمات طبية مفضلة'
                : 'No favorite medical services',
            context.isArabic
                ? 'اضغط على القلب لإضافة خدمات طبية للمفضلة'
                : 'Tap the heart to add medical services to favorites',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<HealthCubit>().getServices();
          },
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: favoriteMedicalServices.length,
            separatorBuilder: (context, index) => const Sizer(),
            itemBuilder: (context, index) {
              return HealthMedicalServiceCard(
                subCategory: favoriteMedicalServices[index],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.h,
            color: AppColors.getTextColor(context).withOpacity(0.3),
          ),
          const Sizer(height: 16),
          Label(
            text: title,
            style: Styles.headerText(
              fontSize: 24,
              color: AppColors.getTextColor(context).withOpacity(0.7),
            ),
          ),
          const Sizer(height: 8),
          Label(
            text: subtitle,
            style: Styles.mediumText(
              color: AppColors.getTextColor(context).withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
