import 'dart:ui';

enum DriverRank {
  gold,
  silver,
  bronze,
  platinum;

  static DriverRank fromString(String rank) {
    switch (rank) {
      case "gold":
        return DriverRank.gold;
      case "silver":
        return DriverRank.silver;
      case "bronze":
        return DriverRank.bronze;
      case "platinum":
        return DriverRank.platinum;
      default:
        return DriverRank.gold;
    }
  }

   String toAr() {
    switch (this) {
      case DriverRank.gold:
        return "ذهبي";
      case DriverRank.silver:
        return "فضي";
      case DriverRank.bronze:
        return "برونزي";
      case DriverRank.platinum:
        return "بلاتيني";
    }
  }

  String toEn() {
    switch (this) {
      case DriverRank.gold:
        return "Gold";
      case DriverRank.silver:
        return "Silver";
      case DriverRank.bronze:
        return "Bronze";
      case DriverRank.platinum:
        return "Platinum";
    }
  }

  Color toColor() {
    switch (this) {
      case DriverRank.gold:
        return const Color(0xFFEFBF04); // Gold
      case DriverRank.silver:
        return const Color(0xFFC0C0C0); // Silver
      case DriverRank.bronze:
        return const Color(0xFFCD7F32); // Bronze
      case DriverRank.platinum:
        return const Color(0xFF800080); // Platinum
    }
  }

}