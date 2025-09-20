import 'dart:developer';

extension StringToDateExtension on String {
  String? toFormattedDate() {
    try {
      final parts = split('-');
      if (parts.length != 3) return null;

      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
    } catch (e) {
      log('Error formatting date: $e');
      return null;
    }
  }
}
