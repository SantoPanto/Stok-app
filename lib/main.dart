import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repository/auth_repository.dart';
import 'firebase_options.dart';
import 'features/auth/views/login_view.dart';

// EKLENDİ: Inventory dosyalarının importları
import 'features/inventory/bloc/inventory_bloc.dart';
import 'features/inventory/repository/inventory_repository.dart';
import 'features/inventory/views/admin_category_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
    final inventoryRepository = InventoryRepository(); // EKLENDİ

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository)..add(AppStarted()),
        ),
        // EKLENDİ: InventoryBloc artık tüm uygulamadan erişilebilir durumda
        BlocProvider<InventoryBloc>(
          create: (context) => InventoryBloc(repository: inventoryRepository)..add(LoadCategories()),
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
          // DEĞİŞTİRİLDİ: Text('Dashboard') yerine artık Kategori yönetim paneline gidiyoruz
          return const AdminCategoryView(); 
        }

        if (state is AuthPendingApproval) {
          return const Scaffold(body: Center(child: Text('Hesabınız onay bekliyor.')));
        }

        return const LoginView(); 
      },
    );
  }
}