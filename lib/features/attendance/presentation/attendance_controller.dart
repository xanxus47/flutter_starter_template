import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:template_kit/core/models/employee.dart';
import 'package:template_kit/core/network/api_exception.dart';
import 'package:template_kit/core/repositories/employee_repository.dart';

class AttendanceController extends ChangeNotifier {
  AttendanceController(this._repository) {
    load();
  }

  final EmployeeRepository _repository;
  Timer? _debounce;

  List<Employee> employees = const [];
  int count = 0;
  bool isLoading = true;
  String? errorMessage;
  String query = '';

  bool get hasError => errorMessage != null;
  bool get isEmpty => !isLoading && !hasError && employees.isEmpty;

  List<Employee> employeesIn(EmployeeDepartment department) {
    return employees
        .where((employee) => employee.department == department)
        .toList()
      ..sort(
        (left, right) =>
            left.name.toLowerCase().compareTo(right.name.toLowerCase()),
      );
  }

  Future<void> load({bool silent = false}) async {
    if (!silent) {
      isLoading = true;
    }
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.listEmployees(query: query);
      employees = result.employees;
      count = result.count;
    } on ApiException catch (error) {
      errorMessage = error.message;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void onQueryChanged(String value) {
    query = value.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), load);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
