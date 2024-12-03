import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shopingapp/core/services/dependency_injection.dart';
import 'package:shopingapp/features/data/model/response/items_response_model.dart';
import 'package:shopingapp/features/presentation/bloc/home/home_cubit.dart';
import 'package:shopingapp/utils/app_colors.dart';
import 'package:shopingapp/utils/navigation_routes.dart';

import '../shopping_cart/shopping_cart_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _bloc = injection.call<HomeCubit>();

  List<ItemsResponseModel>? items;

  int selectedItemCount = 0;

  void toggleItemSelection(int index) {
    setState(() {
      items![index].isSelected = !items![index].isSelected!;
      selectedItemCount = items!.where((item) => item.isSelected!).length;
    });
  }

  @override
  void initState() {
    _bloc.getAllItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Shopping Items",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    InkWell(
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                      onTap: () {
                        final selectedItems =
                            items!.where((item) => item.isSelected!).toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShoppingCart(
                              shoppingCartArgs: ShoppingCartArgs(
                                items: selectedItems,
                                onItemRemoved: (removedItem) {
                                  setState(() {
                                    items!
                                        .firstWhere(
                                            (item) => item.id == removedItem.id)
                                        .isSelected = false;
                                    selectedItemCount = items!
                                        .where((item) => item.isSelected!)
                                        .length;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (selectedItemCount > 0)
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$selectedItemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.kUserProfileView);
                  },
                ),
              ],
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is GetAllDataSuccessState) {
              setState(() {
                items = state.list;
              });
            }
          },
          child: items != null
              ? RefreshIndicator(
                  onRefresh: () => _bloc.getAllItem(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: items!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => toggleItemSelection(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: items![index].isSelected!
                                  ? Colors.green[100]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: items![index].isSelected!
                                    ? Colors.green
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  items![index].isSelected!
                                      ? Icons.add_shopping_cart_outlined
                                      : Icons.shopping_cart,
                                  color: items![index].isSelected!
                                      ? Colors.green
                                      : Colors.black,
                                  size: 40,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 20.w,
                                  child: Text(
                                    maxLines: 2,
                                    items![index].title!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: items![index].isSelected!
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.colorSecondary,
                    strokeAlign: 2,
                    strokeWidth: 4,
                  ),
                ),
        ),
      ),
    );
  }
}

class Item {
  String name;
  bool isSelected;

  Item(this.name, this.isSelected);
}
