import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/LIst_view_card.dart';

import '../../../../helpers/manage_vibration.dart';
import '../../../../res/style/app_colors.dart';
import '../controller/cubit/chance_cubit.dart';

class ChanceViewBody extends StatefulWidget {
  const ChanceViewBody({super.key});

  @override
  State<ChanceViewBody> createState() => _ChanceViewBodyState();
}

class _ChanceViewBodyState extends State<ChanceViewBody> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.read<ChanceCubit>().searchChanceAds(query.trim());
      setState(() {
        _isSearching = true;
      });
    } else {
      context.read<ChanceCubit>().getAllChanceAds();
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ChanceCubit>().getAllChanceAds();
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Container(
                width: double.infinity,
                height: 220.h,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/chance.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.SHADOW_LIGHT,
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.GREY_NORMAL_COLOR),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.search.localize,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(color: AppColors.GREY_NORMAL_COLOR),
                      ),
                      onChanged: _performSearch,
                      onSubmitted: _performSearch,
                    ),
                  ),
                  if (_isSearching)
                    IconButton(
                      onPressed: () {
                        ManageVibration.vibrate();
                        _clearSearch();
                      },
                      icon: const Icon(Icons.clear, color: AppColors.GREY_NORMAL_COLOR),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const ListViewCard(),
          ],
        ),
      ),
    );
  }
}
