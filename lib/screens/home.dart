import 'package:flutter/material.dart';
import 'package:quickcom_flutter/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> _products = [
    Product(
      platform: "Blinkit",
      price: 12,
      quantity: "quantity",
      title: "title",
    ),
    Product(
      platform: "Blinkit",
      price: 12,
      quantity: "quantity",
      title: "title",
    ),
    Product(
      platform: "Blinkit",
      price: 12,
      quantity: "quantity",
      title: "title",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: _products.length,
        itemBuilder: (ctx, index) {
          return GridTile(
            child: Column(
              spacing: 12,
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
    );
  }
}
