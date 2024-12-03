import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/utils/logger.dart';
import 'package:injectable/injectable.dart';

import '../repositories/employees_repository.dart';

@injectable
class EmployeeService {
  final EmployeesRepository _employeeRepository;

  EmployeeService({required EmployeesRepository employeeRepository})
      : _employeeRepository = employeeRepository;

  Future<List<Employee>> searchEmployees({
    String? query,
    String? departmentId,
    EmployeeRole? role,
    bool? isActive,
    int limit = 20,
  }) async {
    try {
      logger.i('Searching employees: query=$query, department=$departmentId');

      if (query == null && departmentId == null && role == null && isActive == null) {
        return await _employeeRepository.getActiveEmployees(limit: limit);
      }

      // TODO: Implement more advanced search logic in the repository
      final employees = await _employeeRepository.searchEmployees(query ?? '', limit: limit);

      // Additional filtering
      final filteredEmployees = employees.where((employee) {
        if (departmentId != null && employee.departmentId != departmentId) return false;
        if (role != null && employee.role != role) return false;
        if (isActive != null && employee.isActive != isActive) return false;
        return true;
      }).toList();

      logger.i('Found ${filteredEmployees.length} employees');
      return filteredEmployees;
    } catch (e, stackTrace) {
      logger.e('Failed to search employees', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Employee?> getEmployeeDetails(String employeeId) async {
    try {
      logger.i('Fetching employee details: $employeeId');
      
      final employee = await _employeeRepository.getEmployee(employeeId);
      
      if (employee == null) {
        logger.w('Employee not found: $employeeId');
        return null;
      }

      logger.i('Employee details fetched: ${employee.firstName} ${employee.lastName}');
      return employee;
    } catch (e, stackTrace) {
      logger.e('Failed to fetch employee details', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<Employee>> getEmployeesByDepartment(String departmentId) async {
    try {
      logger.i('Fetching employees for department: $departmentId');
      
      final employees = await _employeeRepository.getEmployeesByDepartment(departmentId);
      
      logger.i('Found ${employees.length} employees in department');
      return employees;
    } catch (e, stackTrace) {
      logger.e('Failed to fetch employees by department', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
