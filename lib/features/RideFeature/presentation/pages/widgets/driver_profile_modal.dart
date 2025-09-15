import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../domain/driver_rank_enum.dart';
import '../../controllers/cubits/ride_cubit.dart';
import '../../controllers/cubits/ride_states.dart';

class DriverProfileModal extends StatelessWidget {
  const DriverProfileModal({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value: serviceLocator<RideCubit>(),
      child: Builder(
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6, // حجم أول ما يفتح
            minChildSize: 0.4,     // أقل حجم
            maxChildSize: 0.9,    // أقصى حجم
            builder: (context, scrollController) {

              return BlocBuilder<RideCubit, RideState>(
                builder: (context, state) {
                  if(state.driverRatings == null){return Center(child: Text(context.isArabic? "لا يوجد تقييمات": "No Ratings"),);}
                  state.driverRatings?.driverDetailsEntity.currentRank = DriverRank.platinum;
                  state.driverRatings?.driverDetailsEntity.isAccountVerified = true;
                  Color rankColor = (state.driverRatings?.driverDetailsEntity.currentRank.toColor()) ?? Color(0xFFFFD700);

                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
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

                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: rankColor,
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        state.driverRatings?.driverDetailsEntity.pictureUrl ??
                                        "https://i.pravatar.cc/150?img=3",
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.driverRatings?.driverDetailsEntity.isAccountVerified ?? false)
                                Positioned(bottom: 0, right: 0,child: CircleAvatar(radius: 14, backgroundColor: Colors.white, child: Icon(Icons.verified, color: Colors.blue, size: 24,)),)
                              ],
                            ),
                            const SizedBox(height: 10),
                             Text(
                              state.driverRatings?.driverDetailsEntity.firstName ??
                              "Ahmed",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                             Text(
                              context.isArabic? state.driverRatings?.driverDetailsEntity.currentRank.toAr() ?? "ذهبي" : state.driverRatings?.driverDetailsEntity.currentRank.toEn() ?? "Gold",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: rankColor,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // معلومات عامة
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:  [
                                _InfoBox(title: formatNumber(state.driverRatings?.driverDetailsEntity.totalCompletedTrips ?? 0, isArabic: context.isArabic), subtitle: context.isArabic? "رحلات" : "Rides"),
                                _InfoBox(title: formatKM(state.driverRatings?.driverDetailsEntity.totalKM ?? 0, isArabic: context.isArabic), subtitle: context.isArabic? "المسافة الكلية" : "Total Distance"),
                                _InfoBox(title: (state.driverRatings?.driverDetailsEntity.rating ?? 0) == 0? context.isArabic?"لا يوجد تقييمات" : "No Ratings" :  "${formatRating(state.driverRatings?.driverDetailsEntity.rating ?? 0, isArabic: context.isArabic)} ★", subtitle: context.isArabic? "التقييم" :"Rating"),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Text(
                                  formatRegisteredDuration(state.driverRatings?.driverDetailsEntity.registeredAt ?? DateTime.now(), isArabic: context.isArabic),
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: rankColor),
                                ),
                              ],
                            ),
                            // const SizedBox(height: 10),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: const [
                            //     _ComplimentItem(icon: Icons.timer, text: "Arrived quickly", count: 208),
                            //     _ComplimentItem(icon: Icons.directions_car, text: "Nice car", count: 199),
                            //     _ComplimentItem(icon: Icons.cleaning_services, text: "Clean & neat", count: 190),
                            //   ],
                            // ),

                            const SizedBox(height: 20),

                            // Reviews
                             Row(
                               children: [
                                 Text(
                                   context.isArabic? "تقييمات" : "Top reviews",
                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                 ),
                               ],
                             ),
                            const SizedBox(height: 10),
                            (state.driverRatings?.driverRatingEntities == null ||( state.driverRatings?.driverRatingEntities.isEmpty ?? true))?
                              Row(
                                children: [
                                  Text(
                                    context.isArabic? "لا يوجد تقييمات" : "No Reviews",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ):
                            ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.driverRatings?.driverRatingEntities.length ?? 0,
                              itemBuilder: (context, index) {
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              state.driverRatings?.driverRatingEntities[index].clientFirstName ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Row(
                                              children: List.generate(5, (starIndex) {
                                                return Icon(
                                                  starIndex < (state.driverRatings?.driverRatingEntities[index].rating ?? 0)
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

                                        Text(
                                          state.driverRatings?.driverRatingEntities[index].comment ?? ( context.isArabic? "لا يوجد تعليق" : "No Comment"),
                                          style: const TextStyle(fontSize: 13),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          formatTimeAgo((state.driverRatings?.driverRatingEntities[index].createdAt ?? DateTime.now()),  context.isArabic),
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
                }
              );
            },
          );
        }
      ),
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


void showDriverProfileSheet(BuildContext context, {required String driverId}) async {
  await serviceLocator<RideCubit>().getDriverRatings(
    driverId: driverId,
    context: context,
  );
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

String formatNumber(num value, {bool isArabic = false}) {
  String format(num v, String enSuffix, String arSuffix) {
    if (isArabic) {
      // تحويل الأرقام لإنجليزي -> عربي
      final arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
      String str = v.toStringAsFixed(v % 1 == 0 ? 0 : 1);
      str = str.split('').map((ch) {
        if (RegExp(r'[0-9]').hasMatch(ch)) {
          return arabicDigits[int.parse(ch)];
        }
        return ch;
      }).join();
      return "$str $arSuffix";
    } else {
      return "${v.toStringAsFixed(v % 1 == 0 ? 0 : 1)}$enSuffix";
    }
  }

  if (value >= 1e9) {
    return format(value / 1e9, "B", "مليار");
  } else if (value >= 1e6) {
    return format(value / 1e6, "M", "مليون");
  } else if (value >= 1e3) {
    return format(value / 1e3, "K", "ألف");
  } else {
    if (isArabic) {
      final arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
      return value.toString().split('').map((ch) {
        if (RegExp(r'[0-9]').hasMatch(ch)) {
          return arabicDigits[int.parse(ch)];
        }
        return ch;
      }).join();
    } else {
      return value.toString();
    }
  }
}


String formatKM(num value, {bool isArabic = false}) {
  String format(num v, String enSuffix, String arSuffix) {
    if (isArabic) {
      // تحويل الأرقام لإنجليزي -> عربي
      final arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
      String str = v.toStringAsFixed(v % 1 == 0 ? 0 : 1);
      str = str.split('').map((ch) {
        if (RegExp(r'[0-9]').hasMatch(ch)) {
          return arabicDigits[int.parse(ch)];
        }
        return ch;
      }).join();
      return "$str $arSuffix";
    } else {
      return "${v.toStringAsFixed(v % 1 == 0 ? 0 : 1)}$enSuffix";
    }
  }

  if (value >= 1e9) {
    return format(value / 1e9, "B km", " مليار كم");
  } else if (value >= 1e6) {
    return format(value / 1e6, "M km", " مليون كم");
  } else if (value >= 1e3) {
    return format(value / 1e3, "K km", " ألف كم");
  } else {
    if (isArabic) {
      final arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
      return "${value.toString().split('').map((ch) {
        if (RegExp(r'[0-9]').hasMatch(ch)) {
          return arabicDigits[int.parse(ch)];
        }
        return ch;
      }).join()} كم";
    } else {
      return "$value km";
    }
  }
}String formatRating(num rating, {bool isArabic = false}) {
  String convertToArabic(num value) {
    final arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    String str = value.toStringAsFixed(2); // نخليها لحد خانتين
    str = str.replaceAll(RegExp(r'0+$'), ''); // نشيل الأصفار الزيادة
    str = str.replaceAll(RegExp(r'\.$'), ''); // نشيل النقطة لو فاضية
    return str.split('').map((ch) {
      if (RegExp(r'[0-9]').hasMatch(ch)) {
        return arabicDigits[int.parse(ch)];
      }
      if (ch == ".") return "٫"; // النقطة العربية
      return ch;
    }).join();
  }

  if (isArabic) {
    return convertToArabic(rating);
  } else {
    return rating.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}

String formatRegisteredDuration(DateTime registeredAt, {required bool isArabic}) {
  final now = DateTime.now();
  final diff = now.difference(registeredAt);

  final years = diff.inDays ~/ 365;
  final months = (diff.inDays % 365) ~/ 30;
  final days = (diff.inDays % 365) % 30;

  String duration;
  if (years > 0) {
    duration = isArabic ? "$years سنة" : "$years year${years > 1 ? 's' : ''}";
  } else if (months > 0) {
    duration = isArabic ? "$months شهر" : "$months month${months > 1 ? 's' : ''}";
  } else if (days > 0) {
    duration = isArabic ? "$days يوم" : "$days day${days > 1 ? 's' : ''}";
  } else {
    duration = isArabic ? "اليوم" : "today";
  }

  return isArabic
      ? "مسجل منذ $duration في 49Hub"
      : "Registered for $duration in 49Hub";
}


String formatTimeAgo(DateTime createdAt, bool isArabic) {
  final now = DateTime.now();
  final diff = now.difference(createdAt);

  if (diff.inSeconds < 60) {
    return isArabic ? "منذ لحظات" : "just now";
  } else if (diff.inMinutes < 60) {
    final m = diff.inMinutes;
    return isArabic
        ? "منذ $m دقيقة"
        : "$m minute${m > 1 ? 's' : ''} ago";
  } else if (diff.inHours < 24) {
    final h = diff.inHours;
    return isArabic
        ? "منذ $h ساعة"
        : "$h hour${h > 1 ? 's' : ''} ago";
  } else if (diff.inDays < 7) {
    final d = diff.inDays;
    return isArabic
        ? "منذ $d يوم"
        : "$d day${d > 1 ? 's' : ''} ago";
  } else if (diff.inDays < 30) {
    final w = diff.inDays ~/ 7;
    return isArabic
        ? "منذ $w أسبوع"
        : "$w week${w > 1 ? 's' : ''} ago";
  } else if (diff.inDays < 365) {
    final m = diff.inDays ~/ 30;
    return isArabic
        ? "منذ $m شهر"
        : "$m month${m > 1 ? 's' : ''} ago";
  } else {
    final y = diff.inDays ~/ 365;
    return isArabic
        ? "منذ $y سنة"
        : "$y year${y > 1 ? 's' : ''} ago";
  }
}
