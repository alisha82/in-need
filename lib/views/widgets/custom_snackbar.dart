import 'package:flutter/material.dart';

class AppSnackbar {
  static void show(
      BuildContext context, {
        required String message,
        bool isSuccess = true, // True matlab success (green/tick), False matlab error (red/cross)
      }) {
    // Purana snackbar foran hata kar naya show karega
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            // Status ke mutabiq icon aur uska background circle
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSuccess
                    ? Colors.green.withOpacity(0.15)
                    : Colors.red.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check : Icons.error_outline,
                color: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Message text jo lamba hone par automatically wrap ho jaye ga
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white, // Screenshots jaisa clean white look
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSuccess ? Colors.green.shade200 : Colors.red.shade200,
            width: 1,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}