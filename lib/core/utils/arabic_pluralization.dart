class ArabicPluralization {
  /// Returns the appropriate Arabic word for winner based on the count
  static String getWinnerText(int count, bool isArabic) {
    if (!isArabic) {
      return 'Winners';
    }
    return 'الفائزون'; // 3-10 winners (plural form)
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
