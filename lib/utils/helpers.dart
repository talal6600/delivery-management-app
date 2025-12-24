import 'package:flutter/material.dart';
import '../config/constants.dart';

class Helpers {
  // Show snackbar message
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  // Show confirmation dialog
  static Future<bool> showConfirmDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
  
  // Get delivery type name in Arabic
  static String getDeliveryTypeName(String type) {
    switch (type) {
      case AppConstants.deliveryJawy:
        return AppConstants.deliveryJawyName;
      case AppConstants.deliverySawa:
        return AppConstants.deliverySawaName;
      case AppConstants.deliveryMultiple:
        return AppConstants.deliveryMultipleName;
      case AppConstants.deliveryIncomplete:
        return AppConstants.deliveryIncompleteName;
      case AppConstants.deliveryDevice:
        return AppConstants.deliveryDeviceName;
      default:
        return type;
    }
  }
  
  // Get time range name in Arabic
  static String getTimeRangeName(String timeRange) {
    switch (timeRange) {
      case AppConstants.timeRangeLessThan2:
        return AppConstants.timeRangeLessThan2Name;
      case AppConstants.timeRange2To3:
        return AppConstants.timeRange2To3Name;
      case AppConstants.timeRangeMoreThan3:
        return AppConstants.timeRangeMoreThan3Name;
      default:
        return timeRange;
    }
  }
  
  // Get fuel type name in Arabic
  static String getFuelTypeName(String type) {
    switch (type) {
      case AppConstants.fuel91:
        return AppConstants.fuel91Name;
      case AppConstants.fuel95:
        return AppConstants.fuel95Name;
      default:
        return type;
    }
  }
  
  // Validate number input
  static double? parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }
  
  // Validate integer input
  static int? parseInt(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return null;
    }
  }
  
  // Get delivery icon
  static IconData getDeliveryIcon(String type) {
    switch (type) {
      case AppConstants.deliveryJawy:
        return Icons.sim_card;
      case AppConstants.deliverySawa:
        return Icons.sim_card_outlined;
      case AppConstants.deliveryMultiple:
        return Icons.sim_card_download;
      case AppConstants.deliveryIncomplete:
        return Icons.cancel_outlined;
      case AppConstants.deliveryDevice:
        return Icons.phone_android;
      default:
        return Icons.delivery_dining;
    }
  }
}
