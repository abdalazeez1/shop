import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String description;
  final double price;
  final String title;
  final String imageUrl;
  bool isFavourite=false;

  Product(
      {@required this.id,
      @required this.description,
      @required this.price,
      @required this.title,
      @required this.imageUrl,
      this.isFavourite =false});

  Future<void> toggleFavouriteState(String token,String userId) async {
    final oldStatues = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    //like set state
    final url =
        'https://shopazo-b8df7-default-rtdb.firebaseio.com/userFavourite/$userId/$id.json?auth=$token';
    try {
      await http.put(url,
          body: json.encode(
            isFavourite
//            'isFavourite': isFavourite,  we send true or false and we remove patch  to put in request
          ));
//      isFavourite = oldStatues;
      notifyListeners();
      //can add in method to shortcut
    } catch (error) {
      isFavourite = oldStatues;
      notifyListeners();
    }
  }
}
