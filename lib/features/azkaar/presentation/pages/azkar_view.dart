import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_cubit.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_state.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'الاذكار',
              style:  TextStyle(fontSize: 40.sp),
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Pop the current screen
              },
            ),
          ],
        ),
      ),
      // appBar: BackAppBar(
      //   label: LocaleKeys.azkar.localize,
      // ),
      body: BlocBuilder<AzkarCubit,AzkarState>(
        builder: (BuildContext context, state) {
          if (state.status ==AzkarStates.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20.w,
                mainAxisSpacing: 20.h,
                childAspectRatio: 1 / .8),
            itemBuilder: (context, index) {
              if (index == _cubit.azkar.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return InkWell(
                onTap: (){
                  context.push(Routes.AZKAARDETAILS ,extra: state.akar![index].name);
                },
                child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                    child: Text(
                      state.akar![index].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 40.sp,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),

                    )),
                            ),
              );
            },
            itemCount: state.akar?.length,
          );
        },
      ),
    );
  }
}
