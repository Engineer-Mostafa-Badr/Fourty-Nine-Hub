import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../../data/models/selected_meal_model.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/option_entity.dart';
import '../../domain/entities/selected_meal_entity.dart';
import '../../domain/entities/variation_entity.dart';

class MealDetailsWidget extends StatefulWidget {
  final SelectedMealModel item;
  final Function(SelectedMealModel) addToCart;
  const MealDetailsWidget(
      {super.key, required this.item, required this.addToCart});

  @override
  State<MealDetailsWidget> createState() => _MealDetailsWidgetState();
}

class _MealDetailsWidgetState extends State<MealDetailsWidget> {
  @override
  void initState() {
    handleInitialVariation();
    super.initState();
  }

  void handleInitialVariation() {
    for (var variation in widget.item.meal.variations) {
      widget.item.selectedVariations.add(SelectedVariationEntity(
          selectedOption: variation.options.first, variation: variation));
    }
  }

  void onAddVariation(
      {required VariationEntity variation, required OptionEntity option}) {
    SelectedVariationEntity selectedVariation = widget.item.selectedVariations
        .firstWhere((element) => element.variation == variation);

    selectedVariation.selectedOption = option;
    setState(() {});
  }

  void onAddOnSelected({required OptionEntity option}) {
    if (widget.item.selectedAddOn.contains(option)) {
      widget.item.selectedAddOn.remove(option);
    } else {
      widget.item.selectedAddOn.add(option);
    }
    setState(() {});
  }

  bool isAddOnSelected({required OptionEntity option}) {
    return widget.item.selectedAddOn.contains(option);
  }

  OptionEntity selectedVariation({required VariationEntity variation}) {
    SelectedVariationEntity selectedVariation = widget.item.selectedVariations
        .firstWhere((element) => element.variation == variation);
    return selectedVariation.selectedOption;
  }

  void onAddQuantity() {
    widget.item.qty++;
    setState(() {});
  }

  void onMinusQuantity() {
    if (widget.item.qty > 1) {
      widget.item.qty--;
    }
    setState(() {});
  }

  double getPrice() {
    double total = 0;
    double selectionTotal = 0;
    for (var variation in widget.item.selectedVariations) {
      selectionTotal += variation.selectedOption.price;
    }
    for (var addOn in widget.item.selectedAddOn) {
      selectionTotal += addOn.price;
    }
    total += (widget.item.price + selectionTotal) * widget.item.qty;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconAppButton(
                icon: Icons.clear,
                onPressed: () => Navigator.pop(context),
              ),
              _buildMealInfo(meal: widget.item.meal),
              const Sizer(),
              _buildCountWidget(),
              const Sizer(),
            ],
          ),
        ),
      ),
      AppButton(
          label: 'Add To Cart  - (${widget.item.qty} for ${getPrice()} L.E)',
          onPressed: () => widget.addToCart(widget.item)),
    ]);
  }

  Widget _buildMealInfo({
    required MealEntity meal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SquareImage(
            radius: 10,
            width: double.infinity,
            height: kToolbarHeight * 2,
            source: NetworkImage(meal.image)),
        Label(
          text: meal.name,
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        Label(
          text: meal.description,
          style: Styles.mediumText(color: Colors.grey),
        ),
        _buildVariations(meal: meal),
        _buildAddOns(meal: meal),
      ],
    );
  }

  Widget _buildVariations({
    required MealEntity meal,
  }) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: meal.variations.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          final variation = meal.variations[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: variation.name,
                style: Styles.mediumText(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: variation.options.length,
                  itemBuilder: (context, index) {
                    final option = variation.options[index];
                    return Row(
                      children: [
                        Expanded(child: Label(text: option.name)),
                        Checkbox(
                            value: selectedVariation(variation: variation) ==
                                option,
                            onChanged: (v) => onAddVariation(
                                variation: variation, option: option)),
                      ],
                    );
                  })
            ],
          );
        });
  }

  Widget _buildAddOns({
    required MealEntity meal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: 'Add ons',
          style: Styles.mediumText(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final addOn = meal.addOns[index];
              return Row(
                children: [
                  Expanded(child: Label(text: addOn.name)),
                  Checkbox(
                      value: isAddOnSelected(option: addOn),
                      onChanged: (v) => onAddOnSelected(option: addOn))
                ],
              );
            },
            itemCount: meal.addOns.length)
      ],
    );
  }

  Widget _buildCountWidget() {
    return Row(
      children: [
        const Label(text: 'Quantity'),
        const Spacer(),
        IconAppButton(
            icon: Icons.add, isCircle: true, onPressed: () => onAddQuantity()),
        const Sizer(),
        Label(
          text: widget.item.qty.toString(),
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        const Sizer(),
        IconAppButton(
            icon: Icons.remove,
            isCircle: true,
            onPressed: () => onMinusQuantity()),
      ],
    );
  }
}
