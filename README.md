# projek_akhir_tpm

Projek Akhir Mobile - 123210011

## ~ Buat register dan login dengan enkripsi menggunakan session (SharedPref) dan terkoneksi database (Hive)
1. tambahkan di yaml lalu pub get
   dependencies :
    encrypt: ^5.0.3 (untuk enkripsi)
    shared_preferences: ^2.2.3 (untuk session menggunakan sharedpref)
    hive_flutter: ^1.1.0 (untuk database menggunakan hive)
    hive: ^2.0.4
    path_provider: ^2.0.3
   dev_dependencies:
    hive_generator: ^1.1.0
    build_runner: ^2.1.2
2. fungsi main dibuat async + buat variabel global String loginBox = 'loginBox', lalu tambahkan
await Hive.initFlutter(); //inisialisasi
3. buat file model yang berisi object dari loginBox dan tambahkan
      part 'namafile.g.dart'; sebelum generate adapter
4. jalankan di terminal untuk generate adapter : dart run build_runner build
      jika berhasil muncul file baru namafile.g.dart
5. tambahkan di main untuk memanggil adapter yang baru saja digenerate :
     Hive.registerAdapter<LoginModel>(namaAdapter()); 
     await Hive.openBox<LoginModel>(loginBox); //openbox bernama loginBox
6. setelah selesai set up Box untuk login , sekarang cara menggunakan Box di register
   var box = Hive.box<LoginModel>(loginBox); buka box
   // Tambahkan username and password ke db/loginBox dengan key user dan password dengan enkripsi AES
   final encryptedpass = encrypter.encrypt(pass, iv: iv);
   var newAkun = LoginModel(username: user, password: encryptedpass.base64);
   await box.put(user, newAkun);
7. menggunakan Box di login untuk mengecek data di db
   var box = Hive.box<LoginModel>(loginBox);
   for (var item in box.values) {
   if (user == users.username && pass == decryptedpass) { dst
8. Membuat SharedPref bernama loginData dan membuat fungsi untuk mengecek sesi, apakah user sudah pernah login/belum
9. Jika berhasil login , Sharedpref akan menyimpan data username dan boolean newSesi : false


## Membuat API
1. Tambahkan pada dependencies .yaml: http: ^0.13.4
2. Tambahkan permission pada AndoridManifest.xml (android/app/src/main) : <uses-permission android:name="android.permission.INTERNET" />
3. Membuat BaseNetwork untuk link request dari API
4. Membuat api data source sebagai controller untung masing-masing endpoint : loadCeleb(),
5. Membuat model dengan bantuan https://tiendung01023.github.io/json_to_dart/ : CelebModel(),
6. Panggil model yang dibutuhkan

## ~ Bottom Navigation (profil, saran, logout)
1. Membuat menu profil yang menampilkan profil user (nama & gambar)
2. Membuat menu saran & kesan terkait mk tpm
3. Membuat menu logout untuk menghapus sesi / sharedPref

## ~ Menu Konversi Mata Uang dan Waktu
1. Tambahkan pada dependencies .yaml: intl: ^0.19.0 untuk format tanggal & uang
2. Buat class untuk fungsi konversi mata uang
3. Buat fungsi untuk konversi waktu
4. Pada bagian tiket terdapat launch URL, sehingga perlu : flutter pub add url_launcher (url_launcher: ^6.2.6)

## ~ Fasilitas Pencarian, Pemilihan, Notifikasi
1. Membuat showSearch untuk delegate ke pencarian favorit berdasarkan nama seleb
2. Membuat list seleb yang difavoritkan dan icon favorit , sehingga user bisa memilih list yang mau diunfavorited
3. Setelah user klik icon maka akan muncul notifikasi bahwasanya data berhasil dihapus dari daftar favorit

