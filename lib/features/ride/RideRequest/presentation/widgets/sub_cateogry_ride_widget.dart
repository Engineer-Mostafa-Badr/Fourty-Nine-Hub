import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_trip_reel_time_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/select_cateogry_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/sub_category.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/subcategory_card_selected.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SubCateogryRideWidget extends StatefulWidget {
  const SubCateogryRideWidget({super.key});

  @override
  State<SubCateogryRideWidget> createState() => _SubCateogryRideWidgetState();
}

class _SubCateogryRideWidgetState extends State<SubCateogryRideWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FormField(
        builder: (field) {
          return BlocBuilder<GetCateogryRiderCubit, RiderState>(
            builder: (context, state) {
              if (state is SuccessGetCateogyRider) {
                print(
                    "state.editedCategoryList ${state.editedCategoryList?.first} \n");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainCategoriesWidget(
                      category: MainCategoryEntity(
                          nameEn: state.model.mainCategory?.nameEn,
                          id: state.model.mainCategory?.mainCategoryId ?? "",
                          image: state.model.mainCategory?.cover ?? "",
                          isFavorite: true,
                          total: state.model.mainCategory?.driverLength ?? 0,
                          cover: state.model.mainCategory?.cover ?? "",
                          banner: state.model.mainCategory?.banner ?? "",
                          subcategories: state.editedCategoryList ??
                              sortList(state.model.subCategories)!
                                  .map(
                                    (e) => SubCategoryEntity(
                                        id: e.subCategoryId!,
                                        numberOfContent: e.driverCount,
                                        image: e.picture!,
                                        isFavorite: e.isFavorite ?? false,
                                        nameAr: e.subCategoryNameAr ?? '',
                                        nameEn: e.subCategoryNameEn ?? ''),
                                  )
                                  .toList()),
                    ),
                    if (field.hasError)
                      Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              field.errorText ?? "",
                              style: Styles.mediumText(color: Colors.red),
                            ),
                          ),
                        ],
                      )
                  ],
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildMainCategoriesWidget({
    required MainCategoryEntity category,
  }) {
    final riderCubit = context.read<RiderTripReelTimeCubit>();
    final categryId = context.read<GetCateogryRiderCubit>();
    final ScrollController controller = ScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category.name != null)
          Label(
            text: category.name ?? "",
            style: Styles.headerText(fontWeight: FontWeight.w400),
          ),
        if (category.subcategories?.isNotEmpty ?? false)
          SizedBox(
            height: 80,
            child: ListView.separated(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      List<SubCategoryEntity> workingList =
                          List.from(category.subcategories!);
                      final selectedSubCategory = workingList[index];
                      workingList.removeAt(index);
                      workingList.insert(0, selectedSubCategory);
                      context
                          .read<SelectCateogryCubit>()
                          .select(id: workingList[0].id, type: 0);
                      riderCubit.selectCateogry(workingList[0]);
                      context.read<ShippingCubit>().removeSubCategoryRequest();
                      categryId.sortData(
                        workingList[0].id,
                        orginalList:
                            BlocProvider.of<GetCateogryRiderCubit>(context)
                                .bannerModel
                                .subCategories,
                        fromRide: true,
                      );
                      controller.jumpTo(0);
                    });
                  },
                  child: BlocBuilder<SelectCateogryCubit, RiderState>(
                    builder: (context, state) {
                      log(state.toString());
                      if (state is SuccessSelectCateogryState) {
                        if (state.type == 0) {
                          return SubcategoryCardSelected(
                            selected: riderCubit.subCategory == null
                                ? false
                                : riderCubit.subCategory!.id ==
                                    category.subcategories![index].id,
                            mainCategory: category,
                            item: category.subcategories![index],
                            isSmallCard: true,
                            onChanged: (value) {
                              setState(() {
                                List<SubCategoryEntity> workingList =
                                    List.from(category.subcategories!);

                                final selectedSubCategory = workingList[index];
                                workingList.removeAt(index);
                                workingList.insert(0, selectedSubCategory);

                                riderCubit.selectCateogry(workingList[0]);
                                categryId.sortData(
                                  workingList[0].id,
                                  orginalList:
                                      BlocProvider.of<GetCateogryRiderCubit>(
                                              context)
                                          .bannerModel
                                          .subCategories,
                                );
                                controller.jumpTo(0);
                              });
                            },
                          );
                        } else {
                          return SubcategoryCardSelected(
                            selected: false,
                            mainCategory: category,
                            item: category.subcategories![index],
                            isSmallCard: true,
                            onChanged: (value) {
                              setState(() {
                                List<SubCategoryEntity> workingList =
                                    List.from(category.subcategories!);

                                final selectedSubCategory = workingList[index];
                                workingList.removeAt(index);
                                workingList.insert(0, selectedSubCategory);

                                riderCubit.selectCateogry(workingList[0]);
                                categryId.sortData(
                                  workingList[0].id,
                                  orginalList:
                                      BlocProvider.of<GetCateogryRiderCubit>(
                                              context)
                                          .bannerModel
                                          .subCategories,
                                );
                                controller.jumpTo(0);
                              });
                            },
                          );
                        }
                      } else {
                        return SubcategoryCardSelected(
                          selected: false,
                          mainCategory: category,
                          item: category.subcategories![index],
                          isSmallCard: true,
                          onChanged: (value) {
                            setState(() {
                              List<SubCategoryEntity> workingList =
                                  List.from(category.subcategories!);

                              final selectedSubCategory = workingList[index];
                              workingList.removeAt(index);
                              workingList.insert(0, selectedSubCategory);

                              riderCubit.selectCateogry(workingList[0]);
                              riderCubit.selectCateogry(workingList[0]);
                              categryId.sortData(
                                workingList[0].id,
                                orginalList:
                                    BlocProvider.of<GetCateogryRiderCubit>(
                                            context)
                                        .bannerModel
                                        .subCategories,
                              );
                              controller.jumpTo(0);
                            });
                          },
                        );
                      }
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: category.subcategories?.length ?? 0,
            ),
          ),
      ],
    );
  }

  List<SubCategory>? sortList(List<SubCategory>? list) {
    // if (false) {
    //   int index =
    //       list!.indexWhere((model) => model.subCategoryId == widget.selectedId);
    //   if (index != -1) {
    //     return list.sublist(index) + list.sublist(0, index);
    //   }
    //   return list;
    // } else {
    return list;
  }
  // }
}
