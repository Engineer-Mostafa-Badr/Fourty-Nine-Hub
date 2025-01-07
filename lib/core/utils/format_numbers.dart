class FormatNumbers{
  String formatNumber(num number) {
    if (number >= 1000 && number < 1000000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else if (number >= 1000000 && number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    } else {
      return number.toStringAsFixed(0);
    }
  }
}