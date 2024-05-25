import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projek_akhir_tpm/login.dart';
import 'package:projek_akhir_tpm/model/login_model.dart';

String loginBox = 'loginBox';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<LoginModel>(LoginModelAdapter());
  await Hive.openBox<LoginModel>(loginBox);
  runApp(const MeetCelebApp());

}

class MeetCelebApp extends StatelessWidget {
  const MeetCelebApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //buang wm debug
      title: 'CelebMeet',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
