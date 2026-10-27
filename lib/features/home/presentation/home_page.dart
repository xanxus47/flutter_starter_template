import 'package:flutter/material.dart';
import 'package:template_kit/shared/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color _titleColor = Color(0xFF111827);
  static const Color _subtitleColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroHeader(now: now)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            sliver: SliverList.list(
              children: const [
                _MissionCard(),
                SizedBox(height: 16),
                Text(
                  'Our mandate',
                  style: TextStyle(
                    color: _titleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                _MandateGrid(),
                SizedBox(height: 16),
                _ServiceNote(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.now});

  final DateTime now;

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        '${_weekdays[now.weekday - 1]}, ${now.day} ${_months[now.month - 1]} ${now.year}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.paddingOf(context).top + 28,
        24,
        32,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15803D), Color(0xFF16A34A), Color(0xFF4ADE80)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Image.asset(
            'lib/assets/MDRRMO MAGSAYSAY.png',
            height: 88,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              dateLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Safer, adaptive, and disaster-resilient communities.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Welcome',
            style: TextStyle(
              color: HomePage._titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This workspace supports MDRRMO personnel in daily operations—from emergency response teams to admin, planning, and I.T. staff who keep the office ready around the clock.',
            style: TextStyle(
              color: HomePage._subtitleColor,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MandateGrid extends StatelessWidget {
  const _MandateGrid();

  static const items = [
    (Icons.visibility_outlined, 'Prevention', 'Reduce hazards before they grow.'),
    (Icons.checklist_rtl, 'Preparedness', 'Train, plan, and stay ready.'),
    (Icons.emergency_outlined, 'Response', 'Act fast when emergencies strike.'),
    (Icons.home_repair_service_outlined, 'Recovery', 'Help communities stand again.'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.92,
      children: [
        for (final item in items)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppCardStyle.iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.$1, color: AppCardStyle.accent, size: 22),
                ),
                const SizedBox(height: 16),
                Text(
                  item.$2,
                  style: const TextStyle(
                    color: HomePage._titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.$3,
                  style: const TextStyle(
                    color: HomePage._subtitleColor,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ServiceNote extends StatelessWidget {
  const _ServiceNote();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: const Color(0xFFE8EDE9),
      child: const Row(
        children: [
          Icon(Icons.groups_outlined, color: AppCardStyle.accent),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Use the Attendance tab to view personnel by unit and daily time records.',
              style: TextStyle(
                color: HomePage._titleColor,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
