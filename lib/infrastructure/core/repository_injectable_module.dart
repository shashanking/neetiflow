import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/repositories/clients_repository.dart';
import 'package:neetiflow/domain/repositories/departments_repository.dart';
import 'package:neetiflow/infrastructure/repositories/firebase_clients_repository.dart';
import 'package:neetiflow/infrastructure/repositories/firebase_departments_repository.dart';
import 'package:neetiflow/injection.dart';
import 'package:neetiflow/presentation/blocs/departments/departments_bloc.dart';

@module
@Environment(Environment.prod)
abstract class RepositoryInjectableModule {
  @lazySingleton
  @Environment(Environment.prod)
  ClientsRepository get clientsRepository => FirebaseClientsRepository();

  @lazySingleton
  @Environment(Environment.prod)
  DepartmentsRepository get departmentsRepository =>
      FirebaseDepartmentsRepository(
        getIt.get(instanceName: 'firestore'),
      );

  @lazySingleton
  @Environment(Environment.prod)
  DepartmentsBloc get departmentsBloc => DepartmentsBloc(
        departmentsRepository: getIt<DepartmentsRepository>(),
      );
}
