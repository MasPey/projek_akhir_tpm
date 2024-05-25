import 'package:flutter/material.dart';
import 'package:projek_akhir_tpm/main.dart';
import 'package:projek_akhir_tpm/profile.dart';  // Anda harus membuat halaman profile
import 'package:projek_akhir_tpm/feedback.dart';  // Anda harus membuat halaman saran&kesan
import 'package:shared_preferences/shared_preferences.dart';  // Untuk logout

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    ProfilePage(),
    FeedbackPage(),
    Container(), //untuk logout
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME PAGE',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.pinkAccent.shade100,
        centerTitle: true,
        elevation: 0,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
            backgroundColor: Colors.pinkAccent.shade100,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Saran & Kesan',
            backgroundColor: Colors.pinkAccent.shade100,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
            backgroundColor: Colors.pinkAccent.shade100,
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    if (index == 2) {
      // Logout logic
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Konfirmasi Logout"),
            content: Text("Apakah anda yakin ingin logout?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                },
                child: Text("Tidak"),
              ),
              TextButton(
                onPressed: () {
                  // Lakukan logout
                  SharedPreferences.getInstance().then((logindata) {
                    logindata.setBool('login', true);
                    logindata.remove('favoriteNames');
                    logindata.remove('favoritePhotos');
                    logindata.remove('favoriteInstagrams');
                    logindata.remove('username');
                    print('All data cleared.');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MeetCelebApp()),
                    );
                  });
                },
                child: Text("Ya"),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

}
