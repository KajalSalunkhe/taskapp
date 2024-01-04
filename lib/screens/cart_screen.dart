import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<String> previousItems;
  final String currentImageUrl;
  final double currentPrice;

  CartScreen({
    required this.previousItems,
    required this.currentImageUrl,
    required this.currentPrice,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<String> allItems;
  late Map<String, double> itemPrices;

  @override
  void initState() {
    super.initState();
    allItems = List.from(widget.previousItems);
    if (!allItems.contains(widget.currentImageUrl)) {
      allItems.add(widget.currentImageUrl);
    }

    itemPrices = Map<String, double>.fromEntries(
      allItems.map((item) {
        final index = allItems.indexOf(item);
        if (item == widget.currentImageUrl) {
          return MapEntry(item, widget.currentPrice);
        }
        return MapEntry(item,
            index < widget.previousItems.length ? 0.0 : widget.currentPrice);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Screen'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Items in Cart:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: allItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Image.network(
                        allItems[index],
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text('Dog Image'),
                      subtitle: Text(
                        'Price: \$${itemPrices[allItems[index]]!.toStringAsFixed(2)}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
