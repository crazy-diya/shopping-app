import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shopingapp/features/data/model/response/items_response_model.dart';
import 'package:shopingapp/utils/app_colors.dart';
import 'package:shopingapp/utils/navigation_routes.dart';

import '../../../../core/services/dependency_injection.dart';
import '../../bloc/my_orders/my_orders_cubit.dart';
import '../home/home_screen.dart';

class ShoppingCartArgs {
  final List<ItemsResponseModel> items;
  final Function(ItemsResponseModel) onItemRemoved;

  ShoppingCartArgs({required this.items, required this.onItemRemoved});
}

class ShoppingCart extends StatefulWidget {
  final ShoppingCartArgs shoppingCartArgs;

  const ShoppingCart({super.key, required this.shoppingCartArgs});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final _bloc = injection.call<MyOrdersCubit>();

  late List<ItemsResponseModel> cartItems;
  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    cartItems = List.from(widget.shoppingCartArgs.items);
    calculateTotalAmount();
  }

  void removeItem(ItemsResponseModel item) {
    setState(() {
      cartItems.remove(item);
      totalAmount -= item.price!;
    });
    widget.shoppingCartArgs.onItemRemoved(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocListener<MyOrdersCubit, MyOrdersState>(
          listener: (context, state) {
            if (state is MyOrderSuccessState) {
              Navigator.pushNamedAndRemoveUntil(
                context, Routes.kHomeView, (route) => false,);
            }
          },
          child: Column(
            children: [
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(child: Text('No items in the cart.'))
                    : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(cartItems[index].title!),
                        trailing: InkWell(
                          onTap: () => removeItem(cartItems[index]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Rs. ${cartItems[index].price}",
                                style: const TextStyle(
                                    color: AppColors.addColorRed),
                              ),
                              const Icon(Icons.delete, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Total Amount is : ",
                style: TextStyle(color: AppColors.removeColorRed, fontSize: 22),
              ),
              Text(
                "Rs .$totalAmount",
                style:
                const TextStyle(color: AppColors.fontColorWhite, fontSize: 32),
              ),
              SizedBox(
                height: 2.h,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (cartItems.isNotEmpty) _bloc.storeShoppingItems(cartItems);
                },
                child: const Text(
                  "Buy",
                  style: TextStyle(color: AppColors.colorBlack, fontSize: 32),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateTotalAmount() {
    for (var element in cartItems) {
      totalAmount += element.price!;
    }
    setState(() {});
  }
}
