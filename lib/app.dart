import 'package:flutter/material.dart';
import 'package:template_kit/core/repositories/employee_repository.dart';
import 'package:template_kit/features/home/presentation/home_page.dart';

class App extends StatelessWidget {
  const App({super.key, required this.employeeRepository});

  final EmployeeRepository employeeRepository;

  static const Color _accent = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template Kit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _accent),
        scaffoldBackgroundColor: const Color(0xFFF8FAF9),
      ),
      home: HomePage(repository: employeeRepository),
    );
  }
}
