import 'package:camera_test_task/presentation/core/components/dialogs/explanation_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showExplanationDialog({
  required BuildContext context,
  required IconData iconData,
  required String title,
  required String explanation,
  required String actionButtonText,
  required Future<void> Function() onActionPressed,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return PopScope(
        canPop: false,
        child: ExplanationDialog(
          context,
          iconData: iconData,
          title: title,
          explanation: explanation,
          actionButtonText: actionButtonText,
          onActionPressed: onActionPressed,
        ),
      );
    },
  );
}
