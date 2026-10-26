import 'package:flutter/material.dart';
import 'package:template_kit/shared/widgets/app_button.dart';

abstract final class AppOverlayStyle {
  static const Color accent = Color(0xFF16A34A);
  static const Color surface = Colors.white;
  static const Color title = Color(0xFF111827);
  static const Color message = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color destructive = Color(0xFFDC2626);
  static const Color barrier = Color(0x80111827);
  static const Color handle = Color(0xFFE5E7EB);
  static const double dialogRadius = 20;
  static const double sheetRadius = 24;
}

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    String? message,
    IconData? icon,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: AppOverlayStyle.barrier,
      builder: (context) => AppConfirmDialog(
        title: title,
        message: message,
        icon: icon,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  static Future<bool> logout(BuildContext context) {
    return show(
      context,
      title: 'Log out',
      message: 'Are you sure you want to log out?',
      icon: Icons.logout,
      confirmLabel: 'Log out',
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppOverlayStyle.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppOverlayStyle.dialogRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFE8EDE9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDestructive
                      ? AppOverlayStyle.destructive
                      : AppOverlayStyle.accent,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppOverlayStyle.title,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppOverlayStyle.message,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _OverlayButton(
                    label: cancelLabel,
                    variant: _OverlayButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OverlayButton(
                    label: confirmLabel,
                    variant: isDestructive
                        ? _OverlayButtonVariant.destructive
                        : _OverlayButtonVariant.primary,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
  });

  final Widget child;
  final String? title;

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppOverlayStyle.barrier,
      builder: (_) => AppBottomSheet(title: title, child: child),
    );
  }

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    IconData? icon,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await show<bool>(
      context,
      child: _ConfirmSheetContent(
        title: title,
        message: message,
        icon: icon,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          ),
          child: Material(
            color: AppOverlayStyle.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppOverlayStyle.sheetRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppOverlayStyle.handle,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    if (title != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppOverlayStyle.title,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmSheetContent extends StatelessWidget {
  const _ConfirmSheetContent({
    required this.title,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDestructive,
    this.message,
    this.icon,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDestructive
                  ? const Color(0xFFFEE2E2)
                  : const Color(0xFFE8EDE9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDestructive
                  ? AppOverlayStyle.destructive
                  : AppOverlayStyle.accent,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppOverlayStyle.title,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppOverlayStyle.message,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 24),
        _OverlayButton(
          label: confirmLabel,
          variant: isDestructive
              ? _OverlayButtonVariant.destructive
              : _OverlayButtonVariant.primary,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        const SizedBox(height: 10),
        _OverlayButton(
          label: cancelLabel,
          variant: _OverlayButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}

enum _OverlayButtonVariant { primary, secondary, destructive }

class _OverlayButton extends StatelessWidget {
  const _OverlayButton({
    required this.label,
    required this.onPressed,
    required this.variant,
  });

  final String label;
  final VoidCallback onPressed;
  final _OverlayButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    if (variant == _OverlayButtonVariant.primary) {
      return AppButton(
        label: label,
        onPressed: onPressed,
        isExpanded: true,
      );
    }

    final bool isDestructive = variant == _OverlayButtonVariant.destructive;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: isDestructive
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppOverlayStyle.destructive,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppOverlayStyle.destructive.withValues(
                  alpha: 0.5,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF374151),
                side: const BorderSide(color: AppOverlayStyle.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
