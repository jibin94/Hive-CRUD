import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0) // This is model Class Type ID
class UserModel extends HiveObject {
  @HiveField(0) //This is Field Index
  late String userId;

  @HiveField(1) //This is Field Index
  late String userName;

  @HiveField(2) //This is Field Index
  late String email;
}
