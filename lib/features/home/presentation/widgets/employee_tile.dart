import 'package:flutter/material.dart';
import 'package:template_kit/core/models/employee.dart';
import 'package:template_kit/shared/widgets/widgets.dart';

class EmployeeTile extends StatelessWidget {
  const EmployeeTile({super.key, required this.employee, this.onTap});

  final Employee employee;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppTileCard(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppCardStyle.iconBackground,
        child: Text(
          employee.initials,
          style: const TextStyle(
            color: AppCardStyle.accent,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: employee.name,
      subtitle: employee.subtitle,
      trailing: _StatusChip(active: employee.active),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: active ? AppCardStyle.iconBackground : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(
          color: active ? AppCardStyle.accent : AppCardStyle.subtitle,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
