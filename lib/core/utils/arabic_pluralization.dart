class ArabicPluralization {
  /// Returns the appropriate Arabic word for winner based on the count
  static String getWinnerText(int count, bool isArabic) {
    if (!isArabic) {
      return count == 1 ? 'Winner' : 'Winners';
    }

    // Arabic pluralization rules for "فائز" (winner)
    if (count == 0) {
      return 'لا يوجد فائزون'; // No winners, use singular
    } else if (count == 1) {
      return 'فائز'; // One winner
    } else if (count == 2) {
      return 'فائزان'; // Two winners (dual form)
    } else if (count >= 3 && count <= 10) {
      return 'فائزون'; // 3-10 winners (plural form)
    } else {
      return 'فائز'; // 11+ winners (uses singular form in Arabic)
    }
  }

  /// Returns the appropriate Arabic word for any noun based on count
  /// This is a more generic function for other words
  static String getArabicPlural(
      int count, String singular, String dual, String plural) {
    if (count == 0 || count == 1) {
      return singular;
    } else if (count == 2) {
      return dual;
    } else if (count >= 3 && count <= 10) {
      return plural;
    } else {
      return singular; // 11+ uses singular form in Arabic
    }
  }
}
