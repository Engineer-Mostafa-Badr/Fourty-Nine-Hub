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
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_menu_cubit/create_menu_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/mneu/show_menu.dart';
import 'package:fourtyninehub/features/food_feature/edit_food/presentation/cubit/edit_food_cubit.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
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
import 'package:go_router/go_router.dart';

class EditFoodView extends StatefulWidget {
  var restaurantData;

  EditFoodView({
    super.key,
    required dynamic payload,
  }) : restaurantData = payload is Map<String, dynamic>
            ?(payload['restaurantId'] as String?) ?? ""
      :payload;

  @override
  _EditFoodViewState createState() => _EditFoodViewState();
}

class EditFoodParams {
  final String restaurantId;
  final String subCategoryId;

  EditFoodParams({required this.restaurantId, required this.subCategoryId});

}



class _EditFoodViewState extends State<EditFoodView>
    with AutomaticKeepAliveClientMixin {

  bool showValidator = false;

  final ApiConsumer apiConsumer =
      BaseApiConsumer(serviceLocator(), serviceLocator());

  // final ScrollController _scrollController = ScrollController();
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String imagePath = "";
  final Duration _scrollDuration = const Duration(seconds: 1);
  final Curve _scrollCurve = Curves.easeInOut;

  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<EditFoodCubit>().loadData(id: widget.restaurantData is String?widget.restaurantData:widget.restaurantData.restaurantId, first: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<EditFoodCubit>().getMeals(id: widget.restaurantData is String?widget.restaurantData:widget.restaurantData.restaurantId, first: false);
    }
  }


  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<EditFoodCubit>().loadData(id: widget.restaurantData is String?widget.restaurantData:widget.restaurantData.restaurantId, first: true);
  //     _scrollToEnd();
  //   });
  // }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
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


  onDeletePressed(RestaurantMenu meal) {
    bool result = true;
    if (meal.id != null) {
      showConfirmationDialog(
        context,
        title: context.isArabic?'حذف الوجبة':'Delete Item',
        message:context.isArabic?'هل أنت متأكد أنك تريد حذف هذا العنصر':'Are you sure you want to remove this item?',
        onConfirm: () async {
          Navigator.pop(context);
         var data =  await context.read<EditFoodCubit>().removeItem(foodId: meal.id??'',context: context);
          result = data;
        },
      );
      return result;
    }
    return result;
  }

  Widget _buildMealsList(List<RestaurantMenu> meals,Function(String id) onDelete ) {
    return BlocBuilder<EditFoodCubit,EditFoodState>(
      builder: (context,state) {
        return ListView.separated(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: meals.length,
          separatorBuilder: (context,i)=>const Sizer(),
          // physics: const NeverScrollableScrollPhysics(),
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
                    flex: 3,
                    onPressed: (context) async{
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(context.isArabic?'حذف الوجبة':'Delete Item',style: Styles.headerText(),),
                            content: Text(context.isArabic?'هل أنت متأكد أنك تريد حذف هذا العنصر':'Are you sure you want to remove this item?',style: Styles.mediumText(),),
                            actions: [
                              TextButton(
                                onPressed:  () => Navigator.of(context).pop(),
                                child: Text(
                                  LocaleKeys.no.localize,
                                  style: Styles.mediumText(color: Colors.black),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: ()async{
                                  onDelete(meal.id??'');
                                },
                                child: Text(
                                  LocaleKeys.yes.localize,
                                  style: Styles.mediumText(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        }
                      );

                      // showConfirmationDialog(
                      //   context,
                      //   title: "Delete Item",
                      //   message: "Are you sure you want to remove this item?",
                      //   onConfirm: () async {
                      //     bool result =await context.read<EditFoodCubit>().removeItem(foodId: meal?.id??'',context: context);
                      //     if(result==true){
                      //       context.pop();
                      //
                      //     }
                      //   },
                      // );
                      // if(result==true){
                      //   meals.removeWhere((element) => element.id==meals[index].id);
                      // }
                      setState(() {

                      });
                      // var result = await onDeletePressed(meal);
                      // print("objectDeleted");
                      // if(result==true){
                      //   print("objectDeletedTrue");
                      //   print("object");
                      //   meals.removeWhere((element) => element.id==meals[index].id);
                      // }
                    },
                    backgroundColor: Colors.red,
                    borderRadius: BorderRadius.circular(12.0),
                    foregroundColor: context.isDarkMode?AppColors.PRIMARY_COLOR:Colors.white,
                    icon: Icons.delete,
                    label: LocaleKeys.delete.localize,
                  ),
                ],
              ),
              child: Container(
                height: 100.h,
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                    color:context.isDarkMode?AppColors.PRIMARY_COLOR:Colors.white   ,
                    borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.2,
                      blurRadius: 0.5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ]
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        meal.foodName??'',
                        style: Styles.headerText(color:context.isDarkMode?Colors.white: AppColors.PRIMARY_COLOR),
                      ),
                    ),
                    Text(
                      meal.price.toString()??'',
                      style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }

  Widget _buildMenuForm(String subcategoryId) {
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
                        await context
                            .read<EditFoodCubit>()
                            .uploadMealImage(
                              context,
                              subcategoryId: '62c8babb8e28a58a3edf581d',
                            );

                    },
                    child:
                        BlocBuilder<EditFoodCubit, EditFoodState>(
                      builder: (context, state) {
                        if (state.imagePath!=null&&state.imagePath!='') {
                          imagePath = state.imagePath??'';
                          print("imagePath$imagePath");
                          return ImagePickerPlaceholder(
                            image: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return SizedBox(
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
                        hintText: LocaleKeys.itemName.localize,
                        validatorMessage: LocaleKeys.emptyFieldNotValid.tr(),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                      _buildTextFormField(
                        controller: priceController,
                        hintText: LocaleKeys.price.localize,
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
      if(context.read<EditFoodCubit>().state.imagePath!=null&&context.read<EditFoodCubit>().state.imagePath!=''){
        final foodName = foodNameController.text;
        final price = double.tryParse(priceController.text);
        if (foodName.isNotEmpty && price != null) {
          final menuItem = RestaurantMneuModel(
            foodName: foodName,
            price: price,
            photoPath: imagePath,
            photo: context.read<EditFoodCubit>().imageId,
          );

          await context
              .read<EditFoodCubit>()
              .updateMenuItem(context, menuItem, id: widget.restaurantData is String? widget.restaurantData:widget.restaurantData.restaurantId);
          foodNameController.clear();
          priceController.clear();
        }
      }else{
        showErrorMessage(context, context.isArabic?'يجب اختيار صورة للمنتج':'You have to select an image for the food');
      }
    }
  }

  Widget _buildValidationMessage() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Text(
            context.isArabic?'يجب تعبئة جميع الحقول':"You have to fill all fields!",
            style: const TextStyle(color: Colors.red),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<EditFoodCubit,EditFoodState>(
        builder: (context,state) {
          var cubit = context.read<EditFoodCubit>();
          return state.isLoading?const Center(child: CircularProgressIndicator(),):Column(
            // controller: _scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMenuForm(state.restaurant?.subcategoryId?.id??''),
                      const SizedBox(height: 10),
                      if (showValidator) _buildValidationMessage(),
                    ],
                  ),
                ),
              ),

              if (cubit.menu.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _buildMealsList(cubit.menu??[],(id) async{
                      bool result = await context.read<EditFoodCubit>().removeItem(foodId: id,context: context);
                      if(result==true){
                        context.pop();
                        cubit.menu.removeWhere((element) => element.id==id);
                        setState(() {

                        });
                      }
                    }),
                  ),
                )
              else
                const SizedBox(),
            ],
          );
        }
      ),
    );
  }
}
