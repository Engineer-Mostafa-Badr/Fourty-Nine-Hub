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

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';

import '../../../../../res/style/styles.dart';

//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/res/style/const.dart';

import 'package:flutter/material.dart';

import '../cubit/tinder_cubit.dart';

class UserProfilePage extends StatelessWidget {
  final UserData userData;

  const UserProfilePage({required this.userData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TinderViewCubit(),
      child: BlocBuilder<TinderViewCubit, TinderViewState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              heroTag: 'upload image',
              onPressed: () async {
                // Uploading an image and updating state with the uploaded image's media ID
                try {
                  final uploadResult = await UploadFile().uploadImage(
                    subCategoryId: '66af974f8bf69f9469944746',
                    onUploaded: (p0) {
                      context.read<TinderViewCubit>().uploadPictures(
                          pictures: [p0.mediaId],
                          token:
                              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6Ijc3YTcwYzIzLThhZDAtNDNhYS05MWM4LTc2MWM0OTEzNTIzMiIsImlhdCI6MTcyMzE0MTQzNywiZXhwIjo1NTcyMzE0MTQzNywic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.LaBh_XsP910SZoOfl9HsHTNhvR-GwuCzsLDFx83F_aQ');
                      log("${p0.file.path}-----------===========");
                    },
                  );
                  log("Image uploaded successfully:");
                } catch (e) {
                  log("Image upload failed: $e");
                }
              },
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: const Icon(Icons.add_photo_alternate_outlined,
                  color: Colors.white),
            ),
            appBar: AppBar(
              title: const Text('User Profile'),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileHeader(),
                  _buildUserInfo(),
                  _buildStats(),
                  // _buildActivityFeed(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SizedBox(
        //   height: 200,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(100.0),
        //     child: Image.network(
        //        'https://via.placeholder.com/150',
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        SizedBox(
            height: 400,
            // width: MediaQuery.of(context).size.width - 20,
            child: SwipeCardDemo(
              userImages: userData.pictures,
            )),
        const SizedBox(height: 10),

        Text(
          capitalizeAndSplit(
              "${userData.user!.firstName} ${userData.user!.lastName}" ?? ''),
          style: Styles.headerText(color: Colors.black, fontSize: 26),
        ),

        const SizedBox(height: 5),
        Text(
          userData.user!.email ?? 'user.email@example.com',
          style: Styles.headerText(
              color: Colors.black, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.cake,
              color: Colors.redAccent,
            ),
            title: const Text('Date of Birth'),
            subtitle: Text(userData.user!.birthday ?? 'N/A'),
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.deepPurple,
            ),
            title: const Text('Gender'),
            subtitle: Text(userData.user!.gender ?? 'N/A'),
          ),
          // const ListTile(
          //   leading: Icon(Icons.info),
          //   title: Text('Bio'),
          //   subtitle: Text('User bio goes here.'),
          // ),
        ],
      ),
    );
  }



  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
              'Followers', userData.followersCount?.toString() ?? '0'),
          _buildStatItem(
              'Following', userData.followingCount?.toString() ?? '0'),
          _buildStatItem('Friends', userData.friendsCount?.toString() ?? '0'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  // Widget _buildActivityFeed() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 10.0),
  //     padding: const EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10.0),
  //       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Recent Activities',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 10),
  //         // Example of activities, replace with actual data
  //         _buildActivityItem('Liked a post'),
  //         _buildActivityItem('Commented on a picture'),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActivityItem(String activity) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline),
      title: Text(activity),
    );
  }

// Widget _buildFriendsList() {
//   return Container(
//     margin: const EdgeInsets.symmetric(vertical: 10.0),
//     padding: const EdgeInsets.all(16.0),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10.0),
//       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Friends',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         // Example of friends, replace with actual data
//         _buildFriendItem('John Doe'),
//         _buildFriendItem('Jane Smith'),
//       ],
//     ),
//   );
// }

// Widget _buildFriendItem(String friendName) {
//   return ListTile(
//     leading: const CircleAvatar(
//       backgroundImage: NetworkImage('https://via.placeholder.com/150'),
//     ),
//     title: Text(friendName),
//   );
// }
}

class SwipeCardDemo extends StatefulWidget {
  final List<Pictures>? userImages;

  const SwipeCardDemo({super.key, required this.userImages});

  @override
  _SwipeCardDemoState createState() => _SwipeCardDemoState();
}

class _SwipeCardDemoState extends State<SwipeCardDemo> {
  int _currentStoryIndex = 0;

  void _nextStory() {
    setState(() {
      if (_currentStoryIndex < widget.userImages!.length - 1) {
        _currentStoryIndex++;
      } else {
        _currentStoryIndex = widget.userImages!.length - 1;
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
            tag: 'userHero-${widget.userImages?[_currentStoryIndex].sId}',
            // Unique tag for each image

            child: Image.network(
              (widget.userImages!.isNotEmpty)
                  ? widget.userImages![_currentStoryIndex].mediaKey ?? ''
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
              children: List.generate(widget.userImages!.length, (dotIndex) {
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
String capitalize(String name) {
  if (name.isEmpty) return name;
  return name[0].toUpperCase() + name.substring(1).toLowerCase();
}

String capitalizeAndSplit(String name) {
  if (name.isEmpty) return name;
  List<String> parts = name.split(' ');
  parts = parts.take(2).toList(); // Take the first two parts
  parts = parts.map((part) => capitalize(part)).toList();
  return parts.join(' ');
}