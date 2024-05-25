import 'package:hive_flutter/hive_flutter.dart';

part 'login_model.g.dart';

@HiveType(typeId: 1)
class LoginModel extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  LoginModel({required this.username, required this.password});
}