import '../entities/department.dart' hide DepartmentHierarchy;
import '../entities/role.dart';

abstract class DepartmentsRepository {
  Future<List<Department>> getDepartments(String organizationId);
  Future<Department> addDepartment(Department department);
  Future<void> updateDepartment(Department department);
  Future<void> deleteDepartment(String organizationId, String departmentId);
  
  // Updated to use Role type instead of dynamic
  Future<void> updateEmployeeRole(
    String departmentId, 
    String employeeId, 
    Role role
  );
  
  Future<void> removeEmployeeFromDepartment(
    String departmentId, 
    String employeeId
  );

  // New method for real-time updates
  Stream<List<Department>> watchDepartments(String organizationId);
}
