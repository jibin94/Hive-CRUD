import 'package:hive/hive.dart';
import 'Model/user_model.dart';

class Boxes {
  static Box<UserModel> getUsers() => Hive.box('hive_users');
}
