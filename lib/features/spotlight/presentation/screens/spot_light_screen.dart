import 'package:flutter/material.dart';


class SpotLightScreen extends StatelessWidget {
  const SpotLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top image section
          Stack(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/placeholder.jpg',
                  image:
                  'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 300,
                color: Colors.black.withOpacity(0.3),
              ),
              SafeArea(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      BackButton(color: Colors.white),
                      Text(
                        'Spotlight',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Example: Essentials Section
                  ProfileInfoSection(
                    title: "Essentials",
                    icon: Icons.badge_outlined,
                    items: const [
                      _InfoRow(
                          icon: Icons.location_on_outlined,
                          text: "10 miles away"),
                      _InfoRow(icon: Icons.straighten, text: "188cm"),
                      _InfoRow(
                          icon: Icons.school_outlined,
                          text: "Cairo University",
                          showDivider: false),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Example: Lifestyle Section
                  ProfileInfoSection(
                    title: "Lifestyle",
                    icon: Icons.favorite_outline,
                    items: const [
                      _InfoRow(
                          icon: Icons.smoking_rooms_outlined,
                          text: "Smoker"),
                      _InfoRow(
                          icon: Icons.fitness_center_outlined,
                          text: "Sometimes"),
                      _InfoRow(
                          icon: Icons.pets_outlined,
                          text: "Cat",
                          showDivider: false),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Example: Basics Section
                  ProfileInfoSection(
                    title: "Basics",
                    icon: Icons.person_outline,
                    items: const [
                      _InfoRow(
                          icon: Icons.chat_bubble_outline,
                          text: "Big time texter"),
                      _InfoRow(
                          icon: Icons.favorite_border,
                          text: "Thoughtful gestures"),
                      _InfoRow(
                          icon: Icons.school_outlined,
                          text: "Bachelors"),
                      _InfoRow(
                          icon: Icons.star_border,
                          text: "Cancer",
                          showDivider: false),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_InfoRow> items;

  const ProfileInfoSection({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: Colors.black87),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                ],
              ),
              const Icon(Icons.more_horiz, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Colors.black26),
          // Info rows
          ...items,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool showDivider;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(height: 1, color: Colors.black26),
          ),
      ],
    );
  }
}
