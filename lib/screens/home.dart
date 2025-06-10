import 'package:flutter/material.dart';
import 'package:quickcom_flutter/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _queryController = TextEditingController();
  final List<Product> _products = [];

  void _fetchResults(String query) async {
    // await
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QuickCom")),
      body: Container(
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 12,
            children: [
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
                      final t = _queryController.text.trim();
                      if (t.isNotEmpty) {
                        _fetchResults(t);
                      }
                    },
                    icon: Icon(Icons.search),
                    label: Text("Search"),
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black38),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Text(_products[index].platform),

                          if (_products[index].imageUrl != null)
                            Image.network(_products[index].imageUrl!),

                          Text(_products[index].title),
                          Text(_products[index].quantity),
                          Text("₹${_products[index].price}"),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
