import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
/*
class SpotLightScreen extends StatelessWidget {
  const SpotLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Enhanced top image section with gradient overlay
          Stack(
            children: [
              Hero(
                tag: 'profile_image',
                child: SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/placeholder.jpg',
                    image: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Gradient overlay for better text readability
              Container(
                height: 320,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Enhanced back button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      // Title with shadow for better visibility
                      Text(
                        'Spotlight',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      // More options button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white, size: 22),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Enhanced scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Essentials Section with enhanced styling
                  ProfileInfoSection(
                    title: "Essentials",
                    icon: Icons.badge_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                    ),
                    items: const [
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        text: "10 miles away",
                        subtitle: "Current location",
                      ),
                      _InfoRow(
                        icon: Icons.straighten,
                        text: "188cm",
                        subtitle: "Height",
                      ),
                      _InfoRow(
                        icon: Icons.school_outlined,
                        text: "Cairo University",
                        subtitle: "Education",
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Lifestyle Section
                  ProfileInfoSection(
                    title: "Lifestyle",
                    icon: Icons.favorite_outline,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4E54C8), Color(0xFF8F94FB)],
                    ),
                    items: const [
                      _InfoRow(
                        icon: Icons.smoking_rooms_outlined,
                        text: "Smoker",
                        subtitle: "Smoking habits",
                      ),
                      _InfoRow(
                        icon: Icons.fitness_center_outlined,
                        text: "Sometimes",
                        subtitle: "Workout frequency",
                      ),
                      _InfoRow(
                        icon: Icons.pets_outlined,
                        text: "Cat",
                        subtitle: "Pet preference",
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Basics Section
                  ProfileInfoSection(
                    title: "Basics",
                    icon: Icons.person_outline,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                    ),
                    items: const [
                      _InfoRow(
                        icon: Icons.chat_bubble_outline,
                        text: "Big time texter",
                        subtitle: "Communication style",
                      ),
                      _InfoRow(
                        icon: Icons.favorite_border,
                        text: "Thoughtful gestures",
                        subtitle: "Love language",
                      ),
                      _InfoRow(
                        icon: Icons.school_outlined,
                        text: "Bachelors",
                        subtitle: "Education level",
                      ),
                      _InfoRow(
                        icon: Icons.star_border,
                        text: "Cancer",
                        subtitle: "Zodiac sign",
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
  final LinearGradient gradient;

  const ProfileInfoSection({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced header with gradient
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
          // Info rows with enhanced styling
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String subtitle;
  final bool showDivider;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.subtitle,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: const Color(0xFF2D3436)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
            indent: 46,
          ),
      ],
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart' show Styles;
import '../../../../res/style/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../cubit/spotlight_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpotLightScreen extends StatelessWidget {
  const SpotLightScreen({super.key});

  static const double kPadding = 16;
  static const Color textColor = Colors.black87;
  static const Color iconColor = Colors.black87;
  static const Color boxColor = Color(0xFFE7E7E7);
  static const TextStyle textStyle =
  TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotlightCubit, SpotlightState>(
      builder: (context, state) {
        // Handle error state
        if (state.status == StateStatus.error) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                context.isArabic ? 'خطأ' : 'Error',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: iconColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: textColor,
                      size: 48,
                    ),
                    const SizedBox(height: kPadding),
                    Text(
                      context.isArabic
                          ? 'حدث خطأ أثناء تحميل البيانات'
                          : 'An error occurred while loading data',
                      style: textStyle.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: kPadding),
                    Text(
                      state.failure?.toString() ?? (context.isArabic ? 'خطأ غير معروف' : 'Unknown error'),
                      style: textStyle.copyWith(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: kPadding * 2),
                    ElevatedButton(
                      onPressed: () {
                        // Retry loading data
                        // context.read<SpotlightCubit>().loadSpotlightData(); // Adjust method name as needed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: boxColor,
                        foregroundColor: textColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        context.isArabic ? 'إعادة المحاولة' : 'Retry',
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Handle loading state
        if (state.status == StateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle success state
        if (state.status == StateStatus.success && state.spotlightEntity != null) {
          final data = state.spotlightEntity!;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Top Cover Image
                  TopImageSection(
                    imageUrl: data.coverPictureUrl ?? 'https://via.placeholder.com/600x300',
                  ),

                  Padding(
                    padding: const EdgeInsets.all(kPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: kPadding),

                        // ✅ Profile Picture + Name
                        Row(
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200],
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        (data.profilePictureUrl != null && data.profilePictureUrl!.isNotEmpty)
                                            ? data.profilePictureUrl!
                                            : "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: context.isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Label(text: "${data.firstName} ${data.lastName}"),
                                Label(text: "@${data.username}"),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: kPadding),

                        // ✅ Looking For
                        if (data.lookingFor != null) ...[
                          InfoBox(children: [
                            IconText(
                              icon: Assets.tinder_search,
                              text: context.isArabic ? 'يبحث عن' : 'Looking for',
                              iconSize: 12,
                              iconColor: Colors.black,
                            ),
                            IconText(
                              icon: Assets.waving,
                              text: data.lookingFor!,
                            ),
                          ]),
                          const SizedBox(height: kPadding),
                        ],

                        // ✅ About Me
                        if (data.aboutMe != null) ...[
                          InfoBox(children: [
                            SectionTitle(text: context.isArabic ? 'عني' : 'About Me'),
                            const SizedBox(height: 6),
                            Text(
                              data.aboutMe!,
                              style: textStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ]),
                          const SizedBox(height: kPadding),
                        ],

                        // ✅ Essentials & Lifestyle
                        InfoBox(children: [
                          SectionTitle(
                            text: context.isArabic ? 'الأساسيات' : 'Essentials',
                            icon: Icons.badge_outlined,
                          ),
                          const SizedBox(height: 8),
                          if (data.distance != null)
                            InfoRow(
                              Icons.location_on_outlined,
                              context.isArabic ? "${data.distance} ميل بعيدًا" : "${data.distance} miles away",

                            ),
                          if (data.height != null)
                            InfoRow(
                              Icons.straighten,
                              context.isArabic ? "${data.height} سم" : "${data.height} cm",

                            ),
                          if (data.university != null)
                            InfoRow(
                              Icons.school_outlined,
                              data.university!,
                              showDivider: false,

                            ),
                        ]),
                        const SizedBox(height: 12),

                        InfoBox(children: [
                          SectionTitle(
                            text: context.isArabic ? 'نمط الحياة' : 'Lifestyle',
                            icon: Icons.favorite_outline,
                          ),
                          const SizedBox(height: 8),
                          if (data.smoking != null)
                            InfoRow(
                              Icons.smoking_rooms_outlined,
                              data.smoking!,

                            ),
                          if (data.workout != null)
                            InfoRow(
                              Icons.fitness_center_outlined,
                              data.workout!,

                            ),
                          if (data.pets.isNotEmpty)
                            InfoRow(
                              Icons.pets_outlined,
                              data.pets.join(", "),
                              showDivider: false,

                            ),
                        ]),
                        const SizedBox(height: kPadding * 2),

                        // ✅ Interests
                        if (data.interests.isNotEmpty) ...[
                          InfoBox(children: [
                            SectionTitle(
                              text: context.isArabic ? 'الاهتمامات' : 'Interests',
                              icon: Icons.interests,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: data.interests
                                  .map((interest) => InterestChip(interest))
                                  .toList(),
                              direction: context.isArabic ? Axis.horizontal : Axis.horizontal,
                              alignment: context.isArabic ? WrapAlignment.end : WrapAlignment.start,
                            ),
                          ]),
                          const SizedBox(height: kPadding),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Initial or fallback state
        return const SizedBox();
      },
    );
  }
}
// class SpotLightScreen extends StatelessWidget {
//   const SpotLightScreen({super.key});
//
//   static const double kPadding = 16;
//   static const Color textColor = Colors.black87;
//   static const Color iconColor = Colors.black87;
//   static const Color boxColor = Color(0xFFE7E7E7);
//   static const TextStyle textStyle =
//   TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SpotlightCubit, SpotlightState>(
//       builder: (context, state) {
//         if (state.status == StateStatus.loading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (state.status == StateStatus.success &&
//             state.spotlightEntity != null) {
//           final data = state.spotlightEntity!;
//           return Scaffold(
//             backgroundColor: Colors.white,
//             body: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ✅ Top Cover Image
//                   TopImageSection(
//                     imageUrl: data.coverPictureUrl ??
//                         'https://via.placeholder.com/600x300',
//                   ),
//
//                   Padding(
//                     padding: const EdgeInsets.all(kPadding),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         const SizedBox(height: kPadding),
//
//                         // ✅ Profile Picture + Name
//                         Row(
//                           children: [
//                             Container(
//                               width: 65,
//                               height: 65,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(3.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.grey[200],
//                                     image: DecorationImage(
//                                       image: NetworkImage(
//                                         (data.profilePictureUrl != null &&
//                                             data.profilePictureUrl!.isNotEmpty)
//                                             ? data.profilePictureUrl!
//                                             : "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde",
//                                       ),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Label(text: "${data.firstName} ${data.lastName}"),
//                                 Label(text: "@${data.username}"),
//                               ],
//                             ),
//                           ],
//                         ),
//
//
//                         const SizedBox(height: kPadding),
//
//                         // ✅ Looking For
//                         if (data.lookingFor != null) ...[
//                           InfoBox(children: [
//                             IconText(
//                               icon: Assets.tinder_search,
//                               text: 'Looking for',
//                               iconSize: 12,
//                               iconColor: Colors.black,
//                             ),
//                             IconText(
//                               icon: Assets.waving,
//                               text: data.lookingFor!,
//                             ),
//                           ]),
//                           const SizedBox(height: kPadding),
//                         ],
//
//                         // ✅ About Me
//                         if (data.aboutMe != null) ...[
//                           InfoBox(children: [
//                             const SectionTitle(text: 'About Me'),
//                             const SizedBox(height: 6),
//                             Text(
//                               data.aboutMe!,
//                               style: textStyle.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ]),
//                           const SizedBox(height: kPadding),
//                         ],
//
//                         // ✅ Essentials & Lifestyle
//                         InfoBox(children: [
//                           const SectionTitle(
//                               text: "Essentials", icon: Icons.badge_outlined),
//                           const SizedBox(height: 8),
//                           if (data.distance != null)
//                             InfoRow(Icons.location_on_outlined,
//                                 "${data.distance} miles away"),
//                           if (data.height != null)
//                             InfoRow(Icons.straighten, "${data.height} cm"),
//                           if (data.university != null)
//                             InfoRow(Icons.school_outlined,
//                                 data.university!, showDivider: false),
//                         ]),
//                         const SizedBox(height: 12),
//
//                         InfoBox(children: [
//                           const SectionTitle(
//                               text: "Lifestyle", icon: Icons.favorite_outline),
//                           const SizedBox(height: 8),
//                           if (data.smoking != null)
//                             InfoRow(Icons.smoking_rooms_outlined, data.smoking!),
//                           if (data.workout != null)
//                             InfoRow(Icons.fitness_center_outlined, data.workout!),
//                           if (data.pets.isNotEmpty)
//                             InfoRow(Icons.pets_outlined, data.pets.join(", "),
//                                 showDivider: false),
//                         ]),
//                         const SizedBox(height: kPadding * 2),
//
//                         // ✅ Interests
//                         if (data.interests.isNotEmpty) ...[
//                           InfoBox(children: [
//                             const SectionTitle(
//                                 text: 'Interests', icon: Icons.interests),
//                             const SizedBox(height: 8),
//                             Wrap(
//                               spacing: 8,
//                               runSpacing: 8,
//                               children: data.interests
//                                   .map((interest) => InterestChip(interest))
//                                   .toList(),
//                             ),
//                           ]),
//                           const SizedBox(height: kPadding),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         // initial or fallback
//         return const SizedBox();
//       },
//     );
//   }
// }


/// ===== Reusable Small Widgets =====

class SectionTitle extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final TextStyle? textStyle;

  const SectionTitle({
    super.key,
    required this.text,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: iconColor ?? Colors.black87, size: iconSize ?? 18),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: textStyle ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
        ),
      ],
    );
  }
}

class IconText extends StatelessWidget {
  final String icon;
  final String text;
  final Color? iconColor;
  final double? iconSize;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;

  const IconText({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.iconSize,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: iconSize ?? 18,  // ✅ makes image smaller/larger
            height: iconSize ?? 18, // ✅ maintain square size
            color: iconColor,       // optional tint
            fit: BoxFit.contain,    // keeps image clean and proportional
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: textStyle ??
                  const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}


/// ===== Reusable Containers =====

class InfoBox extends StatelessWidget {
  final List<Widget> children;
  const InfoBox({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpotLightScreen.kPadding),
      decoration: BoxDecoration(
        color: SpotLightScreen.boxColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class InterestChip extends StatelessWidget {
  final String text;
  const InterestChip(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFC9C9C9),
      borderRadius: BorderRadius.circular(200),
    ),
    child: Text(text, style: SpotLightScreen.textStyle),
  );
}

class ActionButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  const ActionButton(this.text, {super.key, this.textColor});

  @override
  Widget build(BuildContext context) => InfoBox(
    children: [
      Center(
        child: Text(
          text,
          style: SpotLightScreen.textStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor ?? SpotLightScreen.textColor,
          ),
        ),
      ),
    ],
  );
}

/// ===== Top Image Section =====

class TopImageSection extends StatelessWidget {
  final String? imageUrl;
  const TopImageSection({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final String safeUrl = (imageUrl != null && imageUrl!.isNotEmpty)
        ? imageUrl!
        : "https://images.unsplash.com/photo-1506744038136-46273834b3fb";

    return Stack(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/placeholder.jpg',
            image: safeUrl,
            fit: BoxFit.cover,
          ),
        ),
        Container(height: 300, color: Colors.black.withOpacity(0.3)),
        const Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(color: Colors.white),
              Text('Spotlight',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 48),
            ],
          ),
        ),
      ],
    );
  }
}




/// ===== Gradient Circle List =====



/// ===== Profile Info Section =====

class ProfileInfoSections extends StatelessWidget {
  const ProfileInfoSections({super.key});

  @override
  Widget build(BuildContext context) => Column(children: const [
    ProfileInfoSection(
      title: "Essentials",
      icon: Icons.badge_outlined,
      items: [
        InfoRow(Icons.location_on_outlined, "10 miles away"),
        InfoRow(Icons.straighten, "188cm"),
        InfoRow(Icons.school_outlined, "Cairo University", showDivider: false),
      ],
    ),
    SizedBox(height: 12),
    ProfileInfoSection(
      title: "Lifestyle",
      icon: Icons.favorite_outline,
      items: [
        InfoRow(Icons.smoking_rooms_outlined, "Smoker"),
        InfoRow(Icons.fitness_center_outlined, "Sometimes"),
        InfoRow(Icons.pets_outlined, "Cat", showDivider: false),
      ],
    ),
  ]);
}

class ProfileInfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<InfoRow> items;
  const ProfileInfoSection(
      {super.key, required this.title, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) => InfoBox(children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Icon(icon, color: SpotLightScreen.iconColor),
          const SizedBox(width: 6),
          Text(title,
              style: SpotLightScreen.textStyle
                  .copyWith(fontWeight: FontWeight.bold)),
        ]),
        const Icon(Icons.more_horiz, color: Colors.black54),
      ],
    ),
    const SizedBox(height: 8),
    ...items,
  ]);
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool showDivider;
  const InfoRow(this.icon, this.text, {super.key, this.showDivider = true});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Icon(icon, color: SpotLightScreen.iconColor, size: 18),
          const SizedBox(width: 8),
          Text(text, style: SpotLightScreen.textStyle),
        ],
      ),
      if (showDivider)
        const Divider(color: Colors.black26, height: 16, thickness: 0.5),
    ],
  );
}

class GradientCircleList extends StatelessWidget {
  const GradientCircleList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        padding:  EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ProfileCard(
              name: 'Ahmed Mohamed',
              imageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
            ),
          );
        },
      ),
    );
  }
}
class ProfileCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const ProfileCard({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), offset: const Offset(0, 4), blurRadius: 8, spreadRadius: 1),
          BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(4, 0), blurRadius: 6),
          BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(-4, 0), blurRadius: 6),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          AppButton(
            height: 26,
            width: 75,
            label: LocaleKeys.add.localize,
            backColor: AppColors.cEDEDED,
            color: AppColors.PRIMARY_COLOR,
            style: Styles.mediumText(fontWeight: FontWeight.w500),
            iconWidget: Icon(Icons.add, color: AppColors.PRIMARY_COLOR, size: 14),
            onPressed: () {},
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/*
class SpotLightScreen extends StatelessWidget {
  const SpotLightScreen({super.key});

  static const double kDefaultPadding = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopImageSection(),

            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: kDefaultPadding),
                  SectionLabel(
                    text: context.isArabic ? 'ابحث عن أصدقاء' : 'Find Friends',
                  ),
                  const SizedBox(height: 8),
                  const GradientCircleList(),
                  const SizedBox(height: kDefaultPadding),

                  InfoContainer(
                    children: [
                      IconTextRow(
                        iconPath: Assets.tinder_search,
                        text: context.isArabic ? 'البحث عن' : 'Looking for',
                      ),
                      IconTextRow(
                        iconPath: Assets.waving,
                        text: context.isArabic ? 'أصدقاء جدد' : 'New Friends',
                      ),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding),

                  InfoContainer(
                    children: [
                      SectionHeader(text: context.isArabic ? 'عني' : 'About Me'),
                      Label(
                        text: context.isArabic ? 'مقاتل' : 'Fighter',
                        style: Styles.mediumText(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding),

                  const ProfileInfoSections(),
                  const SizedBox(height: kDefaultPadding * 2),

                  InfoContainer(
                    children: [
                      SectionHeader(
                        text: context.isArabic ? 'اهتمامات' : 'Interests',
                        icon: Icons.interests,
                        trailingWidget: SizedBox.shrink(),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          InterestChip(text: "Writing"),
                          InterestChip(text: "Reading"),
                          InterestChip(text: "Traveling"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding),

                  InfoContainer(
                    children: [
                      SectionHeader(
                        text: context.isArabic
                            ? 'تميّز بانطباع أول'
                            : 'Stand out with a first impression',
                        trailingWidget: Image.asset(Assets.colorArrow),
                      ),
                      const SizedBox(height: 8),
                      Label(
                        text: "Send a message before matching to get their attention...",
                        style: Styles.mediumText(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      FormTextField(
                        style: const TextStyle(color: Colors.black87),
                        label:  context.isArabic ? 'اكتب رسالة...' : 'Type a message...',
                        suffix:  Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            context.isArabic ? 'إرسال' : 'Send',
                            style: const TextStyle(
                              color: Colors.black87, // ✅ same color as TextFormField text
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),







                  const SizedBox(height: kDefaultPadding),

                  ActionButton(text: "Share Ahmed’s profile"),
                  const SizedBox(height: 8),
                  ActionButton(text: "Block Ahmed"),
                  const SizedBox(height: 8),
                  ActionButton(
                    text: "Report Ahmed",
                    textColor: AppColors.PRIMARY_COLOR_DARK,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===== Reusable Widgets =====

class InfoContainer extends StatelessWidget {
  final List<Widget> children;
  const InfoContainer({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpotLightScreen.kDefaultPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Label(
      text: text,
      style: Styles.mediumText(fontWeight: FontWeight.w500),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Widget? trailingWidget;

  const SectionHeader({required this.text, this.icon, this.trailingWidget, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Optional leading icon
        if (icon != null) ...[
          Icon(icon, color: Colors.black87),
          const SizedBox(width: 6),
        ],

        // Text
        Expanded(
          child: Label(
            text: text,
            style: Styles.mediumText(fontWeight: FontWeight.w500),
          ),
        ),

        // Trailing widget or default "more"
        trailingWidget ??
            const Icon(
              Icons.more_horiz,
              color: Colors.black54,
            ),
      ],
    );
  }
}


class IconTextRow extends StatelessWidget {
  final String iconPath;
  final String text;

  const IconTextRow({required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Image.asset(iconPath, width: 18, height: 18,color: AppColors.black,),
          const SizedBox(width: 8),
          Flexible(
            child: Label(
              text: text,
              style: Styles.mediumText(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class InterestChip extends StatelessWidget {
  final String text;
  const InterestChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.c9C9C9C,
        borderRadius: BorderRadius.circular(200),
      ),
      child: Label(text: text),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  const ActionButton({required this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    return InfoContainer(
      children: [
        Label(
          text: text,
          color: textColor ?? Colors.black87,
          textAlign: TextAlign.center,
          style: Styles.mediumText(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

/// ===== Top Image Section =====

class TopImageSection extends StatelessWidget {
  const TopImageSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/placeholder.jpg',
            image: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 300,
          color: Colors.black.withOpacity(0.3),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackButton(color: Colors.white),
              Text(
                'Spotlight',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 48),
            ],
          ),
        ),
      ],
    );
  }
}

/// ===== Gradient Circle List =====

class GradientCircleList extends StatelessWidget {
  const GradientCircleList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        padding:  EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ProfileCard(
              name: 'Ahmed Mohamed',
              imageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
            ),
          );
        },
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const ProfileCard({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), offset: const Offset(0, 4), blurRadius: 8, spreadRadius: 1),
          BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(4, 0), blurRadius: 6),
          BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(-4, 0), blurRadius: 6),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          AppButton(
            height: 26,
            width: 75,
            label: LocaleKeys.add.localize,
            backColor: AppColors.cEDEDED,
            color: AppColors.PRIMARY_COLOR,
            style: Styles.mediumText(fontWeight: FontWeight.w500),
            iconWidget: Icon(Icons.add, color: AppColors.PRIMARY_COLOR, size: 14),
            onPressed: () {},
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// ===== Profile Info Sections =====

class ProfileInfoSections extends StatelessWidget {
  const ProfileInfoSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ProfileInfoSection(
          title: "Essentials",
          icon: Icons.badge_outlined,
          items: [
            InfoRow(icon: Icons.location_on_outlined, text: "10 miles away"),
            InfoRow(icon: Icons.straighten, text: "188cm"),
            InfoRow(icon: Icons.school_outlined, text: "Cairo University", showDivider: false),
          ],
        ),
        SizedBox(height: 12),
        ProfileInfoSection(
          title: "Lifestyle",
          icon: Icons.favorite_outline,
          items: [
            InfoRow(icon: Icons.smoking_rooms_outlined, text: "Smoker"),
            InfoRow(icon: Icons.fitness_center_outlined, text: "Sometimes"),
            InfoRow(icon: Icons.pets_outlined, text: "Cat", showDivider: false),
          ],
        ),
        SizedBox(height: 12),
        ProfileInfoSection(
          title: "Basics",
          icon: Icons.person_outline,
          items: [
            InfoRow(icon: Icons.chat_bubble_outline, text: "Big time texter"),
            InfoRow(icon: Icons.favorite_border, text: "Thoughtful gestures"),
            InfoRow(icon: Icons.school_outlined, text: "Bachelors"),
            InfoRow(icon: Icons.star_border, text: "Cancer", showDivider: false),
          ],
        ),
      ],
    );
  }
}

class ProfileInfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<InfoRow> items;

  const ProfileInfoSection({super.key, required this.title, required this.icon, required this.items});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: Colors.black87),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
              const Icon(Icons.more_horiz, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Colors.black26),
          ...items,
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool showDivider;

  const InfoRow({required this.icon, required this.text, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
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
*/


