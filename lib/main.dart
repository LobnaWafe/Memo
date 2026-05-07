import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:memo/core/app_colors.dart';
import 'package:memo/core/utlis/app_router.dart';
import 'package:memo/shared/data/memory_model.dart';


void main() async{
    WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MemoryModelAdapter());

  await Hive.openBox<MemoryModel>('memories');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
     
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}