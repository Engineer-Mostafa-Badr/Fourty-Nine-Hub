import 'package:flutter/material.dart';
import '../../../../../core/widget/custom_floating_action_button.dart';
import '../../../../../helpers/manage_vibration.dart';

class TestScreen1 extends StatelessWidget {
  const TestScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1432),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {

      ManageVibration.vibrate();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: LeftDiagonalClipper(),
              child: Container(
                color: const Color(0xFF0C1432),
              ),
            ),
          ),
          // Positioned.fill(
          //   child: Transform(
          //     alignment: Alignment.topLeft,  // Ensures the skew effect starts from the left
          //     transform: Matrix4.skewY(-1.02), // Skews the container diagonally
          //     child: Container(
          //       width: double.infinity,
          //       height: 200, // Adjust as needed
          //       color: const Color(0xFF0C1432),
          //     ),
          //   ),
          // ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTopButton("Captain Share", Icons.directions_car, Colors.red),
                    _buildTopButton("Trip Join", Icons.directions_car_filled, Colors.grey),
                    _buildTopButton("Pick me", Icons.local_parking, Colors.blue),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      const BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "One Way - One Captain!",
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTabButton("Available Trips"),
                          _buildTabButton("My Bookings"),
                          _buildTabButton("Running Trips"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "There are no trips available now.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {

      ManageVibration.vibrate();
        },
        text: '+ Create new route!',
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: const Color(0xFF0C1432),
      //   onPressed: () {},
      //   label: const Text("+ Create new route!"),
      // ),
    );
  }

  Widget _buildTopButton(String title, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTabButton(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Text(title, style: const TextStyle(fontSize: 12)),
    );
  }
}

// Custom Clipper to create a diagonal left-side background
class LeftDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height); // Start at bottom-left
    path.lineTo(size.width, size.height * 0.3); // Diagonal to top-right
    path.lineTo(size.width, 0); // Top-right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}