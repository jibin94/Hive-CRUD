import 'package:flutter/material.dart';
import 'package:hive_task_manager/Model/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Pages/home_page.dart';

///flutter clean
///dart run build_runner doctor
///dart run build_runner build --delete-conflicting-outputs

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('hive_users');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HiveDBPage(),
    );
  }
}
