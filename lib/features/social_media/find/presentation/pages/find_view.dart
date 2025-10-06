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
//   final CardSwiperController _cardController = CardSwiperController();
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<FindCubit>().loadInitialFindData(context, gender: selectedGender);
//   }
//
//   @override
//   void dispose() {
//     _cardController.dispose();
//     super.dispose();
//   }
//
//   void _switchGender(String gender) {
//     setState(() {
//       selectedGender = gender;
//       _currentCardIndex = 0;
//       _swipeDirection = null;
//     });
//     context.read<FindCubit>().loadInitialFindData(context, gender: gender);
//   }
//
//   @override
//   void didUpdateWidget(FindScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Reset index when widget updates
//     if (_currentCardIndex >= context.read<FindCubit>().findData.length) {
//       setState(() {
//         _currentCardIndex = 0;
//       });
//     }
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
//           if (cubit.isFindDataInitialLoading && cubit.findData.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (state.status == FindStates.failure && cubit.findData.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Failed to load data"),
//                   const SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() => _currentCardIndex = 0);
//                       cubit.loadInitialFindData(context, gender: selectedGender);
//                     },
//                     child: const Text("Retry"),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           if (cubit.findData.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("No people found"),
//                   const SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() => _currentCardIndex = 0);
//                       cubit.loadInitialFindData(context, gender: selectedGender);
//                     },
//                     child: const Text("Reload"),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           // Debug info
//           print("📊 Total people in list: ${cubit.findData.length}");
//           print("📍 Current card index: $_currentCardIndex");
//           print("🎯 Visible people: ${cubit.findData.length - _currentCardIndex}");
//
//           return _buildCardSwiper(context, cubit.findData, cubit);
//         },
//       ),
//     );
//   }
//
//   Widget _buildCardSwiper(BuildContext context, List<FindEntity> people, FindCubit cubit) {
//     print("🎴 Building card swiper - Total: ${people.length}, Current Index: $_currentCardIndex");
//
//     // Safety check: ensure index doesn't exceed list length
//     if (_currentCardIndex >= people.length) {
//       _currentCardIndex = people.length > 0 ? people.length - 1 : 0;
//     }
//
//     // Get only the cards that haven't been swiped yet
//     final visiblePeople = _currentCardIndex < people.length
//         ? people.sublist(_currentCardIndex)
//         : <FindEntity>[];
//
//     print("👀 Visible people count: ${visiblePeople.length}");
//
//     if (visiblePeople.isEmpty) {
//       // Show loading if we're still fetching data
//       if (cubit.isFindDataLoadingMore) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       // Try to load more if we have nothing to show but more data is available
//       if (cubit.hasMoreFindData) {
//         Future.microtask(() => cubit.getFindData(context));
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       // No more data available - show end screen
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.check_circle_outline,
//               size: 80,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "No more results to show",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "You've seen all available profiles",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () {
//                 setState(() => _currentCardIndex = 0);
//               },
//               icon: const Icon(Icons.refresh),
//               label: const Text("Start Over"),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     // Calculate how many cards to display (max 3, or fewer if we don't have enough)
//     final numberOfCards = visiblePeople.length < 3 ? visiblePeople.length : 3;
//
//     // Use a unique key to force rebuild when data changes
//     return SizedBox(
//       key: ValueKey('swiper_${people.length}_$_currentCardIndex'),
//       height: MediaQuery.of(context).size.height * 0.90,
//       child: CardSwiper(
//         controller: _cardController,
//         backCardOffset: const Offset(0, 0),
//         initialIndex: 0,
//         cardsCount: visiblePeople.length,
//         threshold: 30,
//         allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true),
//         numberOfCardsDisplayed: numberOfCards,
//         isLoop: false,
//         padding: const EdgeInsets.only(bottom: 24),
//         maxAngle: 50,
//         onSwipe: (previousIndex, currentIndex, direction) {
//           final actualIndex = _currentCardIndex + previousIndex;
//
//           // Safety check
//           if (actualIndex >= people.length) {
//             print("⚠️ Index out of bounds: $actualIndex >= ${people.length}");
//             return false;
//           }
//
//           final person = people[actualIndex];
//
//           if (direction == CardSwiperDirection.right) {
//             context.read<FindCubit>().addLikeFind(id: person.id!);
//           } else if (direction == CardSwiperDirection.left) {
//             context.read<FindCubit>().addDisLikeFind(id: person.id!);
//           }
//
//           setState(() {
//             _currentCardIndex = actualIndex + 1;
//             _swipeDirection = null;
//           });
//
//           // Load more data when approaching the end
//           final remainingCards = people.length - _currentCardIndex;
//           if (remainingCards <= 5 && cubit.hasMoreFindData && !cubit.isFindDataLoadingMore) {
//             print("🔄 Loading more data... (remaining: $remainingCards)");
//             Future.microtask(() => context.read<FindCubit>().getFindData(context));
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
//           final actualIndex = _currentCardIndex + index;
//           if (actualIndex >= people.length) return const SizedBox.shrink();
//
//           final person = people[actualIndex];
//
//           String? swipeLabel;
//           Color? labelColor;
//
//           if (_swipeDirection != null && index == 0) {
//             if (_swipeDirection == CardSwiperDirection.right) {
//               swipeLabel = 'LIKE';
//               labelColor = Colors.green;
//             } else if (_swipeDirection == CardSwiperDirection.left) {
//               swipeLabel = 'NOPE';
//               labelColor = const Color(0xffEB545D);
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
//                         border: Border.all(color: labelColor!, width: 5),
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
//               _buildActions(context, person, _cardController),
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
//   Widget _buildActions(BuildContext context, FindEntity person, CardSwiperController controller) {
//     return Positioned(
//       bottom: 20,
//       right: 8,
//       left: 8,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildActionButton(
//               icon: Icons.close,
//               color: Colors.red,
//               onPressed: () {
//                 controller.swipe(CardSwiperDirection.left);
//               },
//             ),
//             _buildActionButton(
//               icon: Icons.favorite,
//               color: Colors.pink,
//               onPressed: () {
//                 final cubit = context.read<FindCubit>();
//                 final person = cubit.findData[_currentCardIndex];
//                 cubit.addLoveFind(id: person.id!);
//                 controller.swipe(CardSwiperDirection.right);
//               },
//             ),
//             _buildActionButton(
//               icon: Icons.thumb_up,
//               color: Colors.green,
//               onPressed: () {
//                 controller.swipe(CardSwiperDirection.right);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
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
  final CardSwiperController _cardController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    context.read<FindCubit>().loadInitialFindData(context, gender: selectedGender);
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _switchGender(String gender) {
    setState(() {
      selectedGender = gender;
      _currentCardIndex = 0;
      _swipeDirection = null;
    });
    context.read<FindCubit>().loadInitialFindData(context, gender: gender);
  }

  @override
  void didUpdateWidget(FindScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset index when widget updates
    if (_currentCardIndex >= context.read<FindCubit>().findData.length) {
      setState(() {
        _currentCardIndex = 0;
      });
    }
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

          if (cubit.isFindDataInitialLoading && cubit.findData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FindStates.failure && cubit.findData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Failed to load data"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _currentCardIndex = 0);
                      cubit.loadInitialFindData(context, gender: selectedGender);
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (cubit.findData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No people found"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _currentCardIndex = 0);
                      cubit.loadInitialFindData(context, gender: selectedGender);
                    },
                    child: const Text("Reload"),
                  ),
                ],
              ),
            );
          }

          // Debug info
          print("📊 Total people in list: ${cubit.findData.length}");
          print("📍 Current card index: $_currentCardIndex");
          print("🎯 Visible people: ${cubit.findData.length - _currentCardIndex}");

          return _buildCardSwiper(context, cubit.findData, cubit);
        },
      ),
    );
  }

  Widget _buildCardSwiper(BuildContext context, List<FindEntity> people, FindCubit cubit) {
    print("🎴 Building card swiper - Total: ${people.length}, Current Index: $_currentCardIndex");

    // Safety check: ensure index doesn't exceed list length
    if (_currentCardIndex >= people.length) {
      _currentCardIndex = people.length > 0 ? people.length - 1 : 0;
    }

    // Get only the cards that haven't been swiped yet
    final visiblePeople = _currentCardIndex < people.length
        ? people.sublist(_currentCardIndex)
        : <FindEntity>[];

    print("👀 Visible people count: ${visiblePeople.length}");

    if (visiblePeople.isEmpty && !cubit.isFindDataLoadingMore) {
      // Try to load more if we have nothing to show
      if (cubit.hasMoreFindData) {
        Future.microtask(() => cubit.getFindData(context));
        return const Center(child: CircularProgressIndicator());
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No more people to show"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() => _currentCardIndex = 0);
              },
              child: const Text("Start Over"),
            ),
          ],
        ),
      );
    }

    // Calculate how many cards to display (max 3, or fewer if we don't have enough)
    final numberOfCards = visiblePeople.length < 3 ? visiblePeople.length : 3;

    // Use a unique key to force rebuild when data changes
    return SizedBox(
      key: ValueKey('swiper_${people.length}_$_currentCardIndex'),
      height: MediaQuery.of(context).size.height * 0.90,
      child: CardSwiper(
        controller: _cardController,
        backCardOffset: const Offset(0, 0),
        initialIndex: 0,
        cardsCount: visiblePeople.length,
        threshold: 30,
        allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true),
        numberOfCardsDisplayed: numberOfCards,
        isLoop: false,
        padding: const EdgeInsets.only(bottom: 24),
        maxAngle: 50,
        onSwipe: (previousIndex, currentIndex, direction) {
          final actualIndex = _currentCardIndex + previousIndex;

          // Safety check
          if (actualIndex >= people.length) {
            print("⚠️ Index out of bounds: $actualIndex >= ${people.length}");
            return false;
          }

          final person = people[actualIndex];

          if (direction == CardSwiperDirection.right) {
            context.read<FindCubit>().addLikeFind(id: person.id!);
          } else if (direction == CardSwiperDirection.left) {
            context.read<FindCubit>().addDisLikeFind(id: person.id!);
          }

          setState(() {
            _currentCardIndex = actualIndex + 1;
            _swipeDirection = null;
          });

          // Load more data when approaching the end
          final remainingCards = people.length - _currentCardIndex;
          if (remainingCards <= 5 && cubit.hasMoreFindData && !cubit.isFindDataLoadingMore) {
            print("🔄 Loading more data... (remaining: $remainingCards)");
            Future.microtask(() => context.read<FindCubit>().getFindData(context));
          }

          return true;
        },
        onSwipeDirectionChange: (horizontal, vertical) {
          setState(() {
            _swipeDirection = horizontal;
          });
        },
        cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
          final actualIndex = _currentCardIndex + index;
          if (actualIndex >= people.length) return const SizedBox.shrink();

          final person = people[actualIndex];

          String? swipeLabel;
          Color? labelColor;

          if (_swipeDirection != null && index == 0) {
            if (_swipeDirection == CardSwiperDirection.right) {
              swipeLabel = 'LIKE';
              labelColor = Colors.green;
            } else if (_swipeDirection == CardSwiperDirection.left) {
              swipeLabel = 'NOPE';
              labelColor = const Color(0xffEB545D);
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
                        border: Border.all(color: labelColor!, width: 5),
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
              _buildActions(context, person, _cardController),
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

  Widget _buildActions(BuildContext context, FindEntity person, CardSwiperController controller) {
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
                controller.swipe(CardSwiperDirection.left);
              },
            ),
            _buildActionButton(
              icon: Icons.favorite,
              color: Colors.pink,
              onPressed: () {
                final cubit = context.read<FindCubit>();
                final person = cubit.findData[_currentCardIndex];
                cubit.addLoveFind(id: person.id!);
                controller.swipe(CardSwiperDirection.right);
              },
            ),
            _buildActionButton(
              icon: Icons.thumb_up,
              color: Colors.green,
              onPressed: () {
                controller.swipe(CardSwiperDirection.right);
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



class FindScreen extends StatefulWidget {
  const FindScreen({Key? key}) : super(key: key);

  @override
  State<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  String selectedGender = "male";
  int _currentCardIndex = 0;
  CardSwiperDirection? _swipeDirection;
  final CardSwiperController _cardController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    context.read<FindCubit>().loadInitialFindData(context, gender: selectedGender);
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _switchGender(String gender) {
    setState(() {
      selectedGender = gender;
      _currentCardIndex = 0;
      _swipeDirection = null;
    });
    context.read<FindCubit>().loadInitialFindData(context, gender: gender);
  }
  bool isMaleSelected = true; // Add this to your State class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find People"),
        // actions: [
        //   PopupMenuButton<String>(
        //     onSelected: _switchGender,
        //     itemBuilder: (context) => [
        //       const PopupMenuItem(value: "male", child: Text("Show Male")),
        //       const PopupMenuItem(value: "female", child: Text("Show Female")),
        //     ],
        //     child: Row(
        //       children: [
        //         Text(selectedGender.toUpperCase(),
        //             style: const TextStyle(fontWeight: FontWeight.bold)),
        //         const Icon(Icons.arrow_drop_down),
        //         const SizedBox(width: 8),
        //       ],
        //     ),
        //   ),
        // ],
        actions: [
          Row(
            children: [
              Text(
                isMaleSelected ? 'Male' : 'Female', // or Arabic logic if needed
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isMaleSelected = !isMaleSelected; // toggle gender
                    selectedGender = isMaleSelected ? "male" : "female";

                    // Reload the data in cubit
                    _currentCardIndex = 0;
                    context.read<FindCubit>().loadInitialFindData(
                      context,
                      gender: selectedGender,
                    );
                  });
                },
                icon: Icon(
                  isMaleSelected ? Icons.male : Icons.female,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: BlocBuilder<FindCubit, FindState>(
        builder: (context, state) {
          final cubit = context.read<FindCubit>();

          if (cubit.isFindDataInitialLoading && cubit.findData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FindStates.failure && cubit.findData.isEmpty) {
            return _buildErrorScreen(cubit);
          }

          if (cubit.findData.isEmpty) {
            return _buildNoDataScreen(cubit);
          }

          return _buildCardSwiper(context, cubit.findData, cubit);
        },
      ),
    );
  }

  Widget _buildErrorScreen(FindCubit cubit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Failed to load data"),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() => _currentCardIndex = 0);
              cubit.loadInitialFindData(context, gender: selectedGender);
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataScreen(FindCubit cubit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("No people found"),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() => _currentCardIndex = 0);
              cubit.loadInitialFindData(context, gender: selectedGender);
            },
            child: const Text("Reload"),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMoreResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            "No more results to show",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You've seen all available profiles",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() => _currentCardIndex = 0);
              context.read<FindCubit>().loadInitialFindData(
                context,
                gender: selectedGender,
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Start Over"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSwiper(BuildContext context, List<FindEntity> people, FindCubit cubit) {
    if (_currentCardIndex >= people.length) _currentCardIndex = people.length;

    final visiblePeople = _currentCardIndex < people.length
        ? people.sublist(_currentCardIndex)
        : <FindEntity>[];

    // End of list & no more data
    if (visiblePeople.isEmpty && !cubit.hasMoreFindData) {
      return _buildNoMoreResults();
    }

    // Still loading more
    if (visiblePeople.isEmpty && cubit.isFindDataLoadingMore) {
      return const Center(child: CircularProgressIndicator());
    }

    // Load more data if approaching end
    if (visiblePeople.isEmpty && cubit.hasMoreFindData) {
      Future.microtask(() => cubit.getFindData(context));
      return const Center(child: CircularProgressIndicator());
    }

    final numberOfCards = visiblePeople.length < 3 ? visiblePeople.length : 3;

    return SizedBox(
      key: ValueKey('swiper_${people.length}_$_currentCardIndex'),
      height: MediaQuery.of(context).size.height * 0.90,
      child: CardSwiper(
        controller: _cardController,
        backCardOffset: const Offset(0, 0),
        initialIndex: 0,
        cardsCount: visiblePeople.length,
        threshold: 30,
        allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true),
        numberOfCardsDisplayed: numberOfCards,
        isLoop: false,
        padding: const EdgeInsets.only(bottom: 24),
        maxAngle: 50,
        onSwipe: (previousIndex, currentIndex, direction) {
          final actualIndex = _currentCardIndex + previousIndex;
          if (actualIndex >= people.length) return false;

          final person = people[actualIndex];

          if (direction == CardSwiperDirection.right) {
            cubit.addLikeFind(id: person.id!);
          } else if (direction == CardSwiperDirection.left) {
            cubit.addDisLikeFind(id: person.id!);
          }

          setState(() => _currentCardIndex = actualIndex + 1);

          // Trigger pagination
          final remainingCards = people.length - _currentCardIndex;
          if (remainingCards <= 5 && cubit.hasMoreFindData && !cubit.isFindDataLoadingMore) {
            Future.microtask(() => cubit.getFindData(context));
          }

          return true;
        },
        onSwipeDirectionChange: (horizontal, vertical) {
          setState(() => _swipeDirection = horizontal);
        },
        cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
          final actualIndex = _currentCardIndex + index;
          if (actualIndex >= people.length) return const SizedBox.shrink();

          final person = people[actualIndex];

          String? swipeLabel;
          Color? labelColor;

          if (_swipeDirection != null && index == 0) {
            if (_swipeDirection == CardSwiperDirection.right) {
              swipeLabel = 'LIKE';
              labelColor = Colors.green;
            } else if (_swipeDirection == CardSwiperDirection.left) {
              swipeLabel = 'NOPE';
              labelColor = const Color(0xffEB545D);
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
                        border: Border.all(color: labelColor!, width: 5),
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
              _buildActions(context, person, _cardController),
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

  Widget _buildActions(BuildContext context, FindEntity person, CardSwiperController controller) {
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
              onPressed: () => controller.swipe(CardSwiperDirection.left),
            ),
            _buildActionButton(
              icon: Icons.favorite,
              color: Colors.pink,
              onPressed: () {
                final cubit = context.read<FindCubit>();
                final person = cubit.findData[_currentCardIndex];
                cubit.addLoveFind(id: person.id!);
                controller.swipe(CardSwiperDirection.right);
              },
            ),
            _buildActionButton(
              icon: Icons.thumb_up,
              color: Colors.green,
              onPressed: () => controller.swipe(CardSwiperDirection.right),
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







