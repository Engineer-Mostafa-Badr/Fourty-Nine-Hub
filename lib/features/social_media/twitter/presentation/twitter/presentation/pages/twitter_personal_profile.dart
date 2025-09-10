import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../res/assets/assets.dart';
import 'edit_profile.dart';

class TwitterPersonalProfile extends StatelessWidget {
  final bool isPersonal;

  TwitterPersonalProfile({super.key, required this.isPersonal});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildUserInfo(context),

                !isPersonal ? UserInfoWidget() : Container(),
                _buildPostsSection(),
                _buildPostItem(),
                Divider(),
                _buildPostItem(),
                Divider(),
                _buildPostItem(),
                _buildWhoToFollowSection(),
              ],
            ),
          ),
        ),
        PositionedDirectional(
          bottom: 10,
          end: 10,
          child: CustomElevatedButton(
            onPressed: () {
              if (context.read<UserCubit>().isLoggedIn) {
                context.push(Routes.CREATEPOST, extra: 'twitter');
              } else {
                context.push(Routes.LOGIN);
              }
            },
            child: Text(
              LocaleKeys.createPost.localize,
              style: Styles.smallText(color: AppColors.whiteColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://plus.unsplash.com/premium_photo-1688429242108-7e6868fd9602?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
              // Background image
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: MediaQuery.of(context).size.height * 0.18,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage("https://images.unsplash.com/photo-1526779259212-939e64788e3c?q=80&w=1174&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
            backgroundColor: Colors.white70, // Profile image
          ),
        ),
        Positioned(
          left: 16,
          top: 45,
          child: CircleAvatar(
            radius: 20,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                )),
            backgroundColor: Colors.black, // Profile image
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Hossam Ahmed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.verified, color: Colors.blue, size: 16),
              Spacer(),
              isPersonal ?    OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                child: const Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                ),
              ) : CustomFollowRow(),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '@Hossamalbadrawi87',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.calendar_month, color: Colors.grey, size: 16),
              const SizedBox(width: 4),
              const Text(
                'Joined April 2024',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostsSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Posts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage("https://plus.unsplash.com/premium_photo-1683910767532-3a25b821f7ae?q=80&w=808&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Elon Musk',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Colors.blue, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      '@elonmusk · May 29',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam non velit tempor, convallis ipsum ut, eleifend est. Cras faucibus pharetra ante.',
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _buildReactionItem(Icons.comment, '13.1k'),
                    _buildReactionItem(Icons.repeat, '11.2k'),
                    _buildReactionItem(Icons.favorite, '36.3k'),
                    _buildReactionItem(Icons.share, '97.4k'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 16),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildWhoToFollowSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Who to follow',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Show more',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
          SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) => _buildFollowCard(),
              )),
        ],
      ),
    );
  }

  Widget _buildFollowCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Background Image
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    "https://plus.unsplash.com/premium_photo-1683910767532-3a25b821f7ae?q=80&w=808&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    // Replace with actual background image
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Name and Handle
                      Column(
                        children: [
                          const Text(
                            'Elon Musk',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            '@elonmusk',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const Text(
                            'Welcome To X',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      Spacer(),
                      // Follow Button
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text('Follow'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 10,
              top: 60,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://plus.unsplash.com/premium_photo-1688429242441-1111481ce50a?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"), // Replace with actual profile image
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Followers and Following Row
          const Row(

            children: [
              Text(
                '125 ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                ' Following',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '125 ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Followers',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Profile pictures and follower names
          Row(
            children: [
              SizedBox(
                height: 32,
                width: 32,
                child: Stack(
                  clipBehavior: Clip.none, // Allow overflow for stacking effect
                  children: [
                    Positioned(
                      left: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage("https://plus.unsplash.com/premium_photo-1688429242441-1111481ce50a?q=80&w=1169&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                      ),
                    ),
                    Positioned(
                      left: 20, // Adjust for overlap
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage("https://plus.unsplash.com/premium_photo-1688429242108-7e6868fd9602?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                      ),
                    ),
                    Positioned(
                      left: 40, // Adjust for overlap
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage("https://plus.unsplash.com/premium_photo-1688429242108-7e6868fd9602?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: Text(
                  'Followed by mohamed ahmed, mhmaed ahmed, taha ahmed, and 56 others',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          )


        ],
      ),

    );
  }
}
class CustomFollowRow extends StatelessWidget {
  const CustomFollowRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular Button with Gradient Border
        Container(
          padding: const EdgeInsets.all(1.5), // Border padding
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.black,
                Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CircleAvatar(
            radius: 20, // Adjust size
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active_outlined, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(width: 5),

        // "Following" Button with Gradient Border
        Container(
          padding: const EdgeInsets.all(.7), // Border padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500),
            gradient: const LinearGradient(
              colors: [Colors.black,
                Colors.red],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: Colors.transparent, width: 0),
          ),
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              side: const BorderSide(color: Colors.transparent, width: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Smooth round corners
              ),
            ),
            child: const Text(
              'Following',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}