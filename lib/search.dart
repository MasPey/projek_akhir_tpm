import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteSearchDelegate extends SearchDelegate<String> {
  final List<String> favoriteNames;
  final List<String> favoritePhotos;
  final List<String> favoriteInstagrams;

  FavoriteSearchDelegate(this.favoriteNames, this.favoritePhotos, this.favoriteInstagrams);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
        color: Colors.pinkAccent,
      ),
    ];
  }

  // Fungsi untuk masuk ke URL
  Future<void> launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw "Couldn't launch url";
    }
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
      color: Colors.pinkAccent,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Masukkan nama seleb!',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    final results = favoriteNames.where((name) => name.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final resultIndex = favoriteNames.indexOf(results[index]);
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(favoritePhotos[resultIndex]),
              radius: 30,
            ),
            title: Text(results[index]),
            subtitle: GestureDetector(
              onTap: () {
                launchURL(favoriteInstagrams[resultIndex]);
              },
              child: Text(
                favoriteInstagrams[resultIndex],
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Masukkan nama seleb!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
        ),
      );
    }

    final suggestions = favoriteNames.where((name) => name.toLowerCase().contains(query.toLowerCase())).toList();
    print(suggestions);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestionIndex = favoriteNames.indexOf(suggestions[index]);
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(favoritePhotos[suggestionIndex]),
              radius: 30,
            ),
            title: Text(suggestions[index]),
            subtitle: GestureDetector(
              onTap: () {
                launchURL(favoriteInstagrams[suggestionIndex]);
              },
              child: Text(
                favoriteInstagrams[suggestionIndex],
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
