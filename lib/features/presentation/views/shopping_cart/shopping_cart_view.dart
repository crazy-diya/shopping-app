import 'package:flutter/material.dart';
import 'package:shopingapp/features/data/model/response/items_response_model.dart';
import 'package:shopingapp/utils/app_colors.dart';

import '../home/home_screen.dart';

class ShoppingCartArgs {
  final List<ItemsResponseModel> items;
  final Function(ItemsResponseModel) onItemRemoved;

  ShoppingCartArgs({required this.items, required this.onItemRemoved});
}

class ShoppingCart extends StatefulWidget {
  final ShoppingCartArgs shoppingCartArgs;

  ShoppingCart({required this.shoppingCartArgs});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  late List<ItemsResponseModel> cartItems;
  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    cartItems =
        List.from(widget.shoppingCartArgs.items); // Create a copy to work with
  }

  void removeItem(ItemsResponseModel item) {
    setState(() {
      cartItems.remove(item);
    });
    widget.shoppingCartArgs
        .onItemRemoved(item); // Notify HomePage about the removal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text('No items in the cart.'))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(cartItems[index].title!),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_shopping_cart,
                              color: Colors.red),
                          onPressed: () => removeItem(cartItems[index]),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Amount is : $totalAmount",
            style: const TextStyle(color: AppColors.removeColorRed, fontSize: 22),
          )
        ],
      ),
    );
  }
}
