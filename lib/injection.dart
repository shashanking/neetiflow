import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:neetiflow/injection.config.dart';
import 'package:neetiflow/data/repositories/custom_fields_repository.dart';
import 'package:neetiflow/presentation/blocs/custom_fields/custom_fields_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: true,
)
void configureInjection(String environment) {
  getIt.$initGetIt(environment: environment);
}

@module
abstract class FirebaseModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}

@module
abstract class FirestoreModule {
  @lazySingleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;
}

@module
abstract class RepositoryModule {
  @injectable
  CustomFieldsRepository customFieldsRepository(
    FirebaseFirestore firestore,
  ) {
    return CustomFieldsRepository(
      organizationId: 'your-org-id', 
      firestore: firestore
    );
  }
}

@module
abstract class BlocModule {
  @injectable
  CustomFieldsBloc customFieldsBloc(
    CustomFieldsRepository repository,
  ) {
    return CustomFieldsBloc(
      Object(), 
      'default', 
      'your-org-id', 
      repository: repository
    );
  }
}
