import 'package:flutter/material.dart';
import 'package:template_kit/shared/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.onOpenAttendance});

  final VoidCallback? onOpenAttendance;

  static const Color _titleColor = Color(0xFF111827);
  static const Color _subtitleColor = Color(0xFF6B7280);
  static const Color _borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _titleColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Home',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _titleColor,
              ),
            ),
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _subtitleColor,
              ),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: ColoredBox(color: _borderColor, child: SizedBox(height: 1)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          AppSectionCard(
            title: 'Welcome',
            subtitle: 'Track employees and attendance from one place.',
            child: AppButton(
              label: 'View attendance',
              icon: Icons.groups_outlined,
              isExpanded: true,
              onPressed: onOpenAttendance,
            ),
          ),
          const SizedBox(height: 12),
          AppTileCard(
            leadingIcon: Icons.groups_outlined,
            title: 'Attendance',
            subtitle: 'Browse the full employee list',
            trailing: const Icon(
              Icons.chevron_right,
              color: AppCardStyle.subtitle,
            ),
            onTap: onOpenAttendance,
          ),
        ],
      ),
    );
  }
}
