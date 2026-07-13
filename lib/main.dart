import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repository/auth_repository.dart';
import 'firebase_options.dart'; // Firebase platform ayarları için gerekli
import 'features/auth/views/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Windows/Mobil ayrımı için bu options kısmı şarttır
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository)..add(AppStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Stock App',
        theme: AppTheme.lightTheme,
        home: const InitialRouteHandler(),
      ),
    );
  }
}

class InitialRouteHandler extends StatelessWidget {
  const InitialRouteHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const Scaffold(body: Center(child: Text('Dashboard')));
        }

        if (state is AuthPendingApproval) {
          return const Scaffold(body: Center(child: Text('Pending Approval')));
        }

        // Eğer login_view.dart'ı oluşturup yukarıda import ettiysen, Text yerine const LoginView() döndürebilirsin.
        return const Scaffold(body: Center(child: LoginView())); 
      },
    );
  }
}