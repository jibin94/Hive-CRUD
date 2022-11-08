
import 'package:hive/hive.dart';

import 'Model/userModel.dart';

class Boxes {
  static Box<UserModel> getUsers()=> Hive.box('users');
}