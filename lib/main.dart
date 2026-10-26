import 'package:flutter/material.dart';
import 'package:template_kit/app.dart';
import 'package:template_kit/core/network/api_client.dart';
import 'package:template_kit/core/repositories/employee_repository.dart';

void main() {
  final employeeRepository = EmployeeRepository(ApiClient());
  runApp(App(employeeRepository: employeeRepository));
}
