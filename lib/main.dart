import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:neetiflow/domain/repositories/auth_repository.dart';
import 'package:neetiflow/domain/repositories/clients_repository.dart';
import 'package:neetiflow/domain/repositories/employees_repository.dart';
import 'package:neetiflow/infrastructure/services/secure_storage_service.dart';
import 'package:neetiflow/injection.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/clients/clients_bloc.dart';
import 'package:neetiflow/presentation/blocs/custom_fields/custom_fields_bloc.dart';
import 'package:neetiflow/presentation/pages/splash/splash_page.dart';
import 'package:neetiflow/presentation/pages/auth/login_page.dart';
import 'package:neetiflow/data/repositories/custom_fields_repository.dart';
import 'package:neetiflow/data/repositories/employee_timeline_repository.dart';
import 'package:neetiflow/data/repositories/leads_repository.dart';
import 'package:neetiflow/presentation/blocs/departments/departments_bloc.dart';
import 'package:neetiflow/presentation/blocs/employee_status/employee_status_bloc.dart';
import 'package:neetiflow/presentation/blocs/employees/employees_bloc.dart';
import 'package:neetiflow/presentation/blocs/password_reset/password_reset_bloc.dart';
import 'package:neetiflow/presentation/blocs/project/project_bloc.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    debugPrint(
        'Initializing Firebase with options: ${DefaultFirebaseOptions.currentPlatform}');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');

    // Initialize dependency injection with production environment
    configureInjection(Environment.prod);
  } catch (e, stackTrace) {
    debugPrint('Failed to initialize Firebase: $e');
    debugPrint('Stack trace: $stackTrace');
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  double _getTextScaleFactor(double width) {
    if (width >= 1200) return 1.0;
    if (width >= 800) return 0.95;
    return 0.9;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EmployeesRepository>(
          create: (context) => GetIt.I<EmployeesRepository>(),
        ),
        Provider<AuthRepository>(
          create: (context) => GetIt.I<AuthRepository>(),
        ),
        Provider<ClientsRepository>(
          create: (context) => GetIt.I<ClientsRepository>(),
        ),
        Provider(
          create: (context) => GetIt.I<SecureStorageService>(),
        ),
        RepositoryProvider<EmployeeTimelineRepository>(
          create: (context) => EmployeeTimelineRepositoryImpl(),
        ),
        RepositoryProvider<CustomFieldsRepository>(
          create: (context) {
            final authState = context.read<AuthBloc>().state;
            if (authState is! Authenticated) {
              throw Exception('User must be authenticated to access CustomFieldsRepository');
            }
            return CustomFieldsRepository(
              organizationId: authState.employee.companyId ?? '',
            );
          },
        ),
        RepositoryProvider<LeadsRepository>(
          create: (context) => LeadsRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          //employe timelinebloc missing
          BlocProvider<AuthBloc>(
            create: (context) => GetIt.I<AuthBloc>(),
          ),
          BlocProvider<EmployeesBloc>(
            create: (context) => GetIt.I<EmployeesBloc>(),
          ),
          BlocProvider<ClientsBloc>(
            create: (context) => GetIt.I<ClientsBloc>(),
          ),
          BlocProvider<DepartmentsBloc>(
            create: (context) => GetIt.I<DepartmentsBloc>(),
          ),
          BlocProvider<EmployeeStatusBloc>(
            create: (context) => GetIt.I<EmployeeStatusBloc>(),
          ),
          BlocProvider<PasswordResetBloc>(
            create: (context) => GetIt.I<PasswordResetBloc>(),
          ),
          BlocProvider<ProjectBloc>(
            create: (context) => GetIt.I<ProjectBloc>(),
          ),
          BlocProvider<CustomFieldsBloc>(
            create: (context) => GetIt.I<CustomFieldsBloc>(),
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            return MaterialApp(
              title: 'NeetiFlow',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF2C3E50),
                  primary: const Color(0xFF2C3E50),
                  secondary: const Color(0xFF3498DB),
                  surface: Colors.white,
                  background: const Color(0xFFF5F6F9),
                ),
                fontFamily: 'Noto Sans',
                cardTheme: const CardTheme(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(kIsWeb ? 16 : 12)),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kIsWeb ? 12 : 8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kIsWeb ? 12 : 8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kIsWeb ? 12 : 8),
                    borderSide:
                        const BorderSide(color: Color(0xFF2C3E50), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kIsWeb ? 12 : 8),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: kIsWeb ? 16 : 12,
                    vertical: kIsWeb ? 16 : 12,
                  ),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: kIsWeb ? 32 : 24,
                      vertical: kIsWeb ? 16 : 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kIsWeb ? 12 : 8),
                    ),
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kIsWeb ? 32 : 24,
                      vertical: kIsWeb ? 16 : 12,
                    ),
                  ),
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                platform: Theme.of(context).platform,
              ),
              builder: (context, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor:
                            _getTextScaleFactor(constraints.maxWidth),
                      ),
                      child: child!,
                    );
                  },
                );
              },
              initialRoute: '/',
              routes: {
                '/': (context) => const SplashPage(),
                '/login': (context) => const LoginPage(),
              },
            );
          },
        ),
      ),
    );
  }
}
