import 'package:flutter/material.dart';
import 'package:template_kit/core/repositories/employee_repository.dart';
import 'package:template_kit/features/home/presentation/home_controller.dart';
import 'package:template_kit/features/home/presentation/widgets/employee_tile.dart';
import 'package:template_kit/shared/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.repository});

  final EmployeeRepository repository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;

  static const Color _titleColor = Color(0xFF111827);
  static const Color _subtitleColor = Color(0xFF6B7280);
  static const Color _borderColor = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _controller = HomeController(widget.repository);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        title: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Employees',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _titleColor,
                  ),
                ),
                if (!_controller.isLoading && !_controller.hasError)
                  Text(
                    _controller.count == 1
                        ? '1 person'
                        : '${_controller.count} people',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _subtitleColor,
                    ),
                  ),
              ],
            );
          },
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: ColoredBox(color: _borderColor, child: SizedBox(height: 1)),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppTextField(
              hint: 'Search by name',
              prefixIcon: Icons.search,
              textInputAction: TextInputAction.search,
              onChanged: _controller.onQueryChanged,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => _EmployeeListBody(
                controller: _controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeListBody extends StatelessWidget {
  const _EmployeeListBody({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppCardStyle.accent,
      onRefresh: () => controller.load(silent: true),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (controller.isLoading && controller.employees.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          AppShimmer(
            child: Column(
              children: [
                for (var i = 0; i < 8; i++) ...[
                  const AppSkeletonListTile(shimmer: false, hasTrailing: true),
                  if (i < 7) const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ],
      );
    }

    if (controller.hasError && controller.employees.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 48),
        children: [
          AppFeedbackState.error(
            message: controller.errorMessage,
            onAction: controller.load,
          ),
        ],
      );
    }

    if (controller.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 48),
        children: [
          AppFeedbackState.empty(
            title: controller.query.isEmpty
                ? 'No employees found'
                : 'No matching employees',
            message: controller.query.isEmpty
                ? 'Employee records will show up here once they are added.'
                : 'Try a different name or clear your search.',
            icon: Icons.groups_outlined,
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: controller.employees.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return EmployeeTile(employee: controller.employees[index]);
      },
    );
  }
}
