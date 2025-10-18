import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/widget/clickable_widget.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entity/find_entity.dart';
import '../cubit/find_cubit.dart'; // your cubit

import '../cubit/find_state.dart';




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
  bool _showLoveAnimation = false;
  bool isLoggedIn = false;
  String userId = "";

  void _triggerLoveAnimation() {
    setState(() => _showLoveAnimation = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showLoveAnimation = false);
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //
  //   // final userState = context.read<UserCubit>().state;
  //   // final user = userState.data;
  //   // isLoggedIn = !(user?.isGuest ?? true);
  //   // userId = isLoggedIn ? user!.id : "";
  //
  //   final userState = context.read<UserCubit>().state;
  //   final user = userState.data;
  //   isLoggedIn = !(user?.isGuest ?? true);
  //   userId = isLoggedIn ? user!.id : "";
  //   final String gender = isLoggedIn ? (user?.gender ?? "male") : selectedGender;
  //
  //   context.read<FindCubit>().loadInitialFindData(
  //     context,
  //     gender: gender,
  //     userId: userId,
  //     isLoggedIn: isLoggedIn,
  //   );
  // }
  @override
  void initState() {
    super.initState();

    final userState = context.read<UserCubit>().state;
    final user = userState.data;
    isLoggedIn = !(user?.isGuest ?? true);
    userId = isLoggedIn ? user!.id : "";
    print("User Name ${user?.firstName ?? ""}");
    print("User is logged? ${isLoggedIn}");
    print("User Id ${userId}");

    // ✅ Determine the opposite gender
    String oppositeGender;
    if (isLoggedIn) {
      final userGender = user?.gender?.toLowerCase() ?? "male";
      oppositeGender = userGender == "male" ? "female" : "male";
    } else {
      oppositeGender = selectedGender;
    }

    // ✅ Load opposite gender profiles
    context.read<FindCubit>().loadInitialFindData(
      context,
      gender: oppositeGender,
      userId: userId,
      isLoggedIn: isLoggedIn,
    );
  }



  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }
  bool isMaleSelected = true; // Add this to your State class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: AppBar(
          leadingWidth: 200.w,
          leading: Row(
            children: [
              IconButton(
                  visualDensity:
                  const VisualDensity(horizontal: -2, vertical: -4),
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back)),
              // const Sizer(),
              Text(
                LocaleKeys.searchFind.localize,
                style: Styles.headerText(),
              ),
            ],
          ),
          title: ClickableWidget(
              onTap: () => context.push(Routes.FindMyProfileScreen),
              child: Image.asset(
                Assets.male_profile,
                width: 70.w,
              )),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                ManageVibration.vibrate();

                setState(() {
                  isMaleSelected = !isMaleSelected!;
                  _currentCardIndex = 0;

                  // ✅ Update the selected gender string
                  selectedGender = isMaleSelected! ? "male" : "female";

                  // ✅ Access the user info from UserCubit
                  final userState = context.read<UserCubit>().state;
                  final user = userState.data;
                  final bool isLoggedIn = !(user?.isGuest ?? true);
                  final String userId = isLoggedIn ? user!.id : "";

                  // ✅ Reload data with the new gender and user info
                  context.read<FindCubit>().loadInitialFindData(
                    context,
                    gender: selectedGender,
                    userId: userId,
                    isLoggedIn: isLoggedIn,
                  );
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isMaleSelected!
                        ? (context.isArabic ? "ذكر" : "Male")
                        : (context.isArabic ? "أنثى" : "Female"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.isDarkMode
                          ? AppColors.whiteColor
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isMaleSelected!
                        ? FontAwesomeIcons.person
                        : FontAwesomeIcons.personDress,
                    color: context.isDarkMode ? Colors.white : Colors.red,
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          BlocListener<FindCubit, FindState>(
            listenWhen: (previous, current) =>
            previous.addedLove != current.addedLove && current.addedLove == true,
            listener: (context, state) {
              _triggerLoveAnimation();
            },
            child: BlocBuilder<FindCubit, FindState>(
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
          ),

          // ❤️ Lottie overlay
          AnimatedOpacity(
            opacity: _showLoveAnimation ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _showLoveAnimation
                ? Lottie.asset(
              Assets.love,
              width: 200,
              height: 200,
              repeat: false,
            )
                : const SizedBox.shrink(),
          ),
        ],
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
              // cubit.loadInitialFindData(context, gender: selectedGender);
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
              // cubit.loadInitialFindData(context, gender: selectedGender);
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
              // context.read<FindCubit>().loadInitialFindData(
              //   context,
              //   gender: selectedGender,
              // );
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

    // ✅ Automatically reload when list is empty and no more data
    if (visiblePeople.isEmpty && !cubit.hasMoreFindData) {
      print("Loooooooooooooooooaded");
      Future.microtask(() {
        final cubit = context.read<FindCubit>();

        // Prevent multiple reloads
        if (!cubit.isFindDataInitialLoading) {
          setState(() => _currentCardIndex = 0);

          // ✅ Get user info from UserCubit
          final userState = context.read<UserCubit>().state;
          final user = userState.data;
          final bool isLoggedIn = !(user?.isGuest ?? true);
          final String userId = isLoggedIn ? user!.id : "";
          final String gender = isLoggedIn
              ? (user?.gender ?? selectedGender)
              : selectedGender;

          // ✅ Load initial find data with user context
          cubit.loadInitialFindData(
            context,
            gender: gender,
            userId: userId,
            isLoggedIn: isLoggedIn,
          );
        }
      });

      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
            if (isLoggedIn && person.id != null) {
              cubit.addLikeFind(id: person.id!);
            } else {
              debugPrint("⚠️ Cannot add like: user is logged out or person.id is null (${person.id})");
            }
          }
          else if (direction == CardSwiperDirection.left) {
            if(isLoggedIn)
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: MediaQuery.of(context).size.height * 0.83,
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 8,
        child: PersonCardContent(person: person),
      ),
    );
  }

  Widget _buildActions(BuildContext context, FindEntity person, CardSwiperController controller) {
     return Positioned(
      bottom: 8,
      right: 8,
      left: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0.h, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionButton(
              context,
              Image.asset(Assets.unavailable), () {},
              // !context.read<UserCubit>().isLoggedIn
              //     ? () => context.push(Routes.LOGIN)
              //     : () => context.push(Routes.OTHERSACCOUNT, extra: cardUser.id),
              color: AppColors.PRIMARY_COLOR, isMini: true,
            ),
            _buildActionButton(
              context, Image.asset(Assets.tinder_gift), () {},
              // !context.read<UserCubit>().isLoggedIn
              //     ? () => context.push(Routes.LOGIN)
              //     :  () => showChatBottomSheet(context, cardUser),
              color: Colors.white,
            ),
            _buildActionButton(
              context,
              Image.asset(Assets.green_heart), () {
                if(person.id != null) {
                  context.read<FindCubit>().addLoveFind(id: person.id!);
                }else{
                  print("id null");
                }
            },
              // !context.read<UserCubit>().isLoggedIn
              //     ? () => context.push(Routes.LOGIN)
              //     :  () => _navigateToUserProfile(context, cardUser),
              color: Colors.red, isMini: true,
            ),
            _buildActionButton(
              context,
              Image.asset(Assets.tinder_comments), () {},
              // !context.read<UserCubit>().isLoggedIn
              //     ? () => context.push(Routes.LOGIN)
              //     :  () => showGiftBottomSheet(context, receiverId: cardUser.id),
              color: AppColors.ACCENT_COLOR,
            ),
            _buildActionButton(context, Image.asset(Assets.tinder_account),
                    () => context.push(Routes.UserProfilePage),
                hasStory: person.hasStory ?? false,
                color: Colors.red,
                isMini: true,

            ),
          ],
        ),
      ),
    );

  }
  Widget _buildActionButton(
      BuildContext context,
      Widget child,
      VoidCallback onPressed, {
        Color? color,
        bool? isMini,
        bool hasStory = false,
      }) {
    final double outerSize = (isMini ?? false) ? 52 : 70; // total ring size
    final double innerSize = outerSize - 6; // white inner circle

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: outerSize,
        height: outerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: hasStory
              ? const LinearGradient(
            colors: [Colors.red, Colors.orange, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: hasStory ? null : Colors.white, // white if no story
        ),
        padding: const EdgeInsets.all(3), // border thickness
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(isMini == null ? 16.0.h : 8.h),
              child: child,
            ),
          ),
        ),
      ),
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

  late final List<String> _images;

  @override
  void initState() {
    super.initState();
    // Use real pictures if available, otherwise fallback to dummy images
    _images = (widget.person.pictures != null && widget.person.pictures!.isNotEmpty)
        ? widget.person.pictures!
        : [
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
    final tappedLeftSide = localPosition.dx < screenWidth / 2;
    if (tappedLeftSide) {
      _previousImage();
    } else {
      _nextImage();
    }
  }

  // Get info text depending on the current image
  Map<String, String> _getImageInfo(int index) {
    switch (index) {
      case 0:
        return {
          'title': "${widget.person.firstName ?? ''} ${widget.person.lastName ?? ''}",
          'subtitle': '',
        };
      case 1:
        return {
          'title': "Followers",
          'subtitle': "${widget.person.followersCount ?? 0}",
        };
      case 2:
        return {
          'title': "Following",
          'subtitle': "${widget.person.followingCount ?? 0}",
        };
      case 3:
        return {
          'title': "Friends",
          'subtitle': "${widget.person.friendsCount ?? 0}",
        };
      default:
        return {
          'title': '',
          'subtitle': '',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final info = _getImageInfo(_currentImageIndex);

    return GestureDetector(
      onTapUp: (details) => _handleTap(details.localPosition, screenWidth),
      child: Stack(
        children: [
          // Main image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              _images[_currentImageIndex],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 100, color: Colors.grey),
              ),
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

          // Info for each image
          Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (info['title']!.isNotEmpty)
                  Text(
                    info['title']!,
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
                if (info['subtitle']!.isNotEmpty)
                  const SizedBox(height: 8),
                if (info['subtitle']!.isNotEmpty)
                  Text(
                    info['subtitle']!,
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






