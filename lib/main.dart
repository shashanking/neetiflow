import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:neetiflow/domain/repositories/auth_repository.dart';
import 'package:neetiflow/infrastructure/repositories/firebase_auth_repository.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/pages/splash/splash_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => FirebaseAuthRepositoryImpl(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        ),
        child: MaterialApp(
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
                borderRadius: BorderRadius.all(Radius.circular(kIsWeb ? 16 : 12)),
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
                borderSide: const BorderSide(color: Color(0xFF2C3E50), width: 2),
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
                    textScaler: TextScaler.linear(_getTextScaleFactor(constraints.maxWidth)),
                  ),
                  child: child!,
                );
              },
            );
          },
          home: const SplashPage(),
        ),
      ),
    );
  }

  double _getTextScaleFactor(double width) {
    if (width < 360) return 0.8; // Small mobile devices
    if (width < 600) return 1.0; // Regular mobile devices
    if (width < 1024) return 1.1; // Tablets
    return 1.2; // Desktop and large screens
  }
}
