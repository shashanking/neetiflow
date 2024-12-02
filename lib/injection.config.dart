// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;

import 'core/providers/auth_provider.dart' as _i992;
import 'domain/repositories/auth_repository.dart' as _i716;
import 'domain/repositories/clients_repository.dart' as _i743;
import 'domain/repositories/departments_repository.dart' as _i821;
import 'domain/repositories/employees_repository.dart' as _i734;
import 'domain/repositories/operations/project_repository.dart' as _i562;
import 'domain/repositories/operations/project_template_repository.dart'
    as _i974;
import 'domain/repositories/operations_repository.dart' as _i264;
import 'domain/repositories/organization_repository.dart' as _i178;
import 'domain/services/client_service.dart' as _i132;
import 'domain/services/employee_search_service.dart' as _i84;
import 'domain/services/employee_service.dart' as _i255;
import 'domain/services/project_service.dart' as _i475;
import 'infrastructure/core/firebase_injectable_module.dart' as _i462;
import 'infrastructure/core/logger_injectable_module.dart' as _i1005;
import 'infrastructure/core/repository_injectable_module.dart' as _i1023;
import 'infrastructure/repositories/firebase_auth_repository.dart' as _i833;
import 'infrastructure/repositories/firebase_clients_repository.dart' as _i852;
import 'infrastructure/repositories/firebase_departments_repository.dart'
    as _i732;
import 'infrastructure/repositories/firebase_employees_repository.dart'
    as _i346;
import 'infrastructure/repositories/operations/operations_repository_impl.dart'
    as _i1004;
import 'infrastructure/repositories/operations/project_repository_impl.dart'
    as _i93;
import 'infrastructure/repositories/operations/project_template_repository_impl.dart'
    as _i25;
import 'infrastructure/repositories/organization_repository_impl.dart' as _i135;
import 'infrastructure/services/auth_service_impl.dart' as _i262;
import 'infrastructure/services/organization_service.dart' as _i515;
import 'infrastructure/services/secure_storage_service.dart' as _i696;
import 'injection.dart' as _i464;
import 'presentation/blocs/auth/auth_bloc.dart' as _i34;
import 'presentation/blocs/client/client_bloc.dart' as _i744;
import 'presentation/blocs/clients/clients_bloc.dart' as _i532;
import 'presentation/blocs/departments/departments_bloc.dart' as _i281;
import 'presentation/blocs/employees/employees_bloc.dart' as _i958;
import 'presentation/blocs/project/project_bloc.dart' as _i324;
import 'presentation/blocs/project_template/project_template_bloc.dart'
    as _i745;

const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final loggerInjectableModule = _$LoggerInjectableModule();
    final firebaseModule = _$FirebaseModule();
    final firebaseInjectableModule = _$FirebaseInjectableModule();
    final repositoryInjectableModule = _$RepositoryInjectableModule();
    gh.factory<_i532.ClientsBloc>(() => _i532.ClientsBloc());
    gh.singleton<_i974.Logger>(() => loggerInjectableModule.logger);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i696.SecureStorageService>(
        () => _i696.SecureStorageService());
    gh.singleton<_i457.FirebaseStorage>(
      () => firebaseInjectableModule.firebaseStorage,
      instanceName: 'firebaseStorage',
    );
    gh.singleton<_i59.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth,
      instanceName: 'firebaseAuth',
    );
    gh.singleton<_i974.FirebaseFirestore>(
      () => firebaseInjectableModule.firestore,
      instanceName: 'firestore',
    );
    gh.factory<_i732.FirebaseDepartmentsRepository>(
      () => _i732.FirebaseDepartmentsRepository(
          gh<_i974.FirebaseFirestore>(instanceName: 'firestore')),
      registerFor: {_prod},
    );
    gh.factory<_i852.FirebaseClientsRepository>(
      () => _i852.FirebaseClientsRepository(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i743.ClientsRepository>(
      () => repositoryInjectableModule.clientsRepository,
      registerFor: {_prod},
    );
    gh.lazySingleton<_i821.DepartmentsRepository>(
      () => repositoryInjectableModule.departmentsRepository,
      registerFor: {_prod},
    );
    gh.lazySingleton<_i281.DepartmentsBloc>(
      () => repositoryInjectableModule.departmentsBloc,
      registerFor: {_prod},
    );
    gh.lazySingleton<_i716.AuthRepository>(
      () => _i833.FirebaseAuthRepository(
        gh<_i59.FirebaseAuth>(instanceName: 'firebaseAuth'),
        gh<_i974.FirebaseFirestore>(instanceName: 'firestore'),
        gh<_i696.SecureStorageService>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i178.OrganizationRepository>(() =>
        _i135.OrganizationRepositoryImpl(
            gh<_i974.FirebaseFirestore>(instanceName: 'firestore')));
    gh.lazySingleton<_i734.EmployeesRepository>(
      () => _i346.FirebaseEmployeesRepository(
        gh<_i974.FirebaseFirestore>(instanceName: 'firestore'),
        gh<_i59.FirebaseAuth>(instanceName: 'firebaseAuth'),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i958.EmployeesBloc>(
        () => _i958.EmployeesBloc(gh<_i734.EmployeesRepository>()));
    gh.factory<_i255.EmployeeService>(() => _i255.EmployeeService(
        employeeRepository: gh<_i734.EmployeesRepository>()));
    gh.factory<_i34.AuthBloc>(() => _i34.AuthBloc(
          gh<_i716.AuthRepository>(),
          gh<_i974.Logger>(),
        ));
    gh.factory<_i84.EmployeeSearchService>(
        () => _i84.EmployeeSearchService(gh<_i734.EmployeesRepository>()));
    gh.factory<_i744.ClientBloc>(
        () => _i744.ClientBloc(gh<_i743.ClientsRepository>()));
    gh.lazySingleton<_i992.AuthService>(
      () => _i262.AuthServiceImpl(
        gh<_i716.AuthRepository>(),
        gh<_i696.SecureStorageService>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i132.ClientService>(() => _i132.ClientService(
          gh<String>(instanceName: 'organizationId'),
          gh<_i743.ClientsRepository>(),
        ));
    gh.lazySingleton<_i264.OperationsRepository>(
        () => _i1004.OperationsRepositoryImpl(
              gh<_i974.FirebaseFirestore>(instanceName: 'firestore'),
              gh<_i457.FirebaseStorage>(instanceName: 'firebaseStorage'),
              gh<_i716.AuthRepository>(),
              gh<_i992.AuthService>(),
            ));
    gh.lazySingleton<_i515.OrganizationService>(() => _i515.OrganizationService(
          gh<_i178.OrganizationRepository>(),
          gh<_i992.AuthService>(),
        ));
    gh.lazySingleton<_i974.ProjectTemplateRepository>(
        () => _i25.ProjectTemplateRepositoryImpl(
              gh<_i974.FirebaseFirestore>(instanceName: 'firestore'),
              gh<_i515.OrganizationService>(),
            ));
    gh.lazySingleton<_i562.ProjectRepository>(() => _i93.ProjectRepositoryImpl(
          gh<_i974.FirebaseFirestore>(instanceName: 'firestore'),
          gh<_i515.OrganizationService>(),
        ));
    gh.factory<_i745.ProjectTemplateBloc>(() => _i745.ProjectTemplateBloc(
          gh<_i974.ProjectTemplateRepository>(),
          gh<_i515.OrganizationService>(),
        ));
    gh.factory<_i475.ProjectService>(() => _i475.ProjectService(
          projectRepository: gh<_i562.ProjectRepository>(),
          employeeRepository: gh<_i734.EmployeesRepository>(),
          clientRepository: gh<_i743.ClientsRepository>(),
        ));
    gh.factory<_i324.ProjectBloc>(() => _i324.ProjectBloc(
          gh<_i264.OperationsRepository>(),
          gh<_i562.ProjectRepository>(),
        ));
    return this;
  }
}

class _$LoggerInjectableModule extends _i1005.LoggerInjectableModule {}

class _$FirebaseModule extends _i464.FirebaseModule {}

class _$FirebaseInjectableModule extends _i462.FirebaseInjectableModule {}

class _$RepositoryInjectableModule extends _i1023.RepositoryInjectableModule {}
