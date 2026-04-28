import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommonMethods {
  static const String cur = '\$';

  static void unFocsKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void showAlertDialog(
      {String title = "logout",
      String content = "wouldYouLikeToLogout",
      VoidCallback? onPressedYes}) {
    showCupertinoModalPopup<void>(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Get.back(),
            child: Text("NO"),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: onPressedYes,
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  static String formatDate(String? date) {
    if (date == null || date.isEmpty) return "Not available";

    try {
      // Parse the date assuming it's in 'yyyy-MM-dd' format
      DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);

      // Format it as '16 March 2025'
      return DateFormat('d MMMM yyyy').format(parsedDate);
    } catch (e) {
      print("Error formatting date: $e");
      return "Invalid date";
    }
  }

}
