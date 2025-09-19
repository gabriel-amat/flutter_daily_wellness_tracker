import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomSnack {
  final snackbarKey = GlobalKey<ScaffoldMessengerState>();

  SnackBar _appSnack({
    required String title,
    required Widget icon,
    required Color color,
  }) {
    return SnackBar(
      content: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 4),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8),
      showCloseIcon: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppTheme.borderRadius,
        ),
      ),
    );
  }

  void cancel() => snackbarKey.currentState?.removeCurrentSnackBar();

  success({required String text}) {
    snackbarKey.currentState!.showSnackBar(
      _appSnack(
        title: text,
        icon: const Icon(Icons.check, color: Colors.white),
        color: Colors.green,
      ),
    );
  }

  error({required String text}) {
    snackbarKey.currentState!.showSnackBar(
      _appSnack(
        title: text,
        icon: const Icon(Icons.error, color: Colors.white),
        color: Colors.red,
      ),
    );
  }

  warning({required String text}) {
    snackbarKey.currentState!.showSnackBar(
      _appSnack(
        title: text,
        icon: const Icon(Icons.warning_amber_outlined, color: Colors.white),
        color: Colors.amber,
      ),
    );
  }

  loading({required String text}) {
    snackbarKey.currentState!.showSnackBar(
      _appSnack(
        title: text,
        icon: const Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
        color: Colors.amber,
      ),
    );
  }
}
