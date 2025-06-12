import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickcom_flutter/models/product.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  final _queryController = TextEditingController();
  final _urlController = TextEditingController();

  Uri? _validateURL(String hostname, String query) {
    try {
      return Uri.parse('$hostname/prices/$query');
    } catch (err) {
      return null;
    }
  }

  void _fetchResults(Uri url) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = "Error fetching data from server. Please try again.";
        });
        return;
      }

      final Map<String, dynamic>? prices = json.decode(response.body);

      if (prices == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final List<Product> temp = [];
      for (final item in prices.entries) {
        for (final product in item.value) {
          temp.add(
            Product(
              platform: item.key,
              price: int.parse(product['price'].replaceAll('₹', '')),
              quantity: product['quantity'],
              title: product['title'],
              imageUrl: product['image'],
            ),
          );
        }
      }

      // Sort by price - low to high
      temp.sort((a, b) => a.price.compareTo(b.price));

      setState(() {
        _isLoading = false;
        _products = temp;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Products Grid View
    Widget content = _products.isNotEmpty
        ? Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                mainAxisExtent: 300,
              ),
              itemCount: _products.length,
              itemBuilder: (ctx, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black38),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        _products[index].platform[0].toUpperCase() +
                            _products[index].platform.substring(1),
                      ),
                      if (_products[index].imageUrl != null)
                        Image.network(
                          _products[index].imageUrl!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      Text(_products[index].title, textAlign: TextAlign.center),
                      Text(_products[index].quantity),
                      Text('₹${_products[index].price.toString()}'),
                    ],
                  ),
                );
              },
            ),
          )
        : const Center(
            // Empty _products list
            child: Text("Enter an item name in the search bar above."),
          );

    // Loading indicator
    if (_isLoading) {
      content = Column(
        spacing: 12,
        children: [
          const Center(child: CircularProgressIndicator()),
          const Text(
            "All this is running on a free instance of Render. Have some patience. (50 seconds + 10 seconds worth)",
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // Error screen
    if (_error != null && _error!.isNotEmpty) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(title: Text("QuickCom")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 12,
          children: [
            // URL Bar
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                label: Text(
                  "Enter the api url hostname eg. http://192.168.1.6:5000 (don't put slash)",
                ),
              ),
            ),

            // Search Bar
            TextField(
              controller: _queryController,
              decoration: InputDecoration(
                label: Text("Type the product you want to search"),
              ),
            ),

            // Search button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    if (_urlController.text.trim().isNotEmpty &&
                        _queryController.text.trim().isNotEmpty) {
                      final url = _validateURL(
                        _urlController.text.trim(),
                        _queryController.text.trim(),
                      );
                      if (url != null) {
                        _fetchResults(url);
                        _queryController.clear();
                        _urlController.clear();
                      }
                    }
                  },
                  icon: Icon(Icons.search),
                  label: Text("Search"),
                ),
              ],
            ),
            content,
          ],
        ),
      ),
    );
  }
}
