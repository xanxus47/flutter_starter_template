import 'package:flutter/material.dart';

abstract final class AppCardStyle {
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color title = Color(0xFF111827);
  static const Color subtitle = Color(0xFF6B7280);
  static const Color accent = Color(0xFF16A34A);
  static const Color iconBackground = Color(0xFFE8EDE9);
  static const double radius = 12;
  static const EdgeInsets padding = EdgeInsets.all(16);

  static const List<BoxShadow> shadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppCardStyle.padding,
    this.margin,
    this.onTap,
    this.color = AppCardStyle.surface,
    this.width,
    this.height,
    this.outlined = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color color;
  final double? width;
  final double? height;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppCardStyle.radius),
      side: outlined
          ? const BorderSide(color: AppCardStyle.border)
          : BorderSide.none,
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppCardStyle.radius),
        boxShadow: outlined ? null : AppCardStyle.shadow,
      ),
      child: Material(
        color: color,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: onTap == null
            ? Padding(padding: padding, child: child)
            : InkWell(
                onTap: onTap,
                customBorder: shape,
                child: Padding(padding: padding, child: child),
              ),
      ),
    );
  }
}

class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.trailing,
    this.padding = AppCardStyle.padding,
    this.margin,
    this.onTap,
    this.outlined = false,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final bool hasHeader = title != null || trailing != null;

    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      outlined: outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasHeader) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: const TextStyle(
                            color: AppCardStyle.title,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: AppCardStyle.subtitle,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}

class AppTileCard extends StatelessWidget {
  const AppTileCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.margin,
    this.outlined = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: margin,
      onTap: onTap,
      outlined: outlined,
      child: Row(
        children: [
          if (leading != null)
            leading!
          else if (leadingIcon != null) ...[
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppCardStyle.iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                leadingIcon,
                size: 22,
                color: AppCardStyle.accent,
              ),
            ),
          ],
          if (leading != null || leadingIcon != null) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppCardStyle.title,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: AppCardStyle.subtitle,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}
