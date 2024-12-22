import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/localization/localization_service.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Custom Page"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: const Drawer(),
      body: BlocProvider<CustomPageCubit>(
        create: (BuildContext context) => serviceLocator()..fetchActivate(),
        child: BlocConsumer<CustomPageCubit, CustomPageState>(
          listener: (BuildContext context, CustomPageState state) {
            if(state.status ==CustomPageStates.updateSuccess){
              if(state.activate!.customPage ==true){
                context.pushReplacementNamed(Routes.CUSTOMPAGE);
              }else{
                context.pushReplacementNamed(Routes.HOME);
              }
              print('''''''''''''''object''''''''''''''');
            }
          },
          builder: (BuildContext context, state) {
            var controller = context.read<CustomPageCubit>();
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Activate Custom Page',
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Switch(
                        value: state.activate?.customPage ?? false,
                        onChanged: (v) {
                          controller.updateActivate(v);

                          // Dynamically navigate based on the switch value
                          // if (v) {
                          //   // Navigate to Custom Page
                          //   context.pushReplacementNamed(Routes.CUSTOMPAGE);
                          // } else {
                          //   // Navigate to Home Page
                          //   context.pushReplacementNamed(Routes.HOME);
                          // }
                        },
                        activeColor: Colors.red,
                        inactiveThumbColor: Colors.black,
                        activeTrackColor: Colors.grey,
                        inactiveTrackColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Edit Page', style: TextStyle(fontSize: 18.sp)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditPage(),
                      ),
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                ),
                ListTile(
                  title: Text('Page Preview', style: TextStyle(fontSize: 18.sp)),
                  onTap: () {
                    context.push(Routes.PAGEPREVIEW);
                  },
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
