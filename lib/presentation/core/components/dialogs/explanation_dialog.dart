import 'package:flutter/material.dart';

class ExplanationDialog extends StatelessWidget {
  const ExplanationDialog(
    this.context, {
    super.key,
    required this.iconData,
    required this.title,
    required this.explanation,
    required this.actionButtonText,
    required this.onActionPressed,
  });

  final BuildContext context;
  final IconData iconData;
  final String title;
  final String explanation;
  final String actionButtonText;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog.adaptive(
      icon: Icon(iconData, size: 48.0, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        explanation,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            onActionPressed();
          },
          child: Text(actionButtonText),
        ),
      ],
    );
  }
}
