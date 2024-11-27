import 'package:neetiflow/domain/entities/employee.dart';

abstract class EmployeesRepository {
  Future<List<Employee>> getEmployees(String companyId);
  Future<Employee> addEmployee(Employee employee, String password);
  Future<void> updateEmployee(Employee employee);
  Future<void> deleteEmployee(String employeeId, String companyId);
  Future<void> updateEmployeeStatus(String employeeId, String companyId, bool isActive);
  Stream<List<Employee>> employeesStream(String companyId);
  Stream<Employee> employeeStream(String companyId, String employeeId);
  Future<bool> isEmailAvailable(String email);
}
