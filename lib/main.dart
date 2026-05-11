import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // ✅ import ده
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memo/core/utlis/app_router.dart';
import 'package:memo/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:memo/features/splash/splash_screen.dart';
import 'package:memo/shared/data/memory_model.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Hive.initFlutter();
  Hive.registerAdapter(MemoryModelAdapter());
  await Hive.openBox<MemoryModel>('memories');

  FlutterNativeSplash.remove();

  runApp(
    BlocProvider(
      create: (_) => HomeCubit()..getMemories(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == AppRouter.kBottomNavView) {
          return MaterialPageRoute(builder: (_) => _GoRouterApp());
        }
        return null;
      },
    );
  }
}

class _GoRouterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
