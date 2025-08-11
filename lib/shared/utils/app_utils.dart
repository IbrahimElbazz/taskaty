import 'package:flutter/material.dart';
import '../../core/translations.dart';

class AppUtils {
  // Show a simple snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    String locale = 'en',
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(Translations.tr(message, locale: locale)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Show a confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    String message, {
    String locale = 'en',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Translations.tr(title, locale: locale)),
        content: Text(Translations.tr(message, locale: locale)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(Translations.tr('common.cancel', locale: locale)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(Translations.tr('common.ok', locale: locale)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Format date for display
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Get priority color
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone number format
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]+$').hasMatch(phone);
  }
}
