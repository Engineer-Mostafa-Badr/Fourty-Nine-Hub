import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DropDownSubscription extends StatefulWidget {
  @override
  _DropDownSubscriptionState createState() => _DropDownSubscriptionState();
}

class _DropDownSubscriptionState extends State<DropDownSubscription> {
  String? selectedCategory;
  String? selectedSubCategory;
  int? selectedIndex; // Track the selected index

  Map<String, List<String>> categoryData = {
    'Category 1': ['SubCategory 1-1', 'SubCategory 1-2', 'SubCategory 1-3'],
    'Category 2': ['SubCategory 2-1', 'SubCategory 2-2', 'SubCategory 2-3'],
    // Add other categories as needed
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showCategoryDialog();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'Add Subcategory To Subscribe',
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Category"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 300.0, // Limits height to show only 4 items
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: categoryData.keys.map((category) {
                  return ListTile(
                    title: Text(category),
                    onTap: () {
                      Navigator.pop(context); // Close category dialog
                      _showSubCategoryDialog(
                          category); // Show subcategory dialog
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSubCategoryDialog(String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select SubCategory"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: categoryData[category]!.map((subCategory) {
                return ListTile(
                  title: Text(subCategory),
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      selectedSubCategory = subCategory;
                    });
                    Navigator.pop(context);
                    _showBottomSheet(subCategory);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(String subCategory) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Use StatefulBuilder for dynamic UI updates in bottom sheet
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(
                    text: 'Subscription List',
                    style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontSize: 28),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1 / 0.22),
                      itemCount: 10,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          // Use setModalState to update the color in bottom sheet
                          setModalState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? Colors.red // Change to red if selected
                                : Theme.of(context).scaffoldBackgroundColor, // Default color
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Label(
                              text: '1000',
                              color:selectedIndex == index? AppColors.AUTH_CONTAINER_COLOR:Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: const Label(
                      text: 'Subscribe',
                      color: AppColors.AUTH_CONTAINER_COLOR,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}



