import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image History'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<List<String>>(
        future: getImageHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No images in history'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Image.network(snapshot.data![index]),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String>> getImageHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? imageHistory = prefs.getStringList('imageHistory');
    if (imageHistory != null) {
      print('Image History Retrieved: $imageHistory');
    } else {
      print('No Image History Found');
    }
    return imageHistory ?? [];
  }
}
