import '../entities/role.dart';

abstract class RolesRepository {
  Future<List<Role>> getRoles(String organizationId);
  
  Stream<List<Role>> rolesStream(String organizationId);
  
  Future<Role> addRole(Role role);
  
  Future<void> updateRole(Role role);
  
  Future<void> deleteRole(String organizationId, String roleId);
  
  Future<Role?> getRoleById(String organizationId, String roleId);
  
  Future<List<Role>> getRolesByType(String organizationId, RoleType type);
  
  Future<void> assignRoleToEmployee(
    String organizationId,
    String roleId,
    String employeeId,
    {String? departmentId}
  );
  
  Future<void> removeRoleFromEmployee(
    String organizationId,
    String roleId,
    String employeeId,
    {String? departmentId}
  );
  
  Stream<List<Role>> watchRoles(String organizationId);
}
