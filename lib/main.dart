import 'package:flutter/material.dart';
import 'package:hive_task_manager/Model/userModel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Pages/HiveDBPage.dart';

///flutter packages pub run build_runner build --delete-conflicting-outputs
///git clone https://<username>:<githubtoken>@github.com/<username>/<repositoryname>.git

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive DB CRUD',
      home: HiveDBPage(),
    );
  }
}
