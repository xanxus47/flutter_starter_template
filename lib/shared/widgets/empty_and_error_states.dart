import 'package:flutter/material.dart';
import 'package:template_kit/shared/widgets/app_button.dart';

enum AppFeedbackKind { empty, error }

class AppFeedbackState extends StatelessWidget {
  const AppFeedbackState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.isActionLoading = false,
    this.kind = AppFeedbackKind.empty,
  });

  const AppFeedbackState.empty({
    super.key,
    this.title = 'No history found',
    this.message = 'When you have activity, it will show up here.',
    this.icon,
    this.actionLabel,
    this.onAction,
    this.isActionLoading = false,
  }) : kind = AppFeedbackKind.empty;

  const AppFeedbackState.error({
    super.key,
    this.title = 'Something went wrong',
    this.message =
        "We couldn't load this data. Check your connection and try again.",
    this.icon,
    this.actionLabel = 'Retry',
    required this.onAction,
    this.isActionLoading = false,
  }) : kind = AppFeedbackKind.error;

  final String title;
  final String? message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isActionLoading;
  final AppFeedbackKind kind;

  static const Color _accent = Color(0xFF16A34A);
  static const Color _titleColor = Color(0xFF111827);
  static const Color _messageColor = Color(0xFF6B7280);
  static const Color _emptyIconBackground = Color(0xFFE8EDE9);
  static const Color _errorIconBackground = Color(0xFFFEE2E2);
  static const Color _errorIconColor = Color(0xFFDC2626);

  bool get _isError => kind == AppFeedbackKind.error;

  @override
  Widget build(BuildContext context) {
    final IconData resolvedIcon = icon ??
        (_isError ? Icons.cloud_off_outlined : Icons.inbox_outlined);
    final Color iconColor = _isError ? _errorIconColor : _accent;
    final Color iconBackground =
        _isError ? _errorIconBackground : _emptyIconBackground;
    final bool showAction = onAction != null && (actionLabel ?? '').isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(resolvedIcon, size: 40, color: iconColor),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _titleColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _messageColor,
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
              if (showAction) ...[
                const SizedBox(height: 24),
                AppButton(
                  label: actionLabel!,
                  icon: _isError ? Icons.refresh : null,
                  onPressed: onAction,
                  isLoading: isActionLoading,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
