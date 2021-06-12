import './cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  Orders(this._orders,this.authToken,this.userId);

  List<OrderItem> _orders = [];

  List<OrderItem> get order {
    return [..._orders];
  }

  Future<void> addORder(List<CartItem> cartProduct, double total) async{
    final tamesTamp=DateTime.now();
    final url =
        "https://shopazo-b8df7-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken";
   final response =await http.post(url,body: json.encode(
    {
      'amount':total,
      'dateTime':tamesTamp.toIso8601String(),
      'product':cartProduct.map((e) => {
        'id':e.id,
        'title':e.title,
        'price':e.price,
        'quantity':e.quantitiy
    }).toList()

    }

    ));
    _orders.insert(0,  OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: tamesTamp,
        products: cartProduct));
    notifyListeners();
  }
  Future<void> fetchAndSetOrders()async{
    final url =
        'https://shopazo-b8df7-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken';
final response=await http.get(url);
final List<OrderItem> loadedOrders=[];
final extractDate=json.encode(response.body)as Map<String,dynamic>;

if(extractDate==null)return;
extractDate.forEach((key, value) {
  OrderItem(
    id: key,
    amount: value['amount'],
    dateTime: DateTime.parse(value['dateTime']),
    products: (value['product'] as List<dynamic>).map((item) => CartItem(
      // before we can print response,bode and see hoe form date json
      id: item['id'],
      price: item['price'],
      title: item['title']
        ,quantitiy: item['quantity']
    )).toList()
  );
});
_orders=loadedOrders.reversed.toList();//can try
notifyListeners();
  }
}
