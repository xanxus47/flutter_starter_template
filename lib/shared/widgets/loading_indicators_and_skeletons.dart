import 'package:flutter/material.dart';

abstract final class AppLoaderStyle {
  static const Color accent = Color(0xFF16A34A);
  static const Color base = Color(0xFFE8EDE9);
  static const Color highlight = Color(0xFFF7FAF8);
  static const Color overlay = Color(0x80111827);
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF374151);
}

class AppCircularLoader extends StatelessWidget {
  const AppCircularLoader({
    super.key,
    this.size = 28,
    this.strokeWidth = 3,
    this.color = AppLoaderStyle.accent,
    this.message,
  });

  final double size;
  final double strokeWidth;
  final Color color;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color,
      ),
    );

    if (message == null) return indicator;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        const SizedBox(height: 16),
        Text(
          message!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppLoaderStyle.text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class AppLoadingCard extends StatelessWidget {
  const AppLoadingCard({
    super.key,
    this.message,
    this.size = 32,
  });

  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppLoaderStyle.surface,
      elevation: 8,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: AppCircularLoader(size: size, message: message),
      ),
    );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  final bool isLoading;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: AppLoaderStyle.overlay,
                child: Center(child: AppLoadingCard(message: message)),
              ),
            ),
          ),
      ],
    );
  }
}

abstract final class AppLoader {
  static OverlayEntry? _entry;

  static bool get isShowing => _entry != null;

  static void show(BuildContext context, {String? message}) {
    hide();
    _entry = OverlayEntry(
      builder: (_) => _GlobalLoaderBarrier(message: message),
    );
    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _GlobalLoaderBarrier extends StatelessWidget {
  const _GlobalLoaderBarrier({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: AppLoaderStyle.overlay,
          child: Center(child: AppLoadingCard(message: message)),
        ),
      ),
    );
  }
}

class AppShimmer extends StatefulWidget {
  const AppShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AppShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                AppLoaderStyle.base,
                AppLoaderStyle.highlight,
                AppLoaderStyle.base,
              ],
              stops: const [0.1, 0.5, 0.9],
              transform: _SlidingGradientTransform(_controller.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.percent);

  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (percent * 2 - 1), 0, 0);
  }
}

class AppSkeletonBox extends StatelessWidget {
  const AppSkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppLoaderStyle.base,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class AppSkeletonCircle extends StatelessWidget {
  const AppSkeletonCircle({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppLoaderStyle.base,
        shape: BoxShape.circle,
      ),
    );
  }
}

class AppSkeletonListTile extends StatelessWidget {
  const AppSkeletonListTile({
    super.key,
    this.shimmer = true,
    this.hasTrailing = false,
  });

  final bool shimmer;
  final bool hasTrailing;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        const AppSkeletonCircle(size: 44),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeletonBox(height: 14, borderRadius: 6),
              SizedBox(height: 8),
              AppSkeletonBox(width: 140, height: 12, borderRadius: 6),
            ],
          ),
        ),
        if (hasTrailing) ...const [
          SizedBox(width: 12),
          AppSkeletonBox(width: 48, height: 12, borderRadius: 6),
        ],
      ],
    );

    if (!shimmer) return content;
    return AppShimmer(child: content);
  }
}

class AppSkeletonCard extends StatelessWidget {
  const AppSkeletonCard({
    super.key,
    this.shimmer = true,
    this.imageHeight = 140,
  });

  final bool shimmer;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeletonBox(height: imageHeight, borderRadius: 12),
        const SizedBox(height: 12),
        const AppSkeletonBox(height: 16, borderRadius: 6),
        const SizedBox(height: 8),
        const AppSkeletonBox(width: 180, height: 12, borderRadius: 6),
      ],
    );

    if (!shimmer) return content;
    return AppShimmer(child: content);
  }
}

class AppSkeletonList extends StatelessWidget {
  const AppSkeletonList({
    super.key,
    this.itemCount = 6,
    this.padding,
    this.separatorHeight = 16,
    this.hasTrailing = false,
  });

  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final double separatorHeight;
  final bool hasTrailing;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(height: separatorHeight),
        itemBuilder: (_, _) => AppSkeletonListTile(
          shimmer: false,
          hasTrailing: hasTrailing,
        ),
      ),
    );
  }
}
