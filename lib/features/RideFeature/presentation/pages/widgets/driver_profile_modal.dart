import 'package:flutter/material.dart';

import '../../../../../res/style/app_colors.dart';

class DriverProfileModal extends StatelessWidget {
  const DriverProfileModal({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      Review(userName: "أحمد نصر", stars: 5, comment: "محترم جدا", date: "منذ شهر"),
      Review(userName: "محمد", stars: 4, comment: "رحلة ممتازة لكن محتاج تحسين بسيط", date: "منذ أسبوع"),
      Review(userName: "سارة", stars: 5, comment: "سواق رائع وملتزم بالمواعيد", date: "منذ يومين"),
    ];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6, // حجم أول ما يفتح
      minChildSize: 0.4,     // أقل حجم
      maxChildSize: 0.95,    // أقصى حجم
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController, // مهم علشان السكروول يشتغل
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Drag Handle
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // صورة البروفايل + الاسم
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              "https://i.pravatar.cc/150?img=3",
                            ),
                          ),
                        ),
                      ),
                      Positioned(bottom: 0, right: 0,child: Icon(Icons.verified, color: Colors.blue, size: 24,),)
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Ahmed",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Platinum status is awarded to our most experienced drivers",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // معلومات عامة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _InfoBox(title: "3 424", subtitle: "rides"),
                      _InfoBox(title: "3 years", subtitle: "with 49Hub"),
                      _InfoBox(title: "4.89 ★", subtitle: "rating"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Compliments
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Compliments",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _ComplimentItem(icon: Icons.timer, text: "Arrived quickly", count: 208),
                      _ComplimentItem(icon: Icons.directions_car, text: "Nice car", count: 199),
                      _ComplimentItem(icon: Icons.cleaning_services, text: "Clean & neat", count: 190),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Reviews
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Top reviews",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // اسم اليوزر + عدد النجوم
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex < review.stars
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.orange,
                                        size: 18,
                                      );
                                    }),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // الكومنت
                              Text(
                                review.comment,
                                style: const TextStyle(fontSize: 13),
                              ),

                              const SizedBox(height: 4),

                              // التاريخ
                              Text(
                                review.date,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoBox({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _ComplimentItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final int count;

  const _ComplimentItem({required this.icon, required this.text, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.PRIMARY_COLOR_DARK),
        Text("$count", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}


void showDriverProfileSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const DriverProfileModal(),
  );
}


class Review {
  final String userName;
  final int stars; // عدد النجوم
  final String comment;
  final String date;

  Review({
    required this.userName,
    required this.stars,
    required this.comment,
    required this.date,
  });
}