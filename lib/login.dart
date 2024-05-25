import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projek_akhir_tpm/homepage.dart';
import 'package:projek_akhir_tpm/main.dart';
import 'package:projek_akhir_tpm/model/login_model.dart';
import 'package:projek_akhir_tpm/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Untuk akses nilai inputan
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // Variabel untuk mengecek apakah pengguna sudah login sebelumnya atau tidak
  late SharedPreferences loginData;
  late bool newSesi;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLoggedIn();
  }

  void checkIfAlreadyLoggedIn() async {
    loginData = await SharedPreferences.getInstance();
    newSesi = (loginData.getBool('login') ?? true);
    print("new session = $newSesi");
    if (!newSesi) {
      print("user login = ${loginData.getString('username')}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LOGIN MENU",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.pink.shade200,
              Colors.pink.shade100,
              Colors.pinkAccent.shade100,
            ],
          ),
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/564x/89/d4/c3/89d4c30655669e1a06a310393b49bd84.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.2),
                BlendMode.dstATop
            ),
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cursive',
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.pink,
                        offset: Offset(4.0, 4.0),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.login_outlined, size: 50, color: Colors.white,),
              ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height-300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          controller: userController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.black45),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pinkAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Colors.pinkAccent),
                            ),
                            filled: true,
                            fillColor: Colors.pinkAccent.withOpacity(0.1),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          controller: passController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;  // Mengubah state visibilitas teks sandi
                                });
                              },
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.black45),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pinkAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Colors.pinkAccent),
                            ),
                            filled: true,
                            fillColor: Colors.pinkAccent.withOpacity(0.1),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 32.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              String user = userController.text;
                              String pass = passController.text;
                              final key = encrypt.Key.fromUtf8('projektpm00000000000000000000000');
                              final iv = encrypt.IV.fromUtf8("1234567890123456");
                              final encrypter = encrypt.Encrypter(encrypt.AES(key));
                              var box = Hive.box<LoginModel>(loginBox);
                              for (var users in box.values) {
                                final decryptedpass = encrypter.decrypt64(users.password, iv: iv);
                                print('Username: ${users.username}, Password Decrypted: $decryptedpass');
                                if (user == users.username && pass == decryptedpass) {
                                  print("LOGIN SUCCESSFUL!");
                                  loginData.setBool('login', false);
                                  loginData.setString('username', user);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomePage()),
                                  );
                                  return;
                                }
                              }

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Incorrect username or password.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text('LOGIN', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            child: Text('REGISTER', style: TextStyle(color: Colors.pinkAccent)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
