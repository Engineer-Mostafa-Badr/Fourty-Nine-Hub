// import 'package:flutter/material.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/const.dart';

// class UserProfilePage extends StatelessWidget {
//   final UserData userData;

//   UserProfilePage({required this.userData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildProfileHeader(),
//             _buildUserInfo(),
//             _buildActivityFeed(),
//             _buildFriendsList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           SizedBox(
//               height: 400,
//               // width: MediaQuery.of(context).size.width - 20,
//               child: SwipeCardDemo(
//                 userImages: userData.pictures,
//               )),
//           const SizedBox(height: 10),
//           Text(
//             userData.users.isNotEmpty
//                 ? '${userData.users[0].firstName} ${userData.users[0].lastName}'
//                 : 'User Name',
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 5),
//           Text(userData.users.isNotEmpty
//               ? userData.users[0].email
//               : 'user.email@example.com'),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserInfo() {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           ListTile(
//             leading: const Icon(Icons.phone),
//             title: const Text('Phone Number'),
//             subtitle:
//                 Text(userData.users.isNotEmpty ? userData.users[0].id : 'N/A'),
//           ),
//           const ListTile(
//             leading: Icon(Icons.location_city),
//             title: Text('Address'),
//             subtitle: Text('123 Street, City, Country'), // Adjust as needed
//           ),
//           ListTile(
//             leading: const Icon(Icons.cake),
//             title: const Text('Date of Birth'),
//             subtitle: Text(
//                 userData.users.isNotEmpty && userData.users[0].birthday != null
//                     ? userData.users[0].birthday.toString()
//                     : 'N/A'),
//           ),
//           const ListTile(
//             leading: Icon(Icons.info),
//             title: Text('Bio'),
//             subtitle: Text('User bio goes here.'), // Adjust as needed
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActivityFeed() {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Recent Activities',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           ...userData.likes
//               .map((like) =>
//                   _buildActivityItem(like.firstName + ' liked a post'))
//               .toList(),
//         ],
//       ),
//     );
//   }

//   Widget _buildActivityItem(String activity) {
//     return ListTile(
//       leading: const Icon(Icons.check_circle_outline),
//       title: Text(activity),
//     );
//   }

//   Widget _buildFriendsList() {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Friends',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           ...userData.friends.map((friend) =>
//               _buildFriendItem('${friend.firstName} ${friend.lastName}')),
//         ],
//       ),
//     );
//   }

//   Widget _buildFriendItem(String friendName) {
//     return ListTile(
//       leading: const CircleAvatar(
//         backgroundImage: NetworkImage(
//             'https://via.placeholder.com/150'), // Placeholder image
//       ),
//       title: Text(friendName),
//     );
//   }
// }

// class SwipeCardDemo extends StatefulWidget {
//   List<Picture> userImages;

//   SwipeCardDemo({super.key, required this.userImages});

//   @override
//   _SwipeCardDemoState createState() => _SwipeCardDemoState();
// }

// class _SwipeCardDemoState extends State<SwipeCardDemo> {
//   int _currentStoryIndex = 0;

//   void _nextStory() {
//     setState(() {
//       if (_currentStoryIndex < widget.userImages.length - 1) {
//         _currentStoryIndex++;
//       } else {
//         _currentStoryIndex = widget.userImages.length - 1;
//       }
//     });
//   }

//   void _previousStory() {
//     setState(() {
//       if (_currentStoryIndex > 0) {
//         _currentStoryIndex--;
//       } else {
//         _currentStoryIndex = 0;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildCard();
//   }

//   Widget _buildCard() {
//     return Positioned(
//       left: 0,
//       right: 0,
//       top: 0,
//       bottom: 0,
//       child: GestureDetector(
//         onTapUp: (details) {
//           setState(() {
//             double tapPosition = details.localPosition.dx;
//             double screenWidth = MediaQuery.of(context).size.width;

//             if (tapPosition < screenWidth / 2) {
//               _previousStory();
//             } else {
//               _nextStory();
//             }
//           });
//         },
//         child: _cardWidget(),
//       ),
//     );
//   }

//   Widget _buildActions() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         FloatingActionButton.small(
//           onPressed: null,
//           // onPressed: () => cardSwipperController.undo(),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//           child: const Icon(Icons.undo_rounded),
//         ),
//         FloatingActionButton.small(
//           // onPressed: () =>
//           //     cardSwipperController.swipe(CardSwiperDirection.right),
//           onPressed: null,
//           backgroundColor: Colors.red,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//           child: const Icon(
//             Icons.clear,
//             color: Colors.white,
//           ),
//         ),
//         FloatingActionButton.small(
//           onPressed: () {},
//           backgroundColor: AppColors.ACCENT_COLOR,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//           child: const Icon(
//             Icons.star_rounded,
//             color: Colors.white,
//           ),
//         ),
//         FloatingActionButton.small(
//           onPressed: () {},
//           backgroundColor: AppColors.PRIMARY_COLOR,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//           child: const Icon(
//             Icons.chat,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }

//   _cardWidget() {
//     return Card(
//       clipBehavior: Clip.hardEdge,
//       elevation: 4,
//       child: Stack(
//         children: [
//           Hero(
//             tag: 'userHero-${555}', // Ensure each hero tag is unique

//             child: Image.network(
//               (widget.userImages.isNotEmpty)
//                   ? widget.userImages[_currentStoryIndex].mediaKey
//                   : UIConst.profilePlaceHolder,
//               errorBuilder: (context, error, stackTrace) => Image.network(
//                 UIConst.profilePlaceHolder,
//                 fit: BoxFit.fitHeight,
//                 height: double.infinity,
//               ),
//               fit: BoxFit.fitHeight,
//               height: double.infinity,
//             ),
//           ),
//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(widget.userImages.length, (dotIndex) {
//                 return Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 2.0),
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: (dotIndex == _currentStoryIndex)
//                           ? Colors.red
//                           : Colors.white54,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';

class UserProfilePage extends StatelessWidget {
  final UserData userData;

  const UserProfilePage({required this.userData});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildUserInfo(),
            _buildActivityFeed(),
            _buildFriendsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 400,
            child: SwipeCardDemo(
              userImages: userData.pictures,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            userData.users.isNotEmpty
                ? '${userData.users[0].firstName} ${userData.users[0].lastName}'
                : 'User Name',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(userData.users.isNotEmpty
              ? userData.users[0].email
              : 'user.email@example.com'),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone Number'),
            subtitle:
                Text(userData.users.isNotEmpty ? userData.users[0].id : 'N/A'),
          ),
          const ListTile(
            leading: Icon(Icons.location_city),
            title: Text('Address'),
            subtitle: Text('123 Street, City, Country'), // Adjust as needed
          ),
          ListTile(
            leading: const Icon(Icons.cake),
            title: const Text('Date of Birth'),
            subtitle: Text(
                userData.users.isNotEmpty && userData.users[0].birthday != null
                    ? userData.users[0].birthday.toString()
                    : 'N/A'),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Bio'),
            subtitle: Text('User bio goes here.'), // Adjust as needed
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeed() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...userData.likes
              .map((like) =>
                  _buildActivityItem(like.firstName + ' liked a post'))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline),
      title: Text(activity),
    );
  }

  Widget _buildFriendsList() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Friends',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...userData.friends.map((friend) =>
              _buildFriendItem('${friend.firstName} ${friend.lastName}')),
        ],
      ),
    );
  }

  Widget _buildFriendItem(String friendName) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: NetworkImage(
            'https://via.placeholder.com/150'), // Placeholder image
      ),
      title: Text(friendName),
    );
  }
}

class SwipeCardDemo extends StatefulWidget {
  final List<Picture> userImages;

  const SwipeCardDemo({super.key, required this.userImages});

  @override
  _SwipeCardDemoState createState() => _SwipeCardDemoState();
}

class _SwipeCardDemoState extends State<SwipeCardDemo> {
  int _currentStoryIndex = 0;

  void _nextStory() {
    setState(() {
      if (_currentStoryIndex < widget.userImages.length - 1) {
        _currentStoryIndex++;
      } else {
        _currentStoryIndex = widget.userImages.length - 1;
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
    return _buildCard();
  }

  Widget _buildCard() {
    return GestureDetector(
      onTapUp: (details) {
        setState(() {
          double tapPosition = details.localPosition.dx;
          double screenWidth = MediaQuery.of(context).size.width;

          if (tapPosition < screenWidth / 2) {
            _previousStory();
          } else {
            _nextStory();
          }
        });
      },
      child: _cardWidget(),
    );
  }

  Widget _cardWidget() {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      child: Stack(
        children: [
          Hero(
            tag:
                'userHero-${widget.userImages[_currentStoryIndex].id}', // Unique tag for each image

            child: Image.network(
              (widget.userImages.isNotEmpty)
                  ? widget.userImages[_currentStoryIndex].mediaKey
                  : UIConst.profilePlaceHolder,
              errorBuilder: (context, error, stackTrace) => Image.network(
                UIConst.profilePlaceHolder,
                fit: BoxFit.fitHeight,
                height: double.infinity,
              ),
              fit: BoxFit.fitHeight,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.userImages.length, (dotIndex) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    height: 4,
                    decoration: BoxDecoration(
                      color: (dotIndex == _currentStoryIndex)
                          ? Colors.red
                          : Colors.white54,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
