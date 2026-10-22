import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum AppButtonStyle { primary, accent, outline }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final AppButtonStyle style;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.style = AppButtonStyle.primary,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        if (icon != null) ...[
          const SizedBox(width: 8),
          Icon(icon, size: 18),
        ],
      ],
    );

    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    const size = Size(0, 0);

    switch (style) {
      case AppButtonStyle.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: size,
            padding: padding,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: content,
        );
      case AppButtonStyle.accent:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.softYellow,
            foregroundColor: AppTheme.deepBlue,
            minimumSize: size,
            padding: padding,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: content,
        );
      case AppButtonStyle.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: size,
            padding: padding,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: content,
        );
    }
  }
}
