class DurationHelper {
  String sinceTime({required Duration duration}) {
    return duration.inDays > 0
        ? "${duration.inDays} Days"
        : duration.inHours > 0
            ? "${duration.inHours} Hrs"
            : "${duration.inMinutes} Min";
  }
}
