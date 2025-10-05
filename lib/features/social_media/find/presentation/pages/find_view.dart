import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../domain/entity/find_entity.dart';
import '../cubit/find_cubit.dart'; // your cubit

import '../cubit/find_state.dart';


// class FindScreen extends StatefulWidget {
//   const FindScreen({Key? key}) : super(key: key);
//
//   @override
//   State<FindScreen> createState() => _FindScreenState();
// }
//
// class _FindScreenState extends State<FindScreen> {
//   String selectedGender = "male";
//   int _currentCardIndex = 0;
//   CardSwiperDirection? _swipeDirection;
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<FindCubit>().loadInitialFindData(context, gender: selectedGender);
//   }
//
//   void _switchGender(String gender) {
//     setState(() {
//       selectedGender = gender;
//       _currentCardIndex = 0;
//     });
//     context.read<FindCubit>().loadInitialFindData(context, gender: gender);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Find People"),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: _switchGender,
//             itemBuilder: (context) => [
//               const PopupMenuItem(value: "male", child: Text("Show Male")),
//               const PopupMenuItem(value: "female", child: Text("Show Female")),
//             ],
//             child: Row(
//               children: [
//                 Text(selectedGender.toUpperCase(),
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//                 const Icon(Icons.arrow_drop_down),
//                 const SizedBox(width: 8),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: BlocBuilder<FindCubit, FindState>(
//         builder: (context, state) {
//           final cubit = context.read<FindCubit>();
//
//           if (cubit.isFindDataInitialLoading && state.findData!.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (state.status == FindStates.failure && state.findData!.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Failed to load data"),
//                   const SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () => cubit.loadInitialFindData(context, gender: selectedGender),
//                     child: const Text("Retry"),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           if (cubit.findData.isEmpty) {
//             return const Center(child: Text("No people found"));
//           }
//
//           // return _buildCardSwiper(context, cubit.findData);
//           return _buildScrollableList(context, cubit.findData);
//         },
//       ),
//     );
//   }
//   Widget _buildScrollableList(BuildContext context, List<FindEntity> people) {
//     return NotificationListener<ScrollNotification>(
//       onNotification: (ScrollNotification scrollInfo) {
//         if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//           // Load more data when reached bottom
//           context.read<FindCubit>().getFindData(context);
//         }
//         return false;
//       },
//       child: ListView.builder(
//         padding: const EdgeInsets.only(bottom: 80),
//         itemCount: people.length,
//         itemBuilder: (context, index) {
//           final person = people[index];
//           return Column(
//             children: [
//               _buildPersonCard(context, person), // your existing card
//               _buildActions(context, person),    // same buttons below each card
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildCardSwiper(BuildContext context, List<FindEntity> people) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.90,
//       child: CardSwiper(
//         backCardOffset: const Offset(0, 0),
//         initialIndex: _currentCardIndex,
//         cardsCount: people.length,
//         threshold: 30,
//         allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true),
//         numberOfCardsDisplayed: 3,
//         isLoop: false,
//         padding: const EdgeInsets.only(bottom: 24),
//         maxAngle: 50,
//         onSwipe: (previousIndex, currentIndex, direction) {
//           final person = people[previousIndex];
//
//           // Handle swipe actions
//           if (direction == CardSwiperDirection.right) {
//             context.read<FindCubit>().addDisLikeFind(id: person.id!);
//           } else if (direction == CardSwiperDirection.left) {
//             context.read<FindCubit>().addLikeFind(id: person.id!);
//           }
//
//           setState(() {
//             _currentCardIndex = currentIndex ?? 0;
//             _swipeDirection = null;
//           });
//
//           // Load more when approaching end
//           if (currentIndex != null && currentIndex >= people.length - 3) {
//             context.read<FindCubit>().getFindData(context);
//           }
//
//           return true;
//         },
//         onSwipeDirectionChange: (horizontal, vertical) {
//           setState(() {
//             _swipeDirection = horizontal;
//           });
//         },
//         cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
//           final person = people[index];
//
//           String? swipeLabel;
//           Color? labelColor;
//
//           if (_swipeDirection != null && index == _currentCardIndex) {
//             if (_swipeDirection == CardSwiperDirection.right) {
//               swipeLabel = 'NOPE';
//               labelColor = const Color(0xffEB545D);
//             } else if (_swipeDirection == CardSwiperDirection.left) {
//               swipeLabel = 'LIKE';
//               labelColor = Colors.green;
//             }
//           }
//
//           return Stack(
//             children: [
//               _buildPersonCard(context, person),
//               if (swipeLabel != null)
//                 Positioned(
//                   top: 60,
//                   left: _swipeDirection == CardSwiperDirection.left ? null : 30,
//                   right: _swipeDirection == CardSwiperDirection.left ? 30 : null,
//                   child: Transform.rotate(
//                     angle: _swipeDirection == CardSwiperDirection.right ? -0.6 : 0.6,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: labelColor ?? Colors.white, width: 5),
//                       ),
//                       child: Text(
//                         swipeLabel,
//                         style: TextStyle(
//                           color: labelColor,
//                           fontSize: 48,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               _buildActions(context, person),
//             ],
//           );
//         },
//         duration: const Duration(milliseconds: 100),
//       ),
//     );
//   }
//
//   Widget _buildPersonCard(BuildContext context, FindEntity person) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         elevation: 8,
//         child: PersonCardContent(person: person),
//       ),
//     );
//   }
//
//   Widget _buildActions(BuildContext context, FindEntity person) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildActionButton(
//             icon: Icons.close,
//             color: Colors.red,
//             onPressed: () {
//               context.read<FindCubit>().addDisLikeFind(id: person.id!);
//             },
//           ),
//           _buildActionButton(
//             icon: Icons.favorite,
//             color: Colors.pink,
//             onPressed: () {
//               context.read<FindCubit>().addLoveFind(id: person.id!);
//             },
//           ),
//           _buildActionButton(
//             icon: Icons.thumb_up,
//             color: Colors.green,
//             onPressed: () {
//               context.read<FindCubit>().addLikeFind(id: person.id!);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return FloatingActionButton(
//       heroTag: UniqueKey(),
//       elevation: 4,
//       onPressed: onPressed,
//       backgroundColor: Colors.white,
//       mini: true,
//       child: Icon(icon, color: color, size: 28),
//     );
//   }
// }
//
// class PersonCardContent extends StatefulWidget {
//   final FindEntity person;
//
//   const PersonCardContent({Key? key, required this.person}) : super(key: key);
//
//   @override
//   State<PersonCardContent> createState() => _PersonCardContentState();
// }
//
// class _PersonCardContentState extends State<PersonCardContent> {
//   int _currentImageIndex = 0;
//   final List<String> _dummyImages = [
//     'https://picsum.photos/400/600?random=1',
//     'https://picsum.photos/400/600?random=2',
//     'https://picsum.photos/400/600?random=3',
//   ];
//
//   void _nextImage() {
//     if (_currentImageIndex < _dummyImages.length - 1) {
//       setState(() => _currentImageIndex++);
//     }
//   }
//
//   void _previousImage() {
//     if (_currentImageIndex > 0) {
//       setState(() => _currentImageIndex--);
//     }
//   }
//
//   void _handleTap(Offset localPosition, double screenWidth) {
//     final bool tappedLeftSide = localPosition.dx < screenWidth / 2;
//     if (tappedLeftSide) {
//       _previousImage();
//     } else {
//       _nextImage();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return GestureDetector(
//       onTapUp: (details) => _handleTap(details.localPosition, screenWidth),
//       child: Stack(
//         children: [
//           // Main Image
//           Image.network(
//             _dummyImages[_currentImageIndex],
//             width: double.infinity,
//             height: double.infinity,
//             fit: BoxFit.cover,
//             errorBuilder: (_, __, ___) => Container(
//               color: Colors.grey[300],
//               child: const Icon(Icons.person, size: 100, color: Colors.grey),
//             ),
//           ),
//
//           // Gradient overlay
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.7),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Progress indicators
//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: Row(
//               children: List.generate(
//                 _dummyImages.length,
//                     (index) => Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 2.0),
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: index <= _currentImageIndex
//                           ? Colors.white
//                           : Colors.white.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // Person info
//           Positioned(
//             bottom: 80,
//             left: 16,
//             right: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "${widget.person.firstName ?? ''} ${widget.person.lastName ?? ''}",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         offset: Offset(1.0, 1.0),
//                         blurRadius: 4.0,
//                         color: Colors.black,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Followers: ${widget.person.followersCount}",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     shadows: [
//                       Shadow(
//                         offset: Offset(1.0, 1.0),
//                         blurRadius: 4.0,
//                         color: Colors.black,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_swiper/card_swiper.dart'; // adjust if your package path differs
// import your FindCubit / FindState / FindEntity definitions
// import 'path/to/find_cubit.dart';
// import 'path/to/find_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_swiper/card_swiper.dart';

// import your cubit/entity
// import 'path/to/find_cubit.dart';
// import 'path/to/find_entity.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:card_swiper/card_swiper.dart';

// import your cubit/entity
// import 'path/to/find_cubit.dart';
// import 'path/to/find_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Replace with your imports
// import 'find_cubit.dart';
// import 'find_entity.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart'; // Make sure this is imported

class FindScreen extends StatefulWidget {
  const FindScreen({Key? key}) : super(key: key);

  @override
  State<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  String selectedGender = "male";

  @override
  void initState() {
    super.initState();
    context.read<FindCubit>().loadInitialFindData(context, gender: selectedGender);
  }

  void _switchGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
    context.read<FindCubit>().loadInitialFindData(context, gender: gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find People"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _switchGender,
            itemBuilder: (context) => [
              const PopupMenuItem(value: "male", child: Text("Show Male")),
              const PopupMenuItem(value: "female", child: Text("Show Female")),
            ],
            child: Row(
              children: [
                Text(selectedGender.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Icon(Icons.arrow_drop_down),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<FindCubit, FindState>(
        builder: (context, state) {
          final cubit = context.read<FindCubit>();

          if (cubit.isFindDataInitialLoading && state.findData!.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FindStates.failure && state.findData!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Failed to load data"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => cubit.loadInitialFindData(context, gender: selectedGender),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (cubit.findData.isEmpty) {
            return const Center(child: Text("No people found"));
          }

          return _buildScrollableSwipeList(context, cubit.findData);
        },
      ),
    );
  }

  /// 🔹 Scrollable list where each item is swipeable like Tinder
  Widget _buildScrollableSwipeList(BuildContext context, List<FindEntity> people) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          context.read<FindCubit>().getFindData(context);
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: CardSwiper(
              cardsCount: 1, // ✅ always at least 1 card
              numberOfCardsDisplayed: 1, // ✅ must not exceed cardsCount
              allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true),
              onSwipe: (prev, curr, direction) {
                if (direction == CardSwiperDirection.right) {
                  context.read<FindCubit>().addDisLikeFind(id: person.id!);
                } else if (direction == CardSwiperDirection.left) {
                  context.read<FindCubit>().addLikeFind(id: person.id!);
                }
                return true;
              },
              cardBuilder: (context, cardIndex, hOffset, vOffset) {
                return Stack(
                  children: [
                    _buildPersonCard(context, person),

                    // 🔹 Overlay swipe label
                    if (hOffset != 0)
                      Positioned(
                        top: 60,
                        left: hOffset < 0 ? null : 30,
                        right: hOffset < 0 ? 30 : null,
                        child: Transform.rotate(
                          angle: hOffset < 0 ? 0.6 : -0.6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: hOffset < 0 ? Colors.green : const Color(0xffEB545D),
                                width: 5,
                              ),
                            ),
                            child: Text(
                              hOffset < 0 ? "LIKE" : "NOPE",
                              style: TextStyle(
                                color: hOffset < 0 ? Colors.green : const Color(0xffEB545D),
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                    _buildActions(context, person),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonCard(BuildContext context, FindEntity person) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: PersonCardContent(person: person),
      ),
    );
  }

  Widget _buildActions(BuildContext context, FindEntity person) {
    return Positioned(
      bottom: 20,
      right: 8,
      left: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: Icons.close,
              color: Colors.red,
              onPressed: () {
                context.read<FindCubit>().addDisLikeFind(id: person.id!);
              },
            ),
            _buildActionButton(
              icon: Icons.favorite,
              color: Colors.pink,
              onPressed: () {
                context.read<FindCubit>().addLoveFind(id: person.id!);
              },
            ),
            _buildActionButton(
              icon: Icons.thumb_up,
              color: Colors.green,
              onPressed: () {
                context.read<FindCubit>().addLikeFind(id: person.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      elevation: 4,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      mini: true,
      child: Icon(icon, color: color, size: 28),
    );
  }
}

/// 🔹 PersonCardContent with fake images fallback
class PersonCardContent extends StatefulWidget {
  final FindEntity person;

  const PersonCardContent({Key? key, required this.person}) : super(key: key);

  @override
  State<PersonCardContent> createState() => _PersonCardContentState();
}

class _PersonCardContentState extends State<PersonCardContent> {
  int _currentImageIndex = 0;

  List<String> get _images {
    if (widget.person.pictures != null && widget.person.pictures!.isNotEmpty) {
      return widget.person.pictures!;
    }
    // ✅ fallback fake images
    return [
      'https://picsum.photos/400/600?random=1',
      'https://picsum.photos/400/600?random=2',
      'https://picsum.photos/400/600?random=3',
    ];
  }

  void _nextImage() {
    if (_currentImageIndex < _images.length - 1) {
      setState(() => _currentImageIndex++);
    }
  }

  void _previousImage() {
    if (_currentImageIndex > 0) {
      setState(() => _currentImageIndex--);
    }
  }

  void _handleTap(Offset localPosition, double screenWidth) {
    final bool tappedLeftSide = localPosition.dx < screenWidth / 2;
    if (tappedLeftSide) {
      _previousImage();
    } else {
      _nextImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapUp: (details) => _handleTap(details.localPosition, screenWidth),
      child: Stack(
        children: [
          Image.network(
            _images[_currentImageIndex],
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.person, size: 100, color: Colors.grey),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              children: List.generate(
                _images.length,
                    (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= _currentImageIndex
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.person.firstName ?? ''} ${widget.person.lastName ?? ''}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(offset: Offset(1.0, 1.0), blurRadius: 4.0, color: Colors.black),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Followers: ${widget.person.followersCount}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    shadows: [
                      Shadow(offset: Offset(1.0, 1.0), blurRadius: 4.0, color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// the list here
// class FindScreen extends StatefulWidget {
//   const FindScreen({Key? key}) : super(key: key);
//
//   @override
//   State<FindScreen> createState() => _FindScreenState();
// }
//
// class _FindScreenState extends State<FindScreen> {
//   String selectedGender = "male";
//   int _currentCardIndex = 0;
//   CardSwiperDirection? _swipeDirection;
//
//   @override
//   void initState() {
//     super.initState();
//     // initial load
//     context.read<FindCubit>().loadInitialFindData(context, gender: selectedGender);
//   }
//
//   void _switchGender(String gender) {
//     setState(() {
//       selectedGender = gender;
//       _currentCardIndex = 0;
//     });
//     context.read<FindCubit>().loadInitialFindData(context, gender: gender);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Find People"),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: _switchGender,
//             itemBuilder: (context) => [
//               const PopupMenuItem(value: "male", child: Text("Show Male")),
//               const PopupMenuItem(value: "female", child: Text("Show Female")),
//             ],
//             child: Row(
//               children: [
//                 Text(selectedGender.toUpperCase(),
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//                 const Icon(Icons.arrow_drop_down),
//                 const SizedBox(width: 8),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: BlocBuilder<FindCubit, FindState>(
//         builder: (context, state) {
//           final cubit = context.read<FindCubit>();
//
//           if (cubit.isFindDataInitialLoading && (state.findData == null || state.findData!.isEmpty)) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (state.status == FindStates.failure && (state.findData == null || state.findData!.isEmpty)) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Failed to load data"),
//                   const SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () => cubit.loadInitialFindData(context, gender: selectedGender),
//                     child: const Text("Retry"),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           final people = cubit.findData;
//           if (people.isEmpty) {
//             return const Center(child: Text("No people found"));
//           }
//
//           // Choose which UI you want: scrollable list or swiper.
//           // I keep both implemented; uncomment the mode you want.
//           // return _buildCardSwiper(context, people);
//           return _buildScrollableList(context, people);
//         },
//       ),
//     );
//   }
//
//   // -------------------- Scrollable List Mode --------------------
//   Widget _buildScrollableList(BuildContext context, List<FindEntity> people) {
//     final cubit = context.read<FindCubit>();
//
//     return NotificationListener<ScrollNotification>(
//       onNotification: (ScrollNotification scrollInfo) {
//         // trigger when near bottom (200px threshold)
//         if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
//           if (!cubit.isFindDataLoadingMore) {
//             cubit.getFindData(context);
//           }
//         }
//         return false;
//       },
//       child: ListView.builder(
//         padding: const EdgeInsets.only(bottom: 32),
//         itemCount: people.length + 1, // +1 for optional loader at end
//         itemBuilder: (context, index) {
//           if (index == people.length) {
//             // optional loader at bottom
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Center(
//                 child: cubit.isFindDataLoadingMore
//                     ? const CircularProgressIndicator()
//                     : const SizedBox.shrink(),
//               ),
//             );
//           }
//
//           final person = people[index];
//           return Column(
//             children: [
//               // Constrain card height to avoid unbounded image height inside ListView
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.72,
//                 child: _buildPersonCard(context, person),
//               ),
//               _buildActions(context, person, positioned: false),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // -------------------- Card Swiper Mode --------------------
//   Widget _buildCardSwiper(BuildContext context, List<FindEntity> people) {
//     final cubit = context.read<FindCubit>();
//
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.90,
//       child: CardSwiper(
//         backCardOffset: const Offset(0, 0),
//         initialIndex: _currentCardIndex,
//         cardsCount: people.length,
//         threshold: 30,
//         allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true),
//         numberOfCardsDisplayed: 3,
//         isLoop: false,
//         padding: const EdgeInsets.only(bottom: 24),
//         maxAngle: 50,
//         onSwipe: (previousIndex, currentIndex, direction) {
//           final person = people[previousIndex];
//
//           // Handle swipe actions
//           if (direction == CardSwiperDirection.right) {
//             context.read<FindCubit>().addDisLikeFind(id: person.id!);
//           } else if (direction == CardSwiperDirection.left) {
//             context.read<FindCubit>().addLikeFind(id: person.id!);
//           }
//
//           setState(() {
//             _currentCardIndex = currentIndex ?? 0;
//             _swipeDirection = null;
//           });
//
//           // Load more when approaching end
//           if (currentIndex != null && currentIndex >= people.length - 3) {
//             context.read<FindCubit>().getFindData(context);
//           }
//
//           return true;
//         },
//         onSwipeDirectionChange: (horizontal, vertical) {
//           setState(() {
//             _swipeDirection = horizontal;
//           });
//         },
//         cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
//           final person = people[index];
//
//           String? swipeLabel;
//           Color? labelColor;
//
//           if (_swipeDirection != null && index == _currentCardIndex) {
//             if (_swipeDirection == CardSwiperDirection.right) {
//               swipeLabel = 'NOPE';
//               labelColor = const Color(0xffEB545D);
//             } else if (_swipeDirection == CardSwiperDirection.left) {
//               swipeLabel = 'LIKE';
//               labelColor = Colors.green;
//             }
//           }
//
//           return Stack(
//             fit: StackFit.expand,
//             children: [
//               // In swiper mode the parent SizedBox gives constraints, so PersonCardContent can use double.infinity
//               _buildPersonCard(context, person),
//               if (swipeLabel != null)
//                 Positioned(
//                   top: 60,
//                   left: _swipeDirection == CardSwiperDirection.left ? null : 30,
//                   right: _swipeDirection == CardSwiperDirection.left ? 30 : null,
//                   child: Transform.rotate(
//                     angle: _swipeDirection == CardSwiperDirection.right ? -0.6 : 0.6,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: labelColor ?? Colors.white, width: 5),
//                       ),
//                       child: Text(
//                         swipeLabel,
//                         style: TextStyle(
//                           color: labelColor,
//                           fontSize: 48,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               // For swiper mode we want the actions placed at bottom, so we request positioned:true
//               _buildActions(context, person, positioned: true),
//             ],
//           );
//         },
//         duration: const Duration(milliseconds: 100),
//       ),
//     );
//   }
//
//   // -------------------- Person Card --------------------
//   Widget _buildPersonCard(BuildContext context, FindEntity person) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         elevation: 8,
//         child: PersonCardContent(person: person),
//       ),
//     );
//   }
//
//   // -------------------- Actions (reusable) --------------------
//   // If positioned==true => we return a Positioned widget (for Stack/swiper)
//   // otherwise return a normal Padding Row (for ListView)
//   Widget _buildActions(BuildContext context, FindEntity person, {bool positioned = false}) {
//     final content = Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildActionButton(
//             icon: Icons.close,
//             color: Colors.red,
//             onPressed: () {
//               context.read<FindCubit>().addDisLikeFind(id: person.id!);
//             },
//           ),
//           _buildActionButton(
//             icon: Icons.favorite,
//             color: Colors.pink,
//             onPressed: () {
//               context.read<FindCubit>().addLoveFind(id: person.id!);
//             },
//           ),
//           _buildActionButton(
//             icon: Icons.thumb_up,
//             color: Colors.green,
//             onPressed: () {
//               context.read<FindCubit>().addLikeFind(id: person.id!);
//             },
//           ),
//         ],
//       ),
//     );
//
//     if (positioned) {
//       return Positioned(
//         bottom: 20,
//         left: 8,
//         right: 8,
//         child: content,
//       );
//     } else {
//       return content;
//     }
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return FloatingActionButton(
//       heroTag: UniqueKey(),
//       elevation: 4,
//       onPressed: onPressed,
//       backgroundColor: Colors.white,
//       mini: true,
//       child: Icon(icon, color: color, size: 28),
//     );
//   }
// }
//
// // -------------------- PersonCardContent --------------------
// class PersonCardContent extends StatefulWidget {
//   final FindEntity person;
//
//   const PersonCardContent({Key? key, required this.person}) : super(key: key);
//
//   @override
//   State<PersonCardContent> createState() => _PersonCardContentState();
// }
//
// class _PersonCardContentState extends State<PersonCardContent> {
//   int _currentImageIndex = 0;
//   final List<String> _dummyImages = [
//     'https://picsum.photos/800/1200?random=1',
//     'https://picsum.photos/800/1200?random=2',
//     'https://picsum.photos/800/1200?random=3',
//   ];
//
//   void _nextImage() {
//     if (_currentImageIndex < _dummyImages.length - 1) {
//       setState(() => _currentImageIndex++);
//     }
//   }
//
//   void _previousImage() {
//     if (_currentImageIndex > 0) {
//       setState(() => _currentImageIndex--);
//     }
//   }
//
//   void _handleTap(Offset localPosition, double screenWidth) {
//     final bool tappedLeftSide = localPosition.dx < screenWidth / 2;
//     if (tappedLeftSide) {
//       _previousImage();
//     } else {
//       _nextImage();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // The parent widget (either SizedBox in list mode or CardSwiper's SizedBox) will constrain height.
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return GestureDetector(
//       onTapUp: (details) => _handleTap(details.localPosition, screenWidth),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Main Image - use double.infinity height because parent provides constraints
//           Image.network(
//             _dummyImages[_currentImageIndex],
//             width: double.infinity,
//             height: double.infinity,
//             fit: BoxFit.cover,
//             errorBuilder: (_, __, ___) => Container(
//               color: Colors.grey[300],
//               child: const Icon(Icons.person, size: 100, color: Colors.grey),
//             ),
//           ),
//
//           // Gradient overlay
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.7),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Progress indicators
//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: Row(
//               children: List.generate(
//                 _dummyImages.length,
//                     (index) => Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 2.0),
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: index <= _currentImageIndex
//                           ? Colors.white
//                           : Colors.white.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // Person info
//           Positioned(
//             bottom: 80,
//             left: 16,
//             right: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "${widget.person.firstName ?? ''} ${widget.person.lastName ?? ''}",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         offset: Offset(1.0, 1.0),
//                         blurRadius: 4.0,
//                         color: Colors.black,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Followers: ${widget.person.followersCount ?? 0}",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     shadows: [
//                       Shadow(
//                         offset: Offset(1.0, 1.0),
//                         blurRadius: 4.0,
//                         color: Colors.black,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



/*
class FindScreen extends StatefulWidget {
  const FindScreen({Key? key}) : super(key: key);

  @override
  State<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  String selectedGender = "male";
  int _currentCardIndex = 0;
  CardSwiperDirection? _swipeDirection;

  @override
  void initState() {
    super.initState();
    context.read<FindCubit>().loadInitialFindData(context, gender: selectedGender);
  }

  void _switchGender(String gender) {
    setState(() {
      selectedGender = gender;
      _currentCardIndex = 0;
    });
    context.read<FindCubit>().loadInitialFindData(context, gender: gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find People"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _switchGender,
            itemBuilder: (context) => [
              const PopupMenuItem(value: "male", child: Text("Show Male")),
              const PopupMenuItem(value: "female", child: Text("Show Female")),
            ],
            child: Row(
              children: [
                Text(selectedGender.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Icon(Icons.arrow_drop_down),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<FindCubit, FindState>(
        builder: (context, state) {
          final cubit = context.read<FindCubit>();

          if (cubit.isFindDataInitialLoading && state.findData!.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FindStates.failure && state.findData!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Failed to load data"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => cubit.loadInitialFindData(context, gender: selectedGender),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (cubit.findData.isEmpty) {
            return const Center(child: Text("No people found"));
          }

          return _buildCardSwiper(context, cubit.findData);
        },
      ),
    );
  }

  Widget _buildCardSwiper(BuildContext context, List<FindEntity> people) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.90,
      child: CardSwiper(
        backCardOffset: const Offset(0, 0),
        initialIndex: _currentCardIndex,
        cardsCount: people.length,
        threshold: 30,
        allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true),
        numberOfCardsDisplayed: 3,
        isLoop: false,
        padding: const EdgeInsets.only(bottom: 24),
        maxAngle: 50,
        onSwipe: (previousIndex, currentIndex, direction) {
          final person = people[previousIndex];

          // Handle swipe actions
          if (direction == CardSwiperDirection.right) {
            context.read<FindCubit>().addDisLikeFind(id: person.id!);
          } else if (direction == CardSwiperDirection.left) {
            context.read<FindCubit>().addLikeFind(id: person.id!);
          }

          setState(() {
            _currentCardIndex = currentIndex ?? 0;
            _swipeDirection = null;
          });

          // Load more when approaching end
          if (currentIndex != null && currentIndex >= people.length - 3) {
            context.read<FindCubit>().getFindData(context);
          }

          return true;
        },
        onSwipeDirectionChange: (horizontal, vertical) {
          setState(() {
            _swipeDirection = horizontal;
          });
        },
        cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
          final person = people[index];

          String? swipeLabel;
          Color? labelColor;

          if (_swipeDirection != null && index == _currentCardIndex) {
            if (_swipeDirection == CardSwiperDirection.right) {
              swipeLabel = 'NOPE';
              labelColor = const Color(0xffEB545D);
            } else if (_swipeDirection == CardSwiperDirection.left) {
              swipeLabel = 'LIKE';
              labelColor = Colors.green;
            }
          }

          return Stack(
            children: [
              _buildPersonCard(context, person),
              if (swipeLabel != null)
                Positioned(
                  top: 60,
                  left: _swipeDirection == CardSwiperDirection.left ? null : 30,
                  right: _swipeDirection == CardSwiperDirection.left ? 30 : null,
                  child: Transform.rotate(
                    angle: _swipeDirection == CardSwiperDirection.right ? -0.6 : 0.6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: labelColor ?? Colors.white, width: 5),
                      ),
                      child: Text(
                        swipeLabel,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              _buildActions(context, person),
            ],
          );
        },
        duration: const Duration(milliseconds: 100),
      ),
    );
  }

  Widget _buildPersonCard(BuildContext context, FindEntity person) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: PersonCardContent(person: person),
      ),
    );
  }

  Widget _buildActions(BuildContext context, FindEntity person) {
    return Positioned(
      bottom: 20,
      right: 8,
      left: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: Icons.close,
              color: Colors.red,
              onPressed: () {
                context.read<FindCubit>().addDisLikeFind(id: person.id!);
              },
            ),
            _buildActionButton(
              icon: Icons.favorite,
              color: Colors.pink,
              onPressed: () {
                context.read<FindCubit>().addLoveFind(id: person.id!);
              },
            ),
            _buildActionButton(
              icon: Icons.thumb_up,
              color: Colors.green,
              onPressed: () {
                context.read<FindCubit>().addLikeFind(id: person.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      elevation: 4,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      mini: true,
      child: Icon(icon, color: color, size: 28),
    );
  }
}

class PersonCardContent extends StatefulWidget {
  final FindEntity person;

  const PersonCardContent({Key? key, required this.person}) : super(key: key);

  @override
  State<PersonCardContent> createState() => _PersonCardContentState();
}

class _PersonCardContentState extends State<PersonCardContent> {
  int _currentImageIndex = 0;
  final List<String> _dummyImages = [
    'https://picsum.photos/400/600?random=1',
    'https://picsum.photos/400/600?random=2',
    'https://picsum.photos/400/600?random=3',
  ];

  void _nextImage() {
    if (_currentImageIndex < _dummyImages.length - 1) {
      setState(() => _currentImageIndex++);
    }
  }

  void _previousImage() {
    if (_currentImageIndex > 0) {
      setState(() => _currentImageIndex--);
    }
  }

  void _handleTap(Offset localPosition, double screenWidth) {
    final bool tappedLeftSide = localPosition.dx < screenWidth / 2;
    if (tappedLeftSide) {
      _previousImage();
    } else {
      _nextImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapUp: (details) => _handleTap(details.localPosition, screenWidth),
      child: Stack(
        children: [
          // Main Image
          Image.network(
            _dummyImages[_currentImageIndex],
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.person, size: 100, color: Colors.grey),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Progress indicators
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              children: List.generate(
                _dummyImages.length,
                    (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= _currentImageIndex
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Person info
          Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.person.firstName ?? ''} ${widget.person.lastName ?? ''}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Followers: ${widget.person.followersCount}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/