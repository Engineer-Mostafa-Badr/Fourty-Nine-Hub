import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../res/assets/assets.dart';

class RideModeScreen extends StatefulWidget {
  const RideModeScreen({super.key});

  @override
  State<RideModeScreen> createState() => _RideModeScreenState();
}

class _RideModeScreenState extends State<RideModeScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SharedScaffold(
          mainCategoryId: 2,
          isWithBackArrow: false,
          body: NestedAppbar(
            scrollController: _scrollController,
            appBars: const [],
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: const Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.arrow_back),
                          Text('Ride Mode',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                         
                        ],
                      ),
                    ),
                     SizedBox(height: 50,
                            child: TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black,
                              
                              indicator: BoxDecoration(
                                color: Colors.indigo.shade900,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tabs:  [
                                Tab(text: "Available Trips"),
                                Tab(text: "Running Trips"),
                                Tab(text: "Past Trips"),
                                Tab(child: SvgPicture.asset(Assets.option,color: Colors.black,)),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
