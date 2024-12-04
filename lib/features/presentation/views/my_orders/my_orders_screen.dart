import 'package:flutter/material.dart';
import 'package:shopingapp/features/data/datasources/shared_preference.dart';
import 'package:shopingapp/features/presentation/bloc/my_orders/my_orders_cubit.dart';

import '../../../../core/services/dependency_injection.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final _bloc = injection.call<MyOrdersCubit>();
  final appShared = injection.call<AppSharedData>();

  @override
  void initState() {
    _bloc.retrieveData(appShared.getData(uID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 0,
        // automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "My Orders",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: ListView(
        children: storeData.entries.map((entry) {
          String day = entry.key;
          List<Map<String, dynamic>> items = entry.value;

          return ExpansionTile(
            title: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            children: items.map((item) {
              return ListTile(
                title: Text(item['name']),
                subtitle: Text(item['description']),
                trailing: Text("\$${item['price']}"),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  final Map<String, List<Map<String, dynamic>>> storeData = {
    "2024-12-01": [
      {"name": "Product A", "description": "Description A", "price": 50},
      {"name": "Product B", "description": "Description B", "price": 75},
    ],
    "2024-12-02": [
      {"name": "Product C", "description": "Description C", "price": 100},
      {"name": "Product D", "description": "Description D", "price": 125},
      {"name": "Product E", "description": "Description E", "price": 150},
    ],
    "2024-12-03": [
      {"name": "Product F", "description": "Description F", "price": 200},
    ],
  };
}
