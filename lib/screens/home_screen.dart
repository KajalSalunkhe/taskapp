import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskapp/repo/dog_repo.dart';
import 'package:taskapp/screens/cart_screen.dart';
import 'package:taskapp/screens/history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DogApiService _apiService = DogApiService();
  String imageUrl = '';
  List<String> imageHistory = [];
  Map<String, double> cartItems = {};
  bool _isButtonEnabled = true;

  void fetchImage() async {
    try {
      final url = await _apiService.fetchRandomDogImage();
      setState(() {
        imageUrl = url;
        saveImageToHistory(url);
      });
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  void saveImageToHistory(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> imageHistory = prefs.getStringList('imageHistory') ?? [];
    imageHistory.add(url);
    await prefs.setStringList('imageHistory', imageHistory);
    print('Image History Saved: $imageHistory');
  }

  void addToCart(String url, double price) {
    setState(() {
      _isButtonEnabled = false;
    });

    SharedPreferences.getInstance().then((prefs) {
      List<String> previousItems = prefs.getStringList('imageHistory') ?? [];
      previousItems.add(url);
      print('Current Image URL: $imageUrl');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartScreen(
            previousItems: previousItems,
            currentImageUrl: url,
            currentPrice: price,
          ),
        ),
      ).then((_) {
        setState(() {
          _isButtonEnabled = true;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    clearImageHistory();
  }

  void clearImageHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('imageHistory');
    setState(() {
      imageHistory = [];
      imageUrl = '';
    });
    print('Image History Cleared');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Image Fetcher'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Card(
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                          'Click on button Fetch Image',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchImage,
              child: Text(
                'Fetch Image',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return HistoryScreen();
                    }));
                  },
                  child: Text(
                    'Check History',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    double price = 10.0;
                    addToCart(imageUrl, price);
                  },
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
