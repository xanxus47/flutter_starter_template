import 'package:flutter/material.dart';

class AppBottomNavItem {
  const AppBottomNavItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppBottomNavItem> items;

  static const Color _accent = Color(0xFF16A34A);
  static const Color _unselected = Color(0xFF9CA3AF);
  static const Color _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          for (final item in items)
            BottomNavigationBarItem(
              icon: Icon(item.icon),
              activeIcon: Icon(item.selectedIcon ?? item.icon),
              label: item.label,
            ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _unselected,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        elevation: 0,
      ),
    );
  }
}
