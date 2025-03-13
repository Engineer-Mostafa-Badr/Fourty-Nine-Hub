import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_cubit.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_state.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/assets/assets.dart';

class AzkarView extends StatefulWidget {
  const AzkarView({super.key});

  @override
  State<AzkarView> createState() => _AzkarViewState();
}

class _AzkarViewState extends State<AzkarView> {
  late ScrollController _scrollController;
  late AzkarCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AzkarCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadInitialData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchAzkar();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      // centerTitle: true,
      // titleTextStyle:
      //     const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      // surfaceTintColor: Colors.transparent,
      // title: Text(
      //   'الاذكار',
      //   style: TextStyle(fontSize: 40.sp),
      // ),
      // ),
      enableCustomAppBar: true,
      appBar: BackAppBar(
        label: LocaleKeys.azkar.localize,
        enableCustomAppBar: true,
      ),
      body: BlocBuilder<AzkarCubit, AzkarState>(
        builder: (BuildContext context, state) {
          if (state.status == AzkarStates.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 20.w,
            //     mainAxisSpacing: 20.h,
            //     childAspectRatio: 1 / .8),
            itemCount: state.akar!.length,
            itemBuilder: (context, index) {
              if (index == _cubit.azkar.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return InkWell(
                onTap: () {
                  context.push(Routes.AZKAARDETAILS,
                      extra: state.akar![index].name);
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                            Assets.azkarPrayer), // Image stays on the left
                        Expanded(
                          child: Align(
                            alignment: Alignment.center, // Center the text
                            child: Text(
                              state.akar![index].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 40.sp,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 10.h);
            },
          );
        },
      ),
    );
  }
}
