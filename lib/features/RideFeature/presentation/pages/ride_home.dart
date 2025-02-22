import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import '../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';

class RideHome extends StatefulWidget {
  const RideHome({super.key});

  @override
  State<RideHome> createState() => _RideHomeState();
}

class _RideHomeState extends State<RideHome> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String? _selectedCategoryType = "ride"; // Initially "ride"
  int? _selectedCategoryIndex = 0; // Initially selecting the first category

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rideCubit = context.read<RideCubit>();
      if (!rideCubit.isClosed) {
        rideCubit.fetchRideCategories(UserCubit.to.state.data?.id ?? "");
        rideCubit.fetchShippingCategories(UserCubit.to.state.data?.id ?? "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SharedScaffold(
          mainCategoryId: 2,
          body: NestedAppbar(
            scrollController: _scrollController,
            appBars: const [],
            body: Stack(
              children: [
                _buildTopImage(),
                _buildBottomSheet(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopImage() {
    return Column(
      children: [
        Image.network(
          "https://miro.medium.com/v2/resize:fit:1024/1*lNbCllyMLyiVyGfY-HXHjw.png",
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BlocBuilder<RideCubit, RideState>(
          builder: (context, state) {
            if (state.isLoading) return const Center(child: CircularProgressIndicator());
            if (state.isError) return Center(child: Text("Error: \${state.failure}"));
            if (!state.isSuccess || state.rideCategory == null || state.shippingCategory == null) return Container();

            return Column(
              children: [
                _buildCategoryList("ride", state.rideCategory!.subCategories),
                const SizedBox(height: 20),
                _buildCategoryList("shipping", state.shippingCategory!.subCategories),
                const SizedBox(height: 10),
                _customTile(Icons.search, "Country", Icons.arrow_drop_down),
                const SizedBox(height: 10),
                _customLocationField("From", Colors.green, "Find"),
                const SizedBox(height: 10),
                _customLocationField("To", Colors.blue, "Find"),
                const SizedBox(height: 10),
                _fareField(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryList(String type, List subCategories) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          final subCategory = subCategories[index];
          final bool isSelected = _selectedCategoryType == type && _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedCategoryType == type && _selectedCategoryIndex == index) {
                  _selectedCategoryType = null;
                  _selectedCategoryIndex = null;
                } else {
                  _selectedCategoryType = type;
                  _selectedCategoryIndex = 0;
                  subCategories.insert(0, subCategories.removeAt(index));
                }
              });
            },
            child: _categoryItem(context.isArabic? subCategory.subCategoryNameAr : subCategory.subCategoryNameEn, subCategory.picture, isSelected),
          );
        },
      ),
    );
  }

  Widget _categoryItem(String title, String imageUrl, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Image.network(imageUrl, width: 46, height: 18, fit: BoxFit.fitWidth),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget _customTile(IconData leadingIcon, String text, IconData trailingIcon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [Icon(leadingIcon, size: 20), const SizedBox(width: 10), Text(text, style: const TextStyle(fontWeight: FontWeight.bold))],
          ),
          Icon(trailingIcon, size: 20),
        ],
      ),
    );
  }

  Widget _customLocationField(String label, Color color, String buttonText) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: Text(buttonText, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _fareField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("EGP", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Offer Your Fare"),
          Icon(Icons.edit, size: 18),
        ],
      ),
    );
  }
}
