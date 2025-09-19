class FormatDate {
  static String dateTimeToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // YYYY-MM-DD HH:mm (formato americano/ISO)
  static String formatString1({required String value}) {
    final date = DateTime.parse(value);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
