import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Saran & Kesan',
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
                SizedBox(height: 20),
                Card(
                  color: Colors.white.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kesan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Mata kuliah Teknologi Pemrograman Mobile sangat unik. '
                              'Tugasnya sangat mantap apalagi projek akhirnya bikin mual. ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Saran',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '1. Menambahkan lebih banyak tutorial koding yang relate dengan tugas.\n'
                              '2. Memberikan lebih banyak waktu untuk tugas ataupun projek.\n'
                              '3. Mengadakan sesi diskusi untuk mendalami materi yang kompleks.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
