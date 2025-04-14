import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cartprovider.dart';
import '../models/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart' as badges;

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: 1, 
      title: 'Sterile Cotton Gauze Swab 10cm x 10cm 6s', 
      description: 'Cleans & protects wound; Can be used as a dressing; 100% Cotton', 
      price: 25.00,
      imageUrl: ""),
      
    Product(
      id: 2, 
      title: 'ars-Cov-2/Influenza A&B/Rsv And Adenovirus 5 In 1 Antigen Rapid Test 1pc', 
      description: 'Sensitivity, accuracy, and specificity is 99% and above', 
      price: 50.00,
      imageUrl: ""),
  ];

  // Toast Message while added any item
  void _addToCart(BuildContext context, Product product) {
    Provider.of<CartProvider>(context, listen: false).addItem(product);
    Fluttertoast.showToast(
      msg: "${product.title} added to shopping cart",
      toastLength: Toast.LENGTH_SHORT
    );
  }
  //

  int _totalItem(CartProvider cart) {
    int total = 0;
    for(var item in cart.items){
      total += item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return badges.Badge(
                badgeContent: Text(
                  _totalItem(cart).toString(),
                  style: TextStyle(color: Colors.white)),
                position: badges.BadgePosition.topEnd(top:0, end:3),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: (){
                    Navigator.pushNamed(context, '/cart');
                  }, )
              );
            }
          )
        ]
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(

            title: Text(product.title),
            subtitle: Text("${product.description} - \$${product.price}"),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                // Provider
                //   .of<CartProvider>(context, listen: false).addItem(product);
                _addToCart(context, product);
              },
            ),
          );
        }
      )
    );
  }
}