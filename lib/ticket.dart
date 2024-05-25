import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // package untuk format tanggal & uang
import 'package:projek_akhir_tpm/model/celeb_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Class untuk fungsi konversi mata uang
class CurrencyConverter {
  static final _formatter =
      NumberFormat.currency(locale: 'en_US', symbol: '\$ ');

  static String formatCurrency(double amount, {String currency = 'USD'}) {
    switch (currency) {
      case 'USD':
        return _formatter.format(amount);
      case 'IDR':
        return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
            .format(amount * 16045); // 1 USD = 16045 IDR (Mei 2024)
      case 'MYR':
        return NumberFormat.currency(locale: 'ms_MY', symbol: 'RM ')
            .format(amount * 4.712); // 1 USD = 4.712 MYR (Mei of 2024)
      case 'JPY':
        return NumberFormat.currency(locale: 'ja_JP', symbol: '¥ ')
            .format(amount * 156.97); // 1 USD = 156.97 JPY (Mei 2024)
      default:
        return _formatter.format(amount);
    }
  }
}

class TicketPurchasePage extends StatefulWidget {
  final CelebModel celeb;
  final int i; //index

  const TicketPurchasePage({super.key, required this.celeb, required this.i});

  @override
  _TicketPurchasePageState createState() => _TicketPurchasePageState();
}

class _TicketPurchasePageState extends State<TicketPurchasePage> {
  String _selectedTimezone = 'WIB'; // Default timezone
  String _selectedCurrency = 'USD'; // Default currency
  int _ticketQuantity = 1; // Default ticket quantity
  bool isFavorite = false;

  // Fungsi untuk konversi waktu
  String convertTime(DateTime dateTime, String timeZone) {
    // Set time zone
    dateTime = dateTime.toUtc(); // dikonversi ke UTC
    print("UTC : $dateTime");
    switch (timeZone) {
      case 'WIB':
        dateTime = dateTime.add(Duration(hours: 7)); // UTC+7 for WIB
        print("new time : $dateTime");
        break;
      case 'WITA':
        dateTime = dateTime.add(Duration(hours: 8)); // UTC+8 for WITA
        print("new time : $dateTime");
        break;
      case 'WIT':
        dateTime = dateTime.add(Duration(hours: 9)); // UTC+9 for WIT
        print("new time : $dateTime");
        break;
      case 'London':
        dateTime = dateTime.add(Duration(hours: 1)); // UTC+1 for London
        print("new time : $dateTime");
        break;
    }
    // Format the time and return as string
    return DateFormat('dd MMMM yyyy, HH:mm')
        .format(dateTime); // Contoh format: 25 May 2024, 18:00
  }

  double getTicketPrice() {
    return 100.0; // ticket price in USD
  }

  double calculateTotalPrice() {
    return getTicketPrice() * _ticketQuantity;
  }

  //Fungsi untuk masuk ke URL
  Future<void> launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw "Couldn't launch url";
    }
  }

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    bool isAlreadyFavorite = await isDataFavorite(widget.celeb.data![widget.i].nama!);
    print('isAlreadyfavorite : $isAlreadyFavorite');
    if (isAlreadyFavorite) {
      // Data sudah dijadikan favorit sebelumnya
      setState(() {
        isFavorite = true;
      });
    } else {
      isFavorite = false;
    }
  }

  Future<bool> isDataFavorite(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil daftar nama favorit dari SharedPreferences
    List<String>? favoriteNames = prefs.getStringList('favoriteNames') ?? [];

    //mengembalikan true jika mengandung nama
    return favoriteNames.contains(name);

  }

  void saveFavoriteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil daftar favorit yang sudah ada atau buat list baru jika belum ada
    List<String>? favoriteNames = prefs.getStringList('favoriteNames') ?? [];
    List<String>? favoritePhotos = prefs.getStringList('favoritePhotos') ?? [];
    List<String>? favoriteInstagrams = prefs.getStringList('favoriteInstagrams') ?? [];

    // Tambahkan data favorit baru ke dalam daftar
    String name = widget.celeb.data![widget.i].nama!;
    String photo = widget.celeb.data![widget.i].foto!;
    String instagram = widget.celeb.data![widget.i].instagram!;

    favoriteNames.add(name);
    favoritePhotos.add(photo);
    favoriteInstagrams.add(instagram);

    // Simpan daftar favorit kembali ke SharedPreferences
    prefs.setStringList('favoriteNames', favoriteNames);
    prefs.setStringList('favoritePhotos', favoritePhotos);
    prefs.setStringList('favoriteInstagrams', favoriteInstagrams);

    print('Favorite data saved in SharedPref:');
    print(prefs.getStringList('favoriteNames'));
    print(prefs.getStringList('favoritePhotos'));
    print(prefs.getStringList('favoriteInstagrams'));
  }

  void deleteFavoriteData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil daftar favorit yang sudah ada atau buat list baru jika belum ada
    List<String>? favoriteNames = prefs.getStringList('favoriteNames') ?? [];
    List<String>? favoritePhotos = prefs.getStringList('favoritePhotos') ?? [];
    List<String>? favoriteInstagrams = prefs.getStringList('favoriteInstagrams') ?? [];

    // Cari indeks data favorit berdasarkan nama
    int index = favoriteNames.indexOf(name);
    print('hapus index ke : $index');

    // Jika data favorit dengan nama yang diberikan ditemukan, hapus dari semua daftar
    if (index != -1) {
      favoriteNames.removeAt(index);
      favoritePhotos.removeAt(index);
      favoriteInstagrams.removeAt(index);

      // Simpan daftar favorit kembali ke SharedPreferences
      prefs.setStringList('favoriteNames', favoriteNames);
      prefs.setStringList('favoritePhotos', favoritePhotos);
      prefs.setStringList('favoriteInstagrams', favoriteInstagrams);

      print('Favorite data with name $name deleted.');
    } else {
      print('Favorite data with name $name not found.');
    }

    print('Favorite data in SharedPref after remove:');
    print(prefs.getStringList('favoriteNames'));
    print(prefs.getStringList('favoritePhotos'));
    print(prefs.getStringList('favoriteInstagrams'));

  }

  void clearFavoriteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Kosongkan semua daftar favorit
    prefs.remove('favoriteNames');
    prefs.remove('favoritePhotos');
    prefs.remove('favoriteInstagrams');

    print('All favorite data cleared.');
  }

  @override
  Widget build(BuildContext context) {
    // Parsing string tanggal ke DateTime
    // String tanggalString = "2022-05-05 6:00:00";
    // DateTime parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(tanggalString);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Purchase Ticket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.pink : null,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
                print('favorite : $isFavorite');
              });
              if (isFavorite == true) {
                // Hapus Semua Data
                // clearFavoriteData();
                // Simpan data favorit ke SharedPreferences
                saveFavoriteData();
                // Logika notifikasi berhasil
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ADDED to favorites'),
                    backgroundColor: Colors.pinkAccent,
                  ),
                );
              } else if (isFavorite == false) {
                // Simpan data favorit ke SharedPreferences
                deleteFavoriteData(widget.celeb.data![widget.i].nama!);
                // Tambahkan logika notifikasi berhasil di sini
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('DELETED from favorites'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.white,
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white.withOpacity(0.7),
                  elevation: 5, // Menambahkan elevasi untuk memberikan efek shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40), // Mengatur border radius untuk tampilan yang lebih mulus
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          alignment: Alignment.center,
                          widget.celeb.data![widget.i].foto!,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Meet & Greet with ${widget.celeb.data![widget.i].nama!}',
                              style: TextStyle(
                                fontSize: 30,
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
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                launchURL(widget.celeb.data![widget.i].instagram!);
                              },
                              child: Text(
                                'Link IG: ${widget.celeb.data![widget.i].instagram!}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Event Details:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Date: 09 June 2024',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'Time: ${convertTime(DateTime(2024, 6, 9, 12, 0), _selectedTimezone)}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(width: 10),
                                DropdownButton<String>(
                                  value: _selectedTimezone,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedTimezone = newValue!;
                                    });
                                  },
                                  items: <String>['WIB', 'WITA', 'WIT', 'London']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'Currency: $_selectedCurrency',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(width: 10),
                                DropdownButton<String>(
                                  value: _selectedCurrency,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCurrency = newValue!;
                                    });
                                  },
                                  items: <String>['USD', 'IDR', 'MYR', 'JPY']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'Ticket Quantity: ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (_ticketQuantity > 1) {
                                        _ticketQuantity--;
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  '$_ticketQuantity',
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      _ticketQuantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Location: Jakarta Convention Center',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Ticket Price: ${CurrencyConverter.formatCurrency(getTicketPrice(), currency: _selectedCurrency)}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Total Price: ${CurrencyConverter.formatCurrency(calculateTotalPrice(), currency: _selectedCurrency)}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _showPaymentDialog();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  fixedSize: Size(200, 20),
                                ),
                                child: Text('Buy Ticket', style: TextStyle(color: Colors.white, fontSize: 20),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog() {
    String? selectedBank; // State variable to store selected bank

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to be full height
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              padding: EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('BRI'),
                      onTap: () {
                        setState(() {
                          selectedBank = 'BRI';
                        });
                      },
                    ),
                    ListTile(
                      title: Text('BCA'),
                      onTap: () {
                        setState(() {
                          selectedBank = 'BCA';
                        });
                      },
                    ),
                    if (selectedBank != null) // Show account number if bank is selected
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Account Number: ' +
                              (selectedBank == 'BRI'
                                  ? '80123132131'
                                  : '795021312'),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedBank != null) {
                          // Add logic for confirming payment
                          Navigator.pop(context); // Close bottom sheet

                          // Show payment confirmation notification
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text('Pembayaran dikonfirmasi'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Text('Confirm Payment'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
