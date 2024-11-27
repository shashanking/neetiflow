import '../entities/department.dart';

abstract class DepartmentsRepository {
  Future<List<Department>> getDepartments(String organizationId);
  Future<Department> addDepartment(Department department);
  Future<void> updateDepartment(Department department);
  Future<void> deleteDepartment(String organizationId, String departmentId);
  Future<void> updateEmployeeRole(String departmentId, String employeeId, DepartmentRole role);
  Future<void> removeEmployeeFromDepartment(String departmentId, String employeeId);
}
