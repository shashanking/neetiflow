import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/repositories/employees_repository.dart';

@injectable
class EmployeeSearchService {
  final EmployeesRepository _employeeRepository;

  EmployeeSearchService(this._employeeRepository);

  Future<List<Employee>> searchEmployees({
    String? query,
    String? departmentId,
    EmployeeRole? role,
    bool? isActive,
    int limit = 20,
  }) async {
    try {
      // Implement search logic using the repository
      final employees = await _employeeRepository.searchEmployees(query ?? '', limit: limit);

      // Additional filtering based on optional parameters
      return employees.where((employee) {
        if (departmentId != null && employee.departmentId != departmentId) return false;
        if (role != null && employee.role != role) return false;
        if (isActive != null && employee.isActive != isActive) return false;
        return true;
      }).toList();
    } catch (e) {
      // Handle errors
      return [];
    }
  }
}
