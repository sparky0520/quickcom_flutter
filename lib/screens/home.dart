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

  void _fetchResults(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final url = Uri.http('192.168.1.10:5000', '/prices/$query');

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
            ),
          );
        }
      }

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
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _products.length,
              itemBuilder: (ctx, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black38),
                  ),
                  child: Column(
                    children: [
                      Text(_products[index].platform),
                      if (_products[index].imageUrl != null)
                        Image.network(_products[index].imageUrl!),
                      Text(_products[index].title),
                      Text(_products[index].quantity),
                      Text('₹${_products[index].price.toString()}'),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.subdirectory_arrow_right),
                        label: Text("Buy Now"),
                      ),
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
      content = const Center(child: CircularProgressIndicator());
    }

    // Error screen
    if (_error != null && _error!.isNotEmpty) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(title: Text("QuickCom")),
      body: Container(
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 12,
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      decoration: InputDecoration(
                        label: Text("Type the product you want to search"),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      if (_queryController.text.trim().isNotEmpty) {
                        _fetchResults(_queryController.text.trim());
                        _queryController.clear();
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
      ),
    );
  }
}
