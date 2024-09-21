import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

// class FavouriteCategoryView extends StatelessWidget {
//   const FavouriteCategoryView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = context.read<FavouriteCategoryCubit>();
//     return Scaffold(
//         appBar: const BackAppBar(
//           label: Labels.favouriteCategories,
//         ),
//         body: Text("Hi"));
//   }
// }

class FavouriteCategoryView extends StatelessWidget {
  final List<FavoriteCategory> favoriteCategory;

  const FavouriteCategoryView({super.key, required this.favoriteCategory});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<TinderViewCubit>(),
        ),
        BlocProvider(
          create: (context) => UserCubit(
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
            serviceLocator(),
          ),
        ),
      ],
      child: _FavCategoryViewContent(favoriteCategory),
    );
  }
}

class _FavCategoryViewContent extends StatefulWidget {
  final List<FavoriteCategory> favoriteCategory;

  const _FavCategoryViewContent(this.favoriteCategory);

  @override
  State<_FavCategoryViewContent> createState() =>
      _FavCategoryViewContentState();
}

class _FavCategoryViewContentState extends State<_FavCategoryViewContent> {
  @override
  void initState() {
    // TODO: implement initState
    _initializeTinderData();
    super.initState();
  }

  void _initializeTinderData() {
    context.read<TinderViewCubit>().fetchFavoritesCategory();
  }

  @override
  Widget build(BuildContext context) {
    final tinderCubit = context.watch<TinderViewCubit>();

    return SharedScaffold(
      // body: _buildFavoritesGrid(context, widget.favoriteCategory),
      body: Builder(
        builder: (context) {
          if (tinderCubit.state.getFavoriteCategoryModel == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (tinderCubit.state.getFavoriteCategoryModel!.data.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          // return ListView.builder(
          //   itemCount: tinderCubit.state.getFavoriteCategoryModel!.data.length,
          //     itemBuilder: (context,index){
          //   return Text("${tinderCubit.state.getFavoriteCategoryModel!.data[index].}");
          // });
          return _buildFavoritesGrid(
              context, tinderCubit.state.getFavoriteCategoryModel!.data);
        },
      ),

      mainCategoryId: 5,
    );
  }

  Widget _buildFavoritesGrid(
      BuildContext context, List<CategoryFavoriteItem> favorites) {
    final gridChunks = _splitListIntoChunks(favorites, 4);

    return ListView.builder(
      itemCount: gridChunks.length,
      itemBuilder: (context, index) {
        return _buildGridRow(context, gridChunks[index]);
      },
    );
  }

  List<List<CategoryFavoriteItem>> _splitListIntoChunks(
      List<CategoryFavoriteItem> list, int chunkSize) {
    return List.generate(
      (list.length / chunkSize).ceil(),
      (index) => list.sublist(
        index * chunkSize,
        index * chunkSize + chunkSize > list.length
            ? list.length
            : index * chunkSize + chunkSize,
      ),
    );
  }

  Widget _buildGridRow(
      BuildContext context, List<CategoryFavoriteItem> subCategoryChunk) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: subCategoryChunk
              .map((subCategoryData) => _buildCard(context, subCategoryData))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, CategoryFavoriteItem favCategoryData) {
    return Container(
        width: 200,
        height: MediaQuery.of(context).size.height / 4,
        padding: const EdgeInsets.all(8.0),
        child: FavTinderCategoryCard(
            favCategoryCardData: favCategoryData, activeFav: false)
        // Column(
        //   children: [
        //     Text(favCategoryData.categoryId?.nameAr ?? 'Unknown Category'),
        //   ],
        // ),
        );
  }
}

class FavTinderCategoryCard extends StatelessWidget {
  final CategoryFavoriteItem favCategoryCardData;
  final bool activeFav;

  const FavTinderCategoryCard({
    super.key,
    required this.favCategoryCardData,
    required this.activeFav,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).scaffoldBackgroundColor),
        child: Card(
          clipBehavior: Clip.hardEdge,
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 2,
          child: Column(
            children: [
              _buildImageSection(context),
              const Sizer(),
              _buildInfoSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: SquareImage(
                fit: BoxFit.fitWidth,
                radius: 10,
                url: favCategoryCardData.categoryId.banner ?? "",
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: activeFav
                  ? IconAppButton(
                      size: 25,
                      icon: Icons.favorite_border,
                      color: Colors.red,
                      onPressed: () {},
                    )
                  : const Icon(
                      size: 25,
                      Icons.favorite,
                      color: Colors.red,
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: favCategoryCardData.categoryId.nameEn ?? "",
                  style: Styles.headerText(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Label(
                  text: '${952} ads',
                  // text: '${9355.toShortScale} ads',
                  style: Styles.mediumText(fontSize: 14),
                ),
              ],
            ),
          ),
          // IconAppButton(
          //   icon: Icons.add,
          //   isCircle: true,
          //   color: Colors.white,
          //   backColor: AppColors.PRIMARY_COLOR,
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => AdsView(
          //             params: AdsViewParams(
          //               mainCategory: MainCategoryEntity(
          //                 id: favCategoryCardData.id,
          //                 name: favCategoryCardData.categoryId.nameEn,
          //                 image: favCategoryCardData.categoryId.picture,
          //                 banner: favCategoryCardData.categoryId.picture,
          //                 cover: favCategoryCardData.categoryId.picture,
          //                 isFavorite: true,
          //                 total: 2,
          //               ),
          //               subCategory: CategoryEntity(
          //                 id: favCategoryCardData.id,
          //                 name: favCategoryCardData.categoryId.nameEn,
          //                 image: favCategoryCardData.categoryId.picture,
          //                 isFavorite: true,
          //               ),
          //             ),
          //           ),
          //         ));
          //   },
          // ),
        ],
      ),
    );
  }

  // void _navigateToDynamicGridView(BuildContext context) {
  //   context
  //       .read<TinderViewCubit>()
  //       .fetchFavorites()
  //       .then((value) => Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const FavCategoryView(
  //         favoriteCategory: [],
  //       ),
  //     ),
  //   ));
  // }
}
