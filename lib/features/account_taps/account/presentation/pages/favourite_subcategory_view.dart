// // // // import 'dart:developer';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// // // // import 'package:fourtyninehub/features/social_media/tinder/data/models/fav_category_model.dart';
// // // // import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
// // // // import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
// // // // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// // // // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// // // //
// // // // class FavouriteSubCategoryView extends StatefulWidget {
// // // //   FavouriteSubCategoryView({super.key});
// // // //
// // // //   @override
// // // //   State<FavouriteSubCategoryView> createState() =>
// // // //       _FavouriteSubCategoryViewState();
// // // // }
// // // //
// // // // class _FavouriteSubCategoryViewState extends State<FavouriteSubCategoryView> {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return _FavouriteSubCategoryViewContent();
// // // //   }
// // // // }
// // // //
// // // // class _FavouriteSubCategoryViewContent extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     // context
// // // //     //     .read<TinderViewCubit>()
// // // //     //     .fetchFavorites(TinderSharedUtils.token)
// // // //     //     .then((value) {
// // // //     //   log(value!.data!.favorites.first.category!.nameAr.toString() + "mmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
// // // //     // });
// // // //     return SharedScaffold(
// // // //       body: FutureBuilder(
// // // //         future: context
// // // //             .read<TinderViewCubit>()
// // // //             .fetchFavorites(TinderSharedUtils.token),
// // // //         builder: (context, snapshot) {
// // // //           // return Center(child: Text(state.favoritesResponse.toString()));
// // // //
// // // //           if (snapshot.data == null) {
// // // //             return Center(child: Text('No data available'));
// // // //           }
// // // //
// // // //           final List<List<Favorite>> gridChunks =
// // // //               _splitListIntoChunks(snapshot.data!.data!.favorites, 4);
// // // //
// // // //           return ListView.builder(
// // // //             itemCount: gridChunks.length,
// // // //             itemBuilder: (context, index) {
// // // //               return _buildGridRow(context, gridChunks[index]);
// // // //             },
// // // //           );
// // // //         },
// // // //       ),
// // // //       mainCategoryId: 5,
// // // //     );
// // // //   }
// // // //
// // // //   /// Splits a list into chunks of a specified size.
// // // //   List<List<Favorite>> _splitListIntoChunks(
// // // //       List<Favorite> list, int chunkSize) {
// // // //     final List<List<Favorite>> chunks = [];
// // // //     for (var i = 0; i < list.length; i += chunkSize) {
// // // //       chunks.add(list.sublist(
// // // //           i, i + chunkSize > list.length ? list.length : i + chunkSize));
// // // //     }
// // // //     return chunks;
// // // //   }
// // // //
// // // //   /// Builds a row of cards for the grid.
// // // //   Widget _buildGridRow(BuildContext context, List<Favorite> subCategoryChunk) {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// // // //       child: SingleChildScrollView(
// // // //         scrollDirection: Axis.horizontal,
// // // //         child: Row(
// // // //           children: subCategoryChunk
// // // //               .map((subCategoryData) => _buildCard(context, subCategoryData))
// // // //               .toList(),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   /// Builds a single card with subcategory data.
// // // //   Widget _buildCard(BuildContext context, Favorite subCategoryData) {
// // // //     return Container(
// // // //       width: 200,
// // // //       height: MediaQuery.of(context).size.height / 4,
// // // //       padding: const EdgeInsets.all(8.0),
// // // //       child: Column(
// // // //         children: [Text(subCategoryData.toJson().toString())],
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // // import 'dart:developer';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/data/models/fav_category_model.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// // //
// // // class FavouriteSubCategoryView extends StatefulWidget {
// // //   const FavouriteSubCategoryView({super.key});
// // //
// // //   @override
// // //   State<FavouriteSubCategoryView> createState() => _FavouriteSubCategoryViewState();
// // // }
// // //
// // // class _FavouriteSubCategoryViewState extends State<FavouriteSubCategoryView> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return BlocProvider(
// // //       create: (context) => TinderViewCubit()..fetchFavorites(TinderSharedUtils.token),
// // //       child: const _FavouriteSubCategoryViewContent(),
// // //     );
// // //   }
// // // }
// // //
// // // class _FavouriteSubCategoryViewContent extends StatelessWidget {
// // //   const _FavouriteSubCategoryViewContent();
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SharedScaffold(
// // //       body: BlocBuilder<TinderViewCubit, TinderViewState>(
// // //         builder: (context, state) {
// // //           if (state.favoritesResponse == null || state.favoritesResponse.data!.favorites.isEmpty) {
// // //             return const Center(child: Text('No data available'));
// // //           }
// // //
// // //           final List<List<Favorite>> gridChunks = _splitListIntoChunks(
// // //               state.favoritesResponse.data!.favorites, 4);
// // //
// // //           return ListView.builder(
// // //             itemCount: gridChunks.length,
// // //             itemBuilder: (context, index) {
// // //               return _buildGridRow(context, gridChunks[index]);
// // //             },
// // //           );
// // //         },
// // //       ), mainCategoryId: 3,
// // //     );
// // //   }
// // //
// // //   /// Splits a list into chunks of a specified size.
// // //   List<List<Favorite>> _splitListIntoChunks(List<Favorite> list, int chunkSize) {
// // //     final List<List<Favorite>> chunks = [];
// // //     for (var i = 0; i < list.length; i += chunkSize) {
// // //       chunks.add(list.sublist(
// // //           i, i + chunkSize > list.length ? list.length : i + chunkSize));
// // //     }
// // //     return chunks;
// // //   }
// // //
// // //   /// Builds a row of cards for the grid.
// // //   Widget _buildGridRow(BuildContext context, List<Favorite> subCategoryChunk) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// // //       child: SingleChildScrollView(
// // //         scrollDirection: Axis.horizontal,
// // //         child: Row(
// // //           children: subCategoryChunk
// // //               .map((subCategoryData) => _buildCard(context, subCategoryData))
// // //               .toList(),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   /// Builds a single card with subcategory data.
// // //   Widget _buildCard(BuildContext context, Favorite subCategoryData) {
// // //     return Container(
// // //       width: 200,
// // //       height: MediaQuery.of(context).size.height / 4,
// // //       padding: const EdgeInsets.all(8.0),
// // //       child: Column(
// // //         children: [Text(subCategoryData.toJson().toString())],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/fav_category_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// //
// // class FavouriteSubCategoryView extends StatefulWidget {
// //   const FavouriteSubCategoryView({super.key});
// //
// //   @override
// //   State<FavouriteSubCategoryView> createState() => _FavouriteSubCategoryViewState();
// // }
// //
// // class _FavouriteSubCategoryViewState extends State<FavouriteSubCategoryView> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create: (context) => TinderViewCubit(),
// //       child: const _FavouriteSubCategoryViewContent(),
// //     );
// //   }
// // }
// //
// // class _FavouriteSubCategoryViewContent extends StatelessWidget {
// //   const _FavouriteSubCategoryViewContent();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SharedScaffold(
// //       body: FutureBuilder<FavoritesResponse?>(
// //         future: context.read<TinderViewCubit>().fetchFavorites(TinderSharedUtils.token),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           }
// //           else
// //             if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data!.favorites.isEmpty) {
// //             return const Center(child: Text('No data available'));
// //           }
// //
// //           final List<List<Favorite>> gridChunks = _splitListIntoChunks(snapshot.data!.data!.favorites, 4);
// //
// //           return ListView.builder(
// //             itemCount: gridChunks.length,
// //             itemBuilder: (context, index) {
// //               return _buildGridRow(context, gridChunks[index]);
// //             },
// //           );
// //         },
// //       ), mainCategoryId: 3,
// //     );
// //   }
// //
// //   /// Splits a list into chunks of a specified size.
// //   List<List<Favorite>> _splitListIntoChunks(List<Favorite> list, int chunkSize) {
// //     final List<List<Favorite>> chunks = [];
// //     for (var i = 0; i < list.length; i += chunkSize) {
// //       chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
// //     }
// //     return chunks;
// //   }
// //
// //   /// Builds a row of cards for the grid.
// //   Widget _buildGridRow(BuildContext context, List<Favorite> subCategoryChunk) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //       child: SingleChildScrollView(
// //         scrollDirection: Axis.horizontal,
// //         child: Row(
// //           children: subCategoryChunk
// //               .map((subCategoryData) => _buildCard(context, subCategoryData))
// //               .toList(),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Builds a single card with subcategory data.
// //   Widget _buildCard(BuildContext context, Favorite subCategoryData) {
// //     return Container(
// //       width: 200,
// //       height: MediaQuery.of(context).size.height / 4,
// //       padding: const EdgeInsets.all(8.0),
// //       child: Column(
// //         children: [Text(subCategoryData.user.firstName)],
// //       ),
// //     );
// //   }
// // }
// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/fav_category_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// //
// // class FavouriteSubCategoryView extends StatefulWidget {
// //   const FavouriteSubCategoryView({super.key});
// //
// //   @override
// //   State<FavouriteSubCategoryView> createState() =>
// //       _FavouriteSubCategoryViewState();
// // }
// //
// // class _FavouriteSubCategoryViewState extends State<FavouriteSubCategoryView> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return const _FavouriteSubCategoryViewContent();
// //   }
// // }
// //
// // class _FavouriteSubCategoryViewContent extends StatelessWidget {
// //   const _FavouriteSubCategoryViewContent();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SharedScaffold(
// //       body: FutureBuilder<FavoritesResponse?>(
// //         future: context
// //             .read<TinderViewCubit>()
// //             .fetchFavorites(TinderSharedUtils.token),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData ||
// //               snapshot.data == null ||
// //               snapshot.data!.data!.favorites!.isEmpty) {
// //             return const Center(child: Text('No data available'));
// //           }
// //
// //           // Ensure favorites and other potentially nullable fields are checked
// //           final favorites = snapshot.data!.data!.favorites ?? [];
// //           if (favorites.isEmpty) {
// //             return const Center(child: Text('No favorite categories found.'));
// //           }
// //
// //           context
// //               .read<TinderViewCubit>()
// //               .fetchFavorites(TinderSharedUtils.token);
// //           return BlocBuilder(
// //             builder: (context, state) {
// //               final List<List<Favorites>> gridChunks =
// //                   _splitListIntoChunks(favorites, 4);
// //
// //               return ListView.builder(
// //                 itemCount: gridChunks.length,
// //                 itemBuilder: (context, index) {
// //                   return _buildGridRow(context, gridChunks[index]);
// //                 },
// //               );
// //             },
// //           );
// //         },
// //       ),
// //       mainCategoryId: 5,
// //     );
// //   }
// //
// //   /// Splits a list into chunks of a specified size.
// //   List<List<Favorites>> _splitListIntoChunks(
// //       List<Favorites> list, int chunkSize) {
// //     final List<List<Favorites>> chunks = [];
// //     for (var i = 0; i < list.length; i += chunkSize) {
// //       chunks.add(list.sublist(
// //           i, i + chunkSize > list.length ? list.length : i + chunkSize));
// //     }
// //     return chunks;
// //   }
// //
// //   /// Builds a row of cards for the grid.
// //   Widget _buildGridRow(BuildContext context, List<Favorites> subCategoryChunk) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //       child: SingleChildScrollView(
// //         scrollDirection: Axis.horizontal,
// //         child: Row(
// //           children: subCategoryChunk
// //               .map((subCategoryData) => _buildCard(context, subCategoryData))
// //               .toList(),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Builds a single card with subcategory data.
// //   Widget _buildCard(BuildContext context, Favorites subCategoryData) {
// //     return Container(
// //       width: 200,
// //       height: MediaQuery.of(context).size.height / 4,
// //       padding: const EdgeInsets.all(8.0),
// //       child: Column(
// //         children: [
// //           Text(subCategoryData.categoryId!.nameAr ?? 'Unknown Category')
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/fav_category_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_subcategory_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
//
// class FavSubCategoryView extends StatelessWidget {
//   const FavSubCategoryView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => TinderViewCubit(),
//       child: const _FavSubCategoryViewContent(),
//     );
//   }
// }
//
// class _FavSubCategoryViewContent extends StatelessWidget {
//   const _FavSubCategoryViewContent();
//
//   @override
//   Widget build(BuildContext context) {
//     return SharedScaffold(
//       body: FutureBuilder<FavoritesResponse?>(
//         future: context
//             .read<TinderViewCubit>()
//             .fetchFavorites(TinderSharedUtils.token),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData ||
//               snapshot.data == null ||
//               snapshot.data!.data!.favorites!.isEmpty) {
//             return const Center(child: Text('No data available'));
//           }
//
//           final favorites = snapshot.data!.data!.favorites ?? [];
//           if (favorites.isEmpty) {
//             return const Center(child: Text('No favorite categories found.'));
//           }
//
//           return BlocBuilder<TinderViewCubit, TinderViewState>(
//             builder: (context, state) {
//               final List<List<Favorites>> gridChunks =
//                   _splitListIntoChunks(favorites, 4);
//
//               return ListView.builder(
//                 itemCount: gridChunks.length,
//                 itemBuilder: (context, index) {
//                   return _buildGridRow(context, gridChunks[index]);
//                 },
//               );
//             },
//           );
//         },
//       ),
//       mainCategoryId: 5,
//     );
//   }
//
//   /// Splits a list into chunks of a specified size.
//   List<List<Favorites>> _splitListIntoChunks(
//       List<Favorites> list, int chunkSize) {
//     final List<List<Favorites>> chunks = [];
//     for (var i = 0; i < list.length; i += chunkSize) {
//       chunks.add(list.sublist(
//           i, i + chunkSize > list.length ? list.length : i + chunkSize));
//     }
//     return chunks;
//   }
//
//   /// Builds a row of cards for the grid.
//   Widget _buildGridRow(BuildContext context, List<Favorites> subCategoryChunk) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: subCategoryChunk
//               .map((subCategoryData) => _buildCard(context, subCategoryData))
//               .toList(),
//         ),
//       ),
//     );
//   }
//
//   /// Builds a single card with subcategory data.
//   Widget _buildCard(BuildContext context, Favorites subCategoryData) {
//     return Container(
//       width: 200,
//       height: MediaQuery.of(context).size.height / 4,
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Text(subCategoryData.categoryId?.nameAr ?? 'Unknown Category')
//         ],
//       ),
//     );
//   }
// }
//refactored
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

// class FavSubCategoryView extends StatelessWidget {
//   final List<SubCategory> favoriteSubCategory;
//
//   const FavSubCategoryView({super.key, required this.favoriteSubCategory});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => TinderViewCubit()),
//         BlocProvider(
//           create: (context) => UserCubit(
//             serviceLocator(),
//             serviceLocator(),
//             serviceLocator(),
//             serviceLocator(),
//             serviceLocator(),serviceLocator()
//           ),
//         ),
//       ],
//       child: _FavSubCategoryViewContent(favoriteSubCategory),
//     );
//   }
// }
//
// class _FavSubCategoryViewContent extends StatefulWidget {
//   final List<SubCategory> favoriteSubCategory;
//
//   const _FavSubCategoryViewContent(this.favoriteSubCategory);
//
//   @override
//   State<_FavSubCategoryViewContent> createState() =>
//       _FavSubCategoryViewContentState();
// }
//
// class _FavSubCategoryViewContentState
//     extends State<_FavSubCategoryViewContent> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeTinderData();
//   }
//
//   void _initializeTinderData() {
//     final userCubit = context.read<UserCubit>();
//     userCubit.giveMeTokenForTinder().then((_) {
//       final tinderCubit = context.read<TinderViewCubit>();
//       final token = userCubit.state.token?.accessToken ?? '';
//       tinderCubit.fetchFavorites(token);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final tinderCubit = context.watch<TinderViewCubit>();
//     context.watch<UserCubit>();
//
//     return SharedScaffold(
//       body: Builder(
//         builder: (context) {
//           if (tinderCubit.state.getFavCategoryModel == null) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (tinderCubit.state.getFavCategoryModel!.data.isEmpty) {
//             return const Center(child: Text('No data available'));
//           }
//
//           return _buildFavoritesGrid(
//               context, tinderCubit.state.getFavCategoryModel!.data);
//         },
//       ),
//       mainCategoryId: 5,
//     );
//   }
//
//   Widget _buildFavoritesGrid(
//       BuildContext context, List<FavoriteItem> favorites) {
//     // Calculate the number of columns based on the screen width
//     int columns = MediaQuery.of(context).size.width ~/ 200;
//
//     return GridView.builder(
//       padding: const EdgeInsets.all(8.0),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: columns,
//         childAspectRatio: 0.75,
//         mainAxisSpacing: 8.0,
//         crossAxisSpacing: 8.0,
//       ),
//       itemCount: favorites.length,
//       itemBuilder: (context, index) {
//         return _buildCard(context, favorites[index]);
//       },
//     );
//   }
//
//   Widget _buildCard(BuildContext context, FavoriteItem favSubCategoryData) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       child: FavTinderSubCategoryCard(
//         favSubCategoryCardData: favSubCategoryData,
//         tinderViewCubit: context.read<TinderViewCubit>(),
//         activeFav: false,
//       ),
//     );
//   }
// }
//
// class FavTinderSubCategoryCard extends StatelessWidget {
//   final FavoriteItem favSubCategoryCardData;
//   final bool activeFav;
//   final TinderViewCubit tinderViewCubit;
//
//   const FavTinderSubCategoryCard({
//     super.key,
//     required this.favSubCategoryCardData,
//     required this.tinderViewCubit,
//     required this.activeFav,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {},
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Card(
//           clipBehavior: Clip.hardEdge,
//           color: Colors.white,
//           elevation: 2,
//           child: Column(
//             children: [
//               _buildImageSection(context),
//               const SizedBox(height: 8.0),
//               _buildInfoSection(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageSection(BuildContext context) {
//     return Expanded(
//       child: SizedBox(
//         width: double.infinity,
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: SquareImage(
//                 fit: BoxFit.cover,
//                 radius: 10,
//                 url: favSubCategoryCardData.subCategoryId.picture,
//               ),
//             ),
//             Positioned(
//               top: 5,
//               right: 5,
//               child: activeFav
//                   ? IconAppButton(
//                 size: 25,
//                 icon: Icons.favorite_border,
//                 color: Colors.red,
//                 onPressed: () => _navigateToDynamicGridView(context),
//               )
//                   : const Icon(
//                 size: 25,
//                 Icons.favorite,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoSection(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Label(
//                   text: favSubCategoryCardData.subCategoryId.nameEn,
//                   style: Styles.headerText(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Label(
//                   text: '${952} ads',
//                   style: Styles.mediumText(fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//           IconAppButton(
//             icon: Icons.add,
//             isCircle: true,
//             color: Colors.white,
//             backColor: AppColors.PRIMARY_COLOR,
//             onPressed: () {
//               _navigateToAdsView(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToAdsView(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AdsView(
//           params: AdsViewParams(
//             mainCategory: MainCategoryEntity(
//               id: favSubCategoryCardData.id,
//               name: favSubCategoryCardData.subCategoryId.nameEn,
//               image: favSubCategoryCardData.subCategoryId.picture,
//               banner: favSubCategoryCardData.subCategoryId.picture,
//               cover: favSubCategoryCardData.subCategoryId.picture,
//               isFavorite: true,
//               total: 2,
//             ),
//             subCategory: SubCategoryEntity(
//               id: favSubCategoryCardData.id,
//               name: favSubCategoryCardData.subCategoryId.nameEn,
//               image: favSubCategoryCardData.subCategoryId.picture,
//               isFavorite: true,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _navigateToDynamicGridView(BuildContext context) {
//     tinderViewCubit
//         .fetchFavorites(TinderSharedUtils.token)
//         .then((value) => Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const FavSubCategoryView(
//           favoriteSubCategory: [],
//         ),
//       ),
//     ));
//   }
// }
//

class FavSubCategoryView extends StatelessWidget {
  final List<SubCategory> favoriteSubCategory;

  const FavSubCategoryView({super.key, required this.favoriteSubCategory});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TinderViewCubit(),
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
      child: _FavSubCategoryViewContent(favoriteSubCategory),
    );
  }
}

class _FavSubCategoryViewContent extends StatefulWidget {
  final List<SubCategory> favoriteSubCategory;

  const _FavSubCategoryViewContent(this.favoriteSubCategory);

  @override
  State<_FavSubCategoryViewContent> createState() =>
      _FavSubCategoryViewContentState();
}

class _FavSubCategoryViewContentState
    extends State<_FavSubCategoryViewContent> {
  @override
  void initState() {
    // TODO: implement initState
    _initializeTinderData();
    super.initState();
  }

  void _initializeTinderData() {
    final userCubit = context.read<UserCubit>();
    userCubit.giveMeTokenForTinder().then((_) {
      final tinderCubit = context.read<TinderViewCubit>();
      tinderCubit.fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tinderCubit = context.watch<TinderViewCubit>();
    context.watch<UserCubit>();

    return SharedScaffold(
      // body: _buildFavoritesGrid(context, widget.favoriteSubCategory),
      body: Builder(
        builder: (context) {
          if (tinderCubit.state.getFavCategoryModel == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (tinderCubit.state.getFavCategoryModel!.data.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return _buildFavoritesGrid(
              context, tinderCubit.state.getFavCategoryModel!.data);
        },
      ),
      // FutureBuilder<FavoritesResponse?>(
      //   future: context
      //       .read<TinderViewCubit>()
      //       .fetchFavorites(TinderSharedUtils.token),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else if (!snapshot.hasData ||
      //         snapshot.data!.data!.favorites!.isEmpty) {
      //       return const Center(child: Text('No data available'));
      //     }
      //
      //     final favorites = snapshot.data!.data!.favorites!;
      //     return _buildFavoritesGrid(context, favorites);
      //   },
      // ),
      mainCategoryId: 5,
    );
  }

  Widget _buildFavoritesGrid(
      BuildContext context, List<FavoriteItem> favorites) {
    final gridChunks = _splitListIntoChunks(favorites, 4);

    return ListView.builder(
      itemCount: gridChunks.length,
      itemBuilder: (context, index) {
        return _buildGridRow(context, gridChunks[index]);
      },
    );
  }

  List<List<FavoriteItem>> _splitListIntoChunks(
      List<FavoriteItem> list, int chunkSize) {
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
      BuildContext context, List<FavoriteItem> subCategoryChunk) {
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

  Widget _buildCard(BuildContext context, FavoriteItem favSubCategoryData) {
    return Container(
        width: 200,
        height: MediaQuery.of(context).size.height / 4,
        padding: const EdgeInsets.all(8.0),
        child: FavTinderSubCategoryCard(
            favSubCategoryCardData: favSubCategoryData,
            tinderViewCubit: context.read<TinderViewCubit>(),
            activeFav: false)
        // Column(
        //   children: [
        //     Text(favSubCategoryData.categoryId?.nameAr ?? 'Unknown Category'),
        //   ],
        // ),
        );
  }
}

class FavTinderSubCategoryCard extends StatelessWidget {
  final FavoriteItem favSubCategoryCardData;
  final bool activeFav;
  final TinderViewCubit tinderViewCubit;

  const FavTinderSubCategoryCard({
    super.key,
    required this.favSubCategoryCardData,
    required this.tinderViewCubit,
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
        ),
        child: Card(
          clipBehavior: Clip.hardEdge,
          color: Colors.white,
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
                url: favSubCategoryCardData.subCategoryId.picture,
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
                      onPressed: () => _navigateToDynamicGridView(context),
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
                  text: favSubCategoryCardData.subCategoryId.nameEn,
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
          IconAppButton(
            icon: Icons.add,
            isCircle: true,
            color: Colors.white,
            backColor: AppColors.PRIMARY_COLOR,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdsView(
                      params: AdsViewParams(
                        mainCategory: MainCategoryEntity(
                          id: favSubCategoryCardData.id,
                          name: favSubCategoryCardData.subCategoryId.nameEn,
                          image: favSubCategoryCardData.subCategoryId.picture,
                          banner: favSubCategoryCardData.subCategoryId.picture,
                          cover: favSubCategoryCardData.subCategoryId.picture,
                          isFavorite: true,
                          total: 2,
                        ),
                        subCategory: SubCategoryEntity(
                          id: favSubCategoryCardData.id,
                          name: favSubCategoryCardData.subCategoryId.nameEn,
                          image: favSubCategoryCardData.subCategoryId.picture,
                          isFavorite: true,
                        ),
                      ),
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }

  void _navigateToDynamicGridView(BuildContext context) {
    context
        .read<TinderViewCubit>()
        .fetchFavorites()
        .then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavSubCategoryView(
                  favoriteSubCategory: [],
                ),
              ),
            ));
  }
}
