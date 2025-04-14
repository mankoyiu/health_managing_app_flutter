import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cartprovider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('The Shopping Cart')),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return Column(
            children: [
              Expanded(child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final cartItem = cart.items[index];
                  return ListTile(
                    title: Text(cartItem.product.title),
                    subtitle: Text("Quantity: ${cartItem.quantity}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {cart.removeItem(cartItem.product);}),
  
                  );
                },
              )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Total: \$${cart.totalAmount}", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
              ElevatedButton(onPressed: (){
                cart.clear();
              }, child: Text('Checkout'))
            ]
          );
        },
      )
    );
  }
}