import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class TinderView extends StatefulWidget {
  const TinderView({super.key});

  @override
  _TinderViewState createState() => _TinderViewState();
}

class _TinderViewState extends State<TinderView> {
  List<List<String>> userImages = [
    ['assets/user1/image1.jpg', 'assets/user1/image2.jpg'],
    ['assets/user2/image1.jpg', 'assets/user2/image2.jpg'],
    ['assets/user3/image1.jpg', 'assets/user3/image2.jpg'],
    // Add more users and their images as needed
  ];

  Offset _position = Offset.zero;
  late Offset _startDragOffset;
  double _rotation = 0;
  int _currentIndex = 0;
  int _currentStoryIndex = 0;

  void _onPanStart(DragStartDetails details) {
    _startDragOffset = details.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      if (details.globalPosition.dy > _startDragOffset.dy) {
        _position = details.globalPosition - _startDragOffset;
        _rotation = _position.dx /
            500; // Adjust the divisor to control the tilt sensitivity
      } else {
        _position = details.globalPosition - _startDragOffset;
        _rotation = _position.dx /
            -500; // Adjust the divisor to control the tilt sensitivity
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_position.dx > 200 ||
        _position.dx < -200 ||
        _position.dy > 200 ||
        _position.dy < -200) {
      _swipeAway();
    } else {
      setState(() {
        _position = Offset.zero;
        _rotation = 0;
      });
    }
  }

  void _swipeAway() {
    setState(() {
      _position = Offset(_position.dx * 50, _position.dy * 50);
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _currentIndex = (_currentIndex + 1) % userImages.length;
        _currentStoryIndex = 0;
        _position = Offset.zero;
        _rotation = 0;
      });
    });
  }

  void _nextStory() {
    setState(() {
      if (_currentStoryIndex < userImages[_currentIndex].length - 1) {
        _currentStoryIndex++;
      } else {
        _currentStoryIndex = userImages[_currentIndex].length - 1;
      }
    });
  }

  void _previousStory() {
    setState(() {
      if (_currentStoryIndex > 0) {
        _currentStoryIndex--;
      } else {
        _currentStoryIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Label(
                  text: 'Find',
                  style: Styles.headerText(),
                ),
              ),
            ),
            Divider(),
            ...userImages.asMap().entries.map((entry) {
              int index = entry.key;
              List<String> images = entry.value;
              return _buildCard(index, images);
            })
          ],
        ),
      ),
      mainCategoryId: 2,
    );
  }

  Widget _buildCard(int index, List<String> images) {
    bool isFrontCard = index == _currentIndex;

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: isFrontCard
          ? GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              onTapUp: (details) {
                double tapPosition = details.localPosition.dx;
                double screenWidth = MediaQuery.of(context).size.width;

                if (tapPosition < screenWidth / 2) {
                  _previousStory();
                } else {
                  _nextStory();
                }
              },
              child: Transform.translate(
                offset: _position,
                child: Transform.rotate(
                  angle: _rotation,
                  child: _cardWidget(images: images),
                ),
              ),
            )
          : const Offstage(),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FloatingActionButton.small(
          onPressed: null,
          // onPressed: () => cardSwipperController.undo(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.undo_rounded),
        ),
        FloatingActionButton.small(
          // onPressed: () =>
          //     cardSwipperController.swipe(CardSwiperDirection.right),
          onPressed: null,
          backgroundColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
        FloatingActionButton.small(
          onPressed: () {},
          backgroundColor: AppColors.ACCENT_COLOR,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.star_rounded,
            color: Colors.white,
          ),
        ),
        FloatingActionButton.small(
          onPressed: () {},
          backgroundColor: AppColors.PRIMARY_COLOR,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  _cardWidget({required images}) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: kToolbarHeight, horizontal: 8),
      child: Card(
        elevation: 4,
        child: Stack(
          children: [
            Image.asset(images[_currentStoryIndex], fit: BoxFit.cover),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (dotIndex) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: (dotIndex == _currentStoryIndex)
                            ? Colors.white
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
                bottom: kToolbarHeight * .5,
                right: 20,
                left: 20,
                child: _buildActions()),
          ],
        ),
      ),
    );
  }
}
