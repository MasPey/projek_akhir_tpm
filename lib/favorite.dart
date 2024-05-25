import 'package:flutter/material.dart';
import 'package:projek_akhir_tpm/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String>? favoriteNames = [];
  List<String>? favoritePhotos = [];
  List<String>? favoriteInstagrams = [];

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
    loadFavoriteData();
  }

  Future<void> loadFavoriteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteNames = prefs.getStringList('favoriteNames') ?? [];
      favoritePhotos = prefs.getStringList('favoritePhotos') ?? [];
      favoriteInstagrams = prefs.getStringList('favoriteInstagrams') ?? [];
    });
    print('Favorite data :');
    print(favoriteNames);
    print(favoritePhotos);
    print(favoriteInstagrams);
  }

  void removeFavorite(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteNames?.removeAt(index);
      favoritePhotos?.removeAt(index);
      favoriteInstagrams?.removeAt(index);
      prefs.setStringList('favoriteNames', favoriteNames!);
      prefs.setStringList('favoritePhotos', favoritePhotos!);
      prefs.setStringList('favoriteInstagrams', favoriteInstagrams!);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('DELETED from favorites'),
        backgroundColor: Colors.red,
      ),
    );

    print('Favorite data after remove:');
    print(favoriteNames);
    print(favoritePhotos);
    print(favoriteInstagrams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Celeb',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white,),
            onPressed: () {
              showSearch(context: context, delegate: FavoriteSearchDelegate(favoriteNames!, favoritePhotos!, favoriteInstagrams!));
            },
          ),
        ],
        backgroundColor: Colors.pinkAccent.shade100,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.pinkAccent.shade100,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ListTile(
                  title: Text(
                    "Daftar Seleb Favoritmu",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  trailing: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.account_box,
                      color: Colors.pinkAccent,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            color: Colors.pinkAccent.shade100,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: favoriteNames!.isEmpty
                  ? Center(child: Text("No favorites added", style: TextStyle(fontSize: 20),))
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: favoriteNames!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(favoritePhotos![index]),
                          radius: 30,
                        ),
                        title: Text(
                          favoriteNames![index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.pinkAccent.shade700,
                          ),
                        ),
                        subtitle: GestureDetector(
                          onTap: () {
                            launchURL(favoriteInstagrams![index]);
                          },
                          child: Text(
                            favoriteInstagrams![index],
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.favorite, color: Colors.pink),
                          onPressed: () {
                            removeFavorite(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

}
