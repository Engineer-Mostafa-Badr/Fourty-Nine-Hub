import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/mneu/show_menu.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/pages/restaurant_dashboard_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/build_food_list.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/item_card.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/widgets/restaurant_header.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class EditFoodView extends StatefulWidget {
  final String restaurantId;

  EditFoodView({
    super.key,
    required dynamic payload,
  }) : restaurantId = payload is String
            ? payload
            : (payload['restaurantId'] as String?) ?? "";

  @override
  _EditFoodViewState createState() => _EditFoodViewState();
}

class _EditFoodViewState extends State<EditFoodView>
    with AutomaticKeepAliveClientMixin {
  static const String baseApiUrl = 'https://49dev.com/api/v1/food';
  static const String deleteFoodItemEndpoint = '$baseApiUrl/delete-food-item/';

  bool showValidator = false;

  final ApiConsumer apiConsumer =
      BaseApiConsumer(serviceLocator(), serviceLocator());

  final ScrollController _scrollController = ScrollController();
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String imagePath = "";
  final Duration _scrollDuration = const Duration(seconds: 1);
  final Curve _scrollCurve = Curves.easeInOut;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantDetailsCubit>().loadData(id: widget.restaurantId);
      _scrollToEnd();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    foodNameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        _scrollController.animateTo(
          maxScroll,
          duration: _scrollDuration,
          curve: _scrollCurve,
        );
      }
    }
  }

  Future<void> _removeItem({required String foodId}) async {
    final res = await apiConsumer.delete('$deleteFoodItemEndpoint$foodId');

    res.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete item')),
        );
      },
      (r) async {
        await context
            .read<RestaurantDetailsCubit>()
            .loadData(id: widget.restaurantId);
        showSuccessMessage(
          context,
          r['message'] as String? ?? "Item deleted successfully",
        );
      },
    );
  }

  void _onDeletePressed(RestaurantMenu meal) {
    if (meal.id != null) {
      showConfirmationDialog(
        context,
        title: "Delete Item",
        message: "Are you sure you want to remove this item?",
        onConfirm: () async {
          Navigator.pop(context);
          await _removeItem(foodId: meal.id!);
        },
      );
    }
  }

  Widget _buildMealsList(List<RestaurantMenu> meals) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: meals.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final meal = meals[index];
        if (meal.id == null) {
          return const SizedBox();
        }
        return Slidable(
          key: ValueKey(meal.id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _onDeletePressed(meal),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ItemCard(
            fromUpdate: true,
            meal: meal,
            restaurantId: widget.restaurantId,
          ),
        );
      },
    );
  }

  Widget _buildMenuForm(RestaurantDetailsState detailsState) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () async {
                      final subcategoryId =
                          detailsState.restaurant?.subcategoryId?.id;
                      if (subcategoryId != null) {
                        await context
                            .read<RestaurantMenuCubit>()
                            .uploadMealImage(
                              context,
                              subcategoryId: subcategoryId,
                            );
                      }
                    },
                    child:
                        BlocBuilder<RestaurantMenuCubit, RestaurantMenuState>(
                      builder: (context, state) {
                        if (state is RestaurantMenuImagePicked &&
                            state.imagePath.isNotEmpty) {
                          imagePath = state.imagePath;
                          return ImagePickerPlaceholder(
                            image: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return Container(
                          height: 195.h,
                          child: ImagePickerPlaceholder(
                            title: LocaleKeys.photoForMeal.tr(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: foodNameController,
                        hintText: LocaleKeys.itemName.tr(),
                        validatorMessage: LocaleKeys.emptyFieldNotValid.tr(),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                      _buildTextFormField(
                        controller: priceController,
                        hintText: LocaleKeys.price.tr(),
                        validatorMessage: LocaleKeys.emptyFieldNotValid.tr(),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedAppButton(
              onPressed: _onAddOrUpdatePressed,
              label: '',
              backColor: AppColors.SECONDARY_COLOR,
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          setState(() {
            showValidator = true;
          });
        } else {
          setState(() {
            showValidator = false;
          });
        }
        return null;
      },
      maxLines: null,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        constraints: BoxConstraints.loose(Size.fromHeight(90.h)),
        filled: false,
        contentPadding: const EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: Styles.mediumText(
          color: AppColors.SECONDARY_COLOR,
          fontSize: 32,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  void _onAddOrUpdatePressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      final foodName = foodNameController.text;
      final price = double.tryParse(priceController.text);
      if (foodName.isNotEmpty && price != null) {
        final menuItem = RestaurantMneuModel(
          foodName: foodName,
          price: price,
          photoPath: imagePath,
          photo: context.read<RestaurantMenuCubit>().imageId ?? "",
        );

        await context
            .read<RestaurantMenuCubit>()
            .updateMenuItem(context, menuItem);
        await context
            .read<RestaurantDetailsCubit>()
            .loadData(id: widget.restaurantId);

        foodNameController.clear();
        priceController.clear();
      }
    }
  }

  Widget _buildValidationMessage() {
    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
      builder: (context, state) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Text(
            "You have to fill all fields!",
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final restaurantDetailsState =
        context.watch<RestaurantDetailsCubit>().state;
    final restaurantMenuState = context.watch<RestaurantMenuCubit>().state;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        controller: _scrollController,
        children: [
          if (restaurantDetailsState.meals?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildMealsList(restaurantDetailsState.meals!),
            )
          else
            const SizedBox(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuForm(restaurantDetailsState),
                  const SizedBox(height: 10),
                  if (showValidator) _buildValidationMessage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

/*
class EditFoodView extends StatefulWidget {
  var restaurantId;

  EditFoodView({super.key, required payload}) {
    if (payload is String) {
      restaurantId = payload;
    } else {
      restaurantId = payload['restaurantId'];
    }
  }

  @override
  State<EditFoodView> createState() => _EditFoodViewState();
}

class _EditFoodViewState extends State<EditFoodView> {
  final ApiConsumer apiConsumer =
      BaseApiConsumer(serviceLocator(), serviceLocator());
  final ScrollController _scrollController = ScrollController();
  TextEditingController foodNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String imagePath = "";

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
          duration: const Duration(seconds: 1),
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
          const SnackBar(content: Text('Failed to delete item')),
        );
      },
      (r) async {
        // Refresh restaurant details on success
        await context
            .read<RestaurantDetailsCubit>()
            .loadData(id: widget.restaurantId);

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
    final state1 = context.watch<RestaurantDetailsCubit>().state;
    final state = context.watch<RestaurantMenuCubit>().state;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        controller: _scrollController,
        children: [
          if (state1.meals?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: state1.meals?.length ?? 0,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      RestaurantMenu? meal = state1.meals?[index];
                      return Slidable(
                        key: UniqueKey(),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                if (meal != null) {
                                  showConfirmationDialog(
                                    context,
                                    title: "Delete Restaurant",
                                    message:
                                        "Are you sure you want to remove this restaurant?",
                                    onConfirm: () async {
                                      // Perform the logout action here
                                      _removeItem(foodId: meal.id!);
                                    },
                                  );
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
                          fromUpdate: true,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: context.read<RestaurantMenuCubit>().formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // height: MediaQuery.of(context).size.width * 0.5,
                    // width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () async {
                                    await context
                                        .read<RestaurantMenuCubit>()
                                        .uploadMealImage(context,
                                            subcategoryId: state1
                                                .restaurant!.subcategoryId!.id);
                                  },
                                  child: BlocBuilder<RestaurantMenuCubit,
                                      RestaurantMenuState>(
                                    builder: (context, state) {
                                      if (state is RestaurantMenuImagePicked) {
                                        imagePath = state.imagePath;
                                        return ImagePickerPlaceholder(
                                          image: Image.file(
                                            File(imagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }
                                      return Container(
                                        // color: Colors.red,
                                        height: 195.h,
                                        child: ImagePickerPlaceholder(
                                          // width: double.infinity,
                                          tilte: LocaleKeys.photoForMeal.tr(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Sizer(),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return LocaleKeys.emptyFieldNotValid
                                              .tr();
                                        }
                                        return null;
                                      },
                                      maxLines: null,
                                      controller: foodNameController,
                                      decoration: InputDecoration(
                                        constraints: BoxConstraints.loose(
                                            Size.fromHeight(90.h)),
                                        filled: false,
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        hintText: LocaleKeys.itemName.tr(),
                                        hintStyle: Styles.mediumText(
                                            color: AppColors.SECONDARY_COLOR,
                                            fontSize: 32),
                                        // Set the border color to grey
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.red),
                                          // Keep red for error state
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    Sizer(),
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return LocaleKeys.emptyFieldNotValid
                                              .tr();
                                        }
                                        return null;
                                      },
                                      maxLines: null,
                                      controller: priceController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r"[0-9.]")),
                                      ],
                                      decoration: InputDecoration(
                                        constraints: BoxConstraints.loose(
                                            Size.fromHeight(90.h)),
                                        filled: false,
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        hintText: LocaleKeys.price.tr(),
                                        hintStyle: Styles.mediumText(
                                            color: AppColors.SECONDARY_COLOR,
                                            fontSize: 32),
                                        // Set the border color to grey
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.red),
                                          // Keep red for error state
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Sizer(),
                          ElevatedAppButton(
                            onPressed: () async {
                              // print("1222222dsvvs23");

                              final foodName = foodNameController.text;
                              final price =
                                  double.tryParse(priceController.text);
                              if (foodName.isNotEmpty && price != null) {
                                final menuItem = RestaurantMneuModel(
                                  // restaurantId:'66ff110be6f198a009c8017e' ,
                                  foodName: foodName,
                                  price: price,
                                  photoPath: imagePath,
                                  photo: context
                                      .read<RestaurantMenuCubit>()
                                      .imageId,
                                );
                                // context
                                //     .read<RestaurantMenuCubit>()
                                //     .addMenuItem(context, menuItem);

                                await context
                                    .read<RestaurantMenuCubit>()
                                    .updateMenuItem(
                                      menuItem,
                                    );
                                await context
                                    .read<RestaurantDetailsCubit>()
                                    .loadData(id: state1.restaurant!.id!);

                                foodNameController.clear();
                                priceController.clear();
                              }
                            },
                            label: '',
                            backColor: AppColors.SECONDARY_COLOR,
                            icon: Icons.add,
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                      builder: (context, state) {
                    return Visibility(
                      visible:
                          state is ValidationState && (state.isMneu ?? false),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 5, left: 5, top: 5.0),
                        child: Text(
                          "You have to fill at least one item!",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

// class EditFoodView extends StatefulWidget {
//   final String restaurantId;
//
//   EditFoodView({
//     super.key,
//     required payload,
//   }) : restaurantId =
//             payload is String ? payload : payload['restaurantId'] as String;
//
//   @override
//   _EditFoodViewState createState() => _EditFoodViewState();
// }
//
// class _EditFoodViewState extends State<EditFoodView>
//     with AutomaticKeepAliveClientMixin {
//   // Constants for API endpoints
//   static const String baseApiUrl = 'https://49dev.com/api/v1/food';
//   static const String deleteFoodItemEndpoint = '$baseApiUrl/delete-food-item/';
//
//   bool? showValidator;
//
//   @override
//   bool get wantKeepAlive => true;
//
//   // Dependencies
//   final ApiConsumer apiConsumer =
//       BaseApiConsumer(serviceLocator(), serviceLocator());
//
//   // Controllers
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController foodNameController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//
//   // Form key
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   // State variables
//   String imagePath = "";
//   final Duration _scrollDuration = const Duration(seconds: 1);
//   final Curve _scrollCurve = Curves.easeInOut;
//
//   @override
//   void initState() {
//     super.initState();
//     // Load restaurant details
//
//     // Scroll to the end after the first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<RestaurantDetailsCubit>().loadData(id: widget.restaurantId);
//
//       _scrollToEnd();
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     foodNameController.dispose();
//     priceController.dispose();
//     super.dispose();
//   }
//
//   /// Scrolls the ListView to the end smoothly
//   void _scrollToEnd() {
//     if (_scrollController.hasClients) {
//       final maxScroll = _scrollController.position.maxScrollExtent;
//       if (maxScroll > 0) {
//         _scrollController.animateTo(
//           maxScroll,
//           duration: _scrollDuration,
//           curve: _scrollCurve,
//         );
//       }
//     }
//   }
//
//   /// Removes a food item from the server and refreshes the list
//   Future<void> _removeItem({required String foodId}) async {
//     final res = await apiConsumer.delete('$deleteFoodItemEndpoint$foodId');
//
//     res.fold(
//       (failure) {
//         // Display error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to delete item')),
//         );
//       },
//       (r) async {
//         // Refresh restaurant details on success
//         await context
//             .read<RestaurantDetailsCubit>()
//             .loadData(id: widget.restaurantId);
//         showSuccessMessage(context, r['message']);
//       },
//     );
//   }
//
//   /// Handles the delete action with confirmation
//   void _onDeletePressed(RestaurantMenu meal) {
//     showConfirmationDialog(
//       context,
//       title: "Delete Item",
//       message: "Are you sure you want to remove this item?",
//       onConfirm: () async {
//         Navigator.pop(context);
//         await _removeItem(foodId: meal.id!);
//       },
//     );
//   }
//
//   /// Builds the list of meals
//   Widget _buildMealsList(List<RestaurantMenu> meals) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: meals.length,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         final meal = meals[index];
//         return Slidable(
//           key: ValueKey(meal.id),
//           endActionPane: ActionPane(
//             motion: const ScrollMotion(),
//             children: [
//               SlidableAction(
//                 onPressed: (context) => _onDeletePressed(meal),
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 icon: Icons.delete,
//                 label: 'Delete',
//               ),
//             ],
//           ),
//           child: ItemCard(
//             fromUpdate: true,
//             meal: meal,
//             restaurantId: widget.restaurantId,
//           ),
//         );
//       },
//     );
//   }
//
//   /// Builds the form for adding/updating a menu item
//   Widget _buildMenuForm(RestaurantDetailsState detailsState) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(width: 1, color: Colors.grey),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 // Image Picker Section
//                 Expanded(
//                   flex: 2,
//                   child: GestureDetector(
//                     onTap: () async {
//                       final subcategoryId =
//                           detailsState.restaurant?.subcategoryId?.id;
//                       if (subcategoryId != null) {
//                         await context
//                             .read<RestaurantMenuCubit>()
//                             .uploadMealImage(
//                               context,
//                               subcategoryId: subcategoryId,
//                             );
//                       }
//                     },
//                     child:
//                         BlocBuilder<RestaurantMenuCubit, RestaurantMenuState>(
//                       builder: (context, state) {
//                         if (state is RestaurantMenuImagePicked) {
//                           imagePath = state.imagePath;
//                           return ImagePickerPlaceholder(
//                             image: Image.file(
//                               File(imagePath),
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         }
//                         return Container(
//                           height: 195.h,
//                           child: ImagePickerPlaceholder(
//                             title: LocaleKeys.photoForMeal.tr(),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10), // Replaces Sizer()
//
//                 // Input Fields Section
//                 Expanded(
//                   flex: 3,
//                   child: Column(
//                     children: [
//                       _buildTextFormField(
//                         controller: foodNameController,
//                         hintText: LocaleKeys.itemName.tr(),
//                         validatorMessage: LocaleKeys.emptyFieldNotValid.tr(),
//                         keyboardType: TextInputType.text,
//                       ),
//                       const SizedBox(height: 10),
//                       _buildTextFormField(
//                         controller: priceController,
//                         hintText: LocaleKeys.price.tr(),
//                         validatorMessage: LocaleKeys.emptyFieldNotValid.tr(),
//                         keyboardType: const TextInputType.numberWithOptions(
//                             decimal: true),
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             ElevatedAppButton(
//               onPressed: _onAddOrUpdatePressed,
//               label: '',
//               backColor: AppColors.SECONDARY_COLOR,
//               icon: Icons.add,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Builds a customized TextFormField
//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String hintText,
//     required String validatorMessage,
//     TextInputType keyboardType = TextInputType.text,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return TextFormField(
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           setState(() {
//             showValidator = true;
//           });
//         } else {
//           setState(() {
//             showValidator = false;
//           });
//         }
//         return null;
//       },
//       maxLines: null,
//       controller: controller,
//       keyboardType: keyboardType,
//       inputFormatters: inputFormatters,
//       decoration: InputDecoration(
//         constraints: BoxConstraints.loose(Size.fromHeight(90.h)),
//         filled: false,
//         contentPadding: const EdgeInsets.all(10),
//         hintText: hintText,
//         hintStyle: Styles.mediumText(
//           color: AppColors.SECONDARY_COLOR,
//           fontSize: 32,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.grey),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.grey),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.red),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.red),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//       ),
//     );
//   }
//
//   /// Handles the add/update button press
//   void _onAddOrUpdatePressed() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       final foodName = foodNameController.text;
//       final price = double.tryParse(priceController.text);
//       if (foodName.isNotEmpty && price != null) {
//         final menuItem = RestaurantMneuModel(
//           foodName: foodName,
//           price: price,
//           photoPath: imagePath,
//           photo: context.read<RestaurantMenuCubit>().imageId,
//         );
//
//         await context
//             .read<RestaurantMenuCubit>()
//             .updateMenuItem(context, menuItem);
//         await context
//             .read<RestaurantDetailsCubit>()
//             .loadData(id: widget.restaurantId);
//
//         foodNameController.clear();
//         priceController.clear();
//       }
//     }
//   }
//
//   /// Builds the validation message
//   Widget _buildValidationMessage() {
//     return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
//       builder: (context, state) {
//         // if (state is ValidationState && (state.isMenu ?? false)) {
//         return const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//           child: Text(
//             "You have to fill all fields!",
//             style: TextStyle(color: Colors.red),
//           ),
//         );
//         // }
//         // return const SizedBox.shrink();
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final restaurantDetailsState =
//         context.watch<RestaurantDetailsCubit>().state;
//     final restaurantMenuState = context.watch<RestaurantMenuCubit>().state;
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(
//         controller: _scrollController,
//         children: [
//           if (restaurantDetailsState.meals?.isNotEmpty ?? false)
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: _buildMealsList(restaurantDetailsState.meals!),
//             )
//           else
//             const SizedBox(),
//
//           // Menu Form Section
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildMenuForm(restaurantDetailsState),
//                   const SizedBox(height: 10),
//                   if (showValidator ?? false) _buildValidationMessage(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
