import 'package:flutter/cupertino.dart';

class CartItem {
  @required
  final String id;
  @required
  final String title;
  @required
  final int quantitiy;
  @required
  final double price;

  CartItem({this.id, this.title, this.quantitiy, this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get item {
    return {..._item};
  }

  int get itemCount {
    return _item.length;
  }

  double get totalAmount {
    var total = 0.0;
    _item.forEach((key, value) {
      total += value.price * value.quantitiy;
    });
    return total;
  }

  void addItem(String productid, double price, String title) {
    if (_item.containsKey(productid)) {
      _item.update(productid, (value) =>
          CartItem(
              id: value.id,
              price: value.price,
              title: value.title,
              quantitiy: value.quantitiy + 1));
    } else {
      _item.putIfAbsent(
          productid,
              () =>
              CartItem(
                  id: DateTime.now().toString(),
                  title: title,
                  price: price,
                  quantitiy: 1));
    }
    notifyListeners();
  }

  void remove(String productid) {
    _item.remove(productid);
    notifyListeners();
  }

  void clear() {
    _item = {};
    notifyListeners();
  }

  void removeSingleItem(String productid) {
    if (!_item.containsKey(productid)) {
      return;
    }
    if (_item[productid].quantitiy > 1) {
      _item.update(productid, (value) =>
          CartItem(id: value.id,
            title: value.title,
            price: value.price,
            quantitiy: value.quantitiy - 1,));

    }
    else{
      _item.remove(productid);
    }
  }
}
