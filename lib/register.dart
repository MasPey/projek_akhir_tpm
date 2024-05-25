import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projek_akhir_tpm/login.dart';
import 'package:projek_akhir_tpm/main.dart';
import 'package:projek_akhir_tpm/model/login_model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "REGISTER MENU",
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'REGISTER',
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
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.app_registration, size: 50, color: Colors.white,),
              ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height-300,  // Adjust this value to fit your layout
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
                            onPressed: () async {
                              String user = userController.text;
                              String pass = passController.text;
                              if (user.isNotEmpty && pass.isNotEmpty) {
                                final key = encrypt.Key.fromUtf8('projektpm00000000000000000000000');
                                final iv = encrypt.IV.fromUtf8("1234567890123456");
                                final encrypter = encrypt.Encrypter(encrypt.AES(key));
                                // Buka loginBox
                                var box = Hive.box<LoginModel>(loginBox);
                                // await box.clear(); // hapus semua data di box
                                if (!box.containsKey(user)) {
                                  // Tambahkan username and password to Hive
                                  final encryptedpass = encrypter.encrypt(pass, iv: iv);
                                  var newAkun = LoginModel(username: user, password: encryptedpass.base64);
                                  await box.put(user, newAkun);
                                  // box.add(LoginModel(username: user, password: pass));
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Success'),
                                      content: Text('Registration Successful'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Tutup dialog
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => LoginPage()),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );

                                } else {
                                  print("REGISTRATION FAILED");
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Username already exists!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                // print(box.keys); // print key tiap data
                                // Print all data in the box without decrypted
                                Map<dynamic, LoginModel> boxMap = box.toMap();
                                boxMap.forEach((key, value) {
                                  print('Username: $key, Password: ${value.password}');
                                });

                                // Print all data in the box with decrypted
                                boxMap.forEach((key, value) {
                                  final decryptedpass = encrypter.decrypt64(value.password, iv: iv);
                                  print('Username: $key, Password Decrypted: ${decryptedpass}');
                                });
                              } else {
                                print("REGISTRATION FAILED");
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Pastikan username dan password tidak kosong !'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text('REGISTER', style: TextStyle(color: Colors.white)),
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
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Text('LOGIN', style: TextStyle(color: Colors.pinkAccent)),
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