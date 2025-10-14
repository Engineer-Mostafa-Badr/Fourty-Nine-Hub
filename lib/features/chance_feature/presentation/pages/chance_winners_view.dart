import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../account_taps/wallet/presentation/widgets/winners_grid_view.dart';
import '../../../account_taps/wallet/presentation/widgets/winner.dart';
import '../controller/cubit/chance_cubit.dart';
import '../controller/cubit/chance_states.dart';

class ChanceWinnersView extends StatefulWidget {
  const ChanceWinnersView({super.key});

  @override
  State<ChanceWinnersView> createState() => _ChanceWinnersViewState();
}

class _ChanceWinnersViewState extends State<ChanceWinnersView> {
  @override
  void initState() {
    super.initState();
    // Load chance winners data
    // context.read<ChanceCubit>().getChanceWinners();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          labelSize: 32,
          enableCustomAppBar: true,
          label: context.isArabic ? 'الفائزون' : 'Winners',
        ),
      ),
      body: BlocBuilder<ChanceCubit, ChanceState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.isFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.isArabic
                        ? 'خطأ في تحميل البيانات'
                        : 'Error loading data',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      ManageVibration.vibrate();
                      // context.read<ChanceCubit>().getChanceWinners();
                    },
                    child: Text(
                      context.isArabic ? 'إعادة المحاولة' : 'Retry',
                    ),
                  ),
                ],
              ),
            );
          }

          // Get winners data from state
          final winners = _getWinnersFromState(state);

          if (winners.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 80.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.isArabic
                        ? 'لا توجد فائزين حتى الآن'
                        : 'No winners yet',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return WinnersGridView(
            winners: winners,

            hasReachedMax: true, // For now, we'll assume no pagination
            paginationOnpressed: () {
              ManageVibration.vibrate();
              // Add pagination logic here if needed
              // context.read<ChanceCubit>().getChanceWinners();
            },
            mainAxisExtent: 315.h,
          );
        },
      ),
    );
  }

  List<WinnersGridViewModel> _getWinnersFromState(ChanceState state) {
    // For now, we'll create sample data since the actual winners data structure
    // depends on your API. You can modify this to use actual data from state.

    // If you have actual winners data in your state, replace this with:
    // return state.chanceWinners?.map((winner) => WinnersGridViewModel(...)).toList() ?? [];

    return [
      WinnersGridViewModel(
        image:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
        name: 'أحمد محمد',
        title: 'iPhone 15 Pro',
        date: '2024-03-21',
        price: '50000',
        currencyAr: 'جنيه',
        currencyEn: 'EGP',
      ),
      WinnersGridViewModel(
        image:
            'https://images.unsplash.com/photo-1494790108755-2616b612b566?w=200&h=200&fit=crop&crop=face',
        name: 'فاطمة أحمد',
        title: 'Samsung Galaxy S24',
        date: '2024-03-20',
        price: '35000',
        currencyAr: 'جنيه',
        currencyEn: 'EGP',
      ),
      WinnersGridViewModel(
        image:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
        name: 'محمد علي',
        title: 'MacBook Pro',
        date: '2024-03-19',
        price: '75000',
        currencyAr: 'جنيه',
        currencyEn: 'EGP',
      ),
      WinnersGridViewModel(
        image:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face',
        name: 'نور حسن',
        title: 'iPad Air',
        date: '2024-03-18',
        price: '25000',
        currencyAr: 'جنيه',
        currencyEn: 'EGP',
      ),
      WinnersGridViewModel(
        image:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop&crop=face',
        name: 'يوسف أحمد',
        title: 'PlayStation 5',
        date: '2024-03-17',
        price: '30000',
        currencyAr: 'جنيه',
        currencyEn: 'EGP',
      ),
      WinnersGridViewModel(
        image:
            'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=200&h=200&fit=crop&crop=face',
        name: 'سارة محمود',
        title: 'Apple Watch',
        date: '2024-03-16',
        price: '15000',
        currencyAr: 'جنيه',
        currencyEn: 'EGP',
      ),
    ];
  }
}
