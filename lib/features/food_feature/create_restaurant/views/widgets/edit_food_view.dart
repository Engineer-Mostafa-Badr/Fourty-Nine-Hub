// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
// import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
// import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
// import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/mneu/show_menu.dart';
// import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
// import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/build_food_list.dart';
// import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/item_card.dart';
// import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/restaurant_header.dart';
// import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
//
// class EditFoodView extends StatefulWidget {
//   final String restaurantId;
//
//   const EditFoodView({super.key, required this.restaurantId});
//
//   @override
//   State<EditFoodView> createState() => _EditFoodViewState();
// }
//
// class _EditFoodViewState extends State<EditFoodView> {
//   final ApiConsumer apiConsumer =
//       BaseApiConsumer(serviceLocator(), serviceLocator());
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     context.read<RestaurantDetailsCubit>().loadData(id: widget.restaurantId);
//     _scrollToEnd();
//   }
//
//   void _scrollToEnd() {
//     // Use animateTo for smooth scrolling, or jumpTo for instant scrolling
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: Duration(seconds: 1), // You can adjust the duration
//       curve: Curves.easeInOut,
//     );
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _removeItem({foodId}) async {
//     final res = await apiConsumer
//         .delete('https://49dev.com/api/v1/food/delete-food-item/$foodId');
//
//     res.fold((l) {}, (r) {
//       print(r.toString() + "wefwrgeagethethw");
//       context.read<RestaurantDetailsCubit>().loadData(id: widget.restaurantId);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<RestaurantDetailsCubit>().state;
//     print(widget.restaurantId + 'sgslkhflsjmsdf');
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(
//         controller: _scrollController,
//         children: [
//           // if (state.restaurant != null)
//           //   // RestaurantHeader(restaurant: state.restaurant!),
//           // const Divider(),
//
//           state.meals?.isNotEmpty ?? false
//               ? Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: state.meals?.length ?? 0,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       RestaurantMenu? meal = state.meals?[index];
//                       return Slidable(
//                         key: UniqueKey(),
//                         endActionPane: ActionPane(
//                           motion: const ScrollMotion(),
//                           children: [
//                             SlidableAction(
//                               onPressed: (context) {
//                                 _removeItem(foodId: meal!.id!);
//                               },
//                               backgroundColor: Colors.red,
//                               foregroundColor: Colors.white,
//                               icon: Icons.delete,
//                               label: 'Delete',
//                             ),
//                           ],
//                         ),
//                         child: ItemCard(
//                           meal: meal!,
//                           restaurantId: widget.restaurantId,
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               : const SizedBox(),
//
//           MultiBlocProvider(
//             providers: [
//               BlocProvider.value(
//                 value: RestaurantMenuCubit(serviceLocator()),
//               ),
//               BlocProvider<CreateRestaurantCubit>.value(
//                 value: serviceLocator()..loadData(),
//               )
//             ],
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ShowMneu(
//                   from: 'update',
//                   subcategoryId: state.restaurant!.subcategoryId!.id),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/mneu/show_menu.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/build_food_list.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/item_card.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/restaurant_header.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class EditFoodView extends StatefulWidget {
  var restaurantId;

  EditFoodView({super.key, required payload}) {
    if (payload is String) {
      restaurantId = payload;
    } else {
      restaurantId = payload[''];
    }
  }

  @override
  State<EditFoodView> createState() => _EditFoodViewState();
}

class _EditFoodViewState extends State<EditFoodView> {
  final ApiConsumer apiConsumer =
      BaseApiConsumer(serviceLocator(), serviceLocator());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<RestaurantDetailsCubit>().loadData(id: widget.restaurantId);

    // Trigger scroll to the end after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  // Scroll to the end when called
  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        _scrollController.animateTo(
          maxScroll,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Remove item from server and refresh the list
  Future<void> _removeItem({required String foodId}) async {
    final res = await apiConsumer
        .delete('https://49dev.com/api/v1/food/delete-food-item/$foodId');

    res.fold(
      (failure) {
        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete item')),
        );
      },
      (r) async {
        // Refresh restaurant details on success
       await  context
            .read<RestaurantDetailsCubit>()
            .loadData(id: widget.restaurantId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
    final state = context.watch<RestaurantDetailsCubit>().state;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        controller: _scrollController,
        children: [
          if (state.meals?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.meals?.length ?? 0,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      RestaurantMenu? meal = state.meals?[index];
                      return Slidable(
                        key: UniqueKey(),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                if (meal != null) {
                                  _removeItem(foodId: meal.id!);
                                }
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ItemCard(
                          fromUpdate:true,
                          meal: meal!,
                          restaurantId: widget.restaurantId,
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          else
            const SizedBox(),

          // MultiBlocProvider remains unchanged as it does not impact scrolling behavior
          MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: RestaurantMenuCubit(serviceLocator()),
              ),
              BlocProvider<CreateRestaurantCubit>.value(
                value: serviceLocator()..loadData(),
              )
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShowMneu(
                from: 'update',
                subcategoryId: state.restaurant?.subcategoryId?.id ?? '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
