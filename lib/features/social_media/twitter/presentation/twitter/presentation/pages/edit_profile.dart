import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../res/assets/assets.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'save',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),

            // Editable Profile Fields
            buildProfileField('Name', 'Mohamed Ahmed', isBold: true),
            buildProfileField('Bio', 'Mohamed Ahmed'),
            buildProfileField('Location', 'Cairo', isBold: true),
            buildProfileField('Website', '', isBold: false),
            buildProfileField('Birth date', 'March 20, 2000', isBold: true),

            // Birth date privacy info
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Month and day: Only you\nYear: Only you',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build profile fields
  Widget buildProfileField(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Color
          Container(
            height: MediaQuery.of(context).size.height * 0.18,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF2F2FAA), // Deep blue background
            ),
            child: Center(
              child: SizedBox(
                height: 40,
                child: SvgPicture.asset(
                  Assets.cameraIcon,
                  color: Colors.white,),
              )
            ),
          ),

          // Profile Image with Camera Icon (Left Positioned)
          Positioned(
            left: 16,
            top: MediaQuery.of(context).size.height * 0.13,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.white, width: 2),
                color: Color(0xFF7A1A57),
              ),

              // Deep purple background

              child: Icon(
                Icons.camera_enhance_outlined,size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
