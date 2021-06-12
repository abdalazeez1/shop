import 'package:flutter/material.dart';
import './product.dart';
import 'package:max_shop/Provider/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
class Products with ChangeNotifier {
  final String _authToken;
  final String userId;
  Products(this._authToken,this._item,this.userId);
  List<Product> _item = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

//  var _showFavoritesOnly=false;
  List<Product> get favoritesItems {
    return _item.where((element) => element.isFavourite).toList();
  }

  List<Product> get item {
//    if(_showFavoritesOnly){
//      return _item.where((element) => element.isfavourite).toList();
//    }else{
    return [..._item];
  }

//  }
//  void showFavoriteOnly(){
//    _showFavoritesOnly=true;
//    notifyListeners();
//  }
//  showAll(){
//    _showFavoritesOnly=false;
//    notifyListeners();
//  }
  Product findById(String id) {
    return _item.firstWhere((element) => element.id == id);
  }

  Future<void> featchandSetDate([bool filterByUser =false]) async {
    //here we add to url &order by to filter product to every user
    final String filterString=filterByUser?'orderBy="creatorId"&equalTo="$userId"':"";
    var url =
        'https://shopazo-b8df7-default-rtdb.firebaseio.com/Products.json?auth=$_authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
//      print("dsfsdfszfcfvxzcxzcxcxzcxz");//its type Map but dart don't understand that so we put dynamic
      final List<Product> _loadedProduct = [
//        Product(
//          id: 'p1',
//          title: 'Red Shirt',
//          description: 'A red shirt - it is pretty red!',
//          price: 29.99,
//          imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//        ),
      ];
      if(extractedData==null)return;
      url =
          'https://shopazo-b8df7-default-rtdb.firebaseio.com/userFavourite/$userId.json?auth=$_authToken';
      final favouriteResponse=await http.get(url);
      final favouriteDate=json.decode(favouriteResponse.body);
      extractedData.forEach((key, value) {
        _loadedProduct.add(Product(
          id: key,
          title: value['title'],
          price: value['price'],
          isFavourite:favouriteDate==null?false:favouriteDate[key]??false,//if id for product "key" are null
          imageUrl: value['imageUrl'],
          description: value['description'],

        ));
      });
      _item = _loadedProduct;
      notifyListeners();
    } catch (error) {
      print('there are error ');
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product produc) async {
    final url =
        "https://shopazo-b8df7-default-rtdb.firebaseio.com/Products.json?auth=$_authToken";
    //we can't add return in end method because exe befor exe http and http return future and then return future we add return here
    //after call addProduct we can accses to then were we call
//    http.Response response;
    try {
      final response = await http.post(url,
//        headers:
          body: json.encode({
            "price": produc.price,
            "description": produc.description,
            "title": produc.title,
            "imageUrl": produc.imageUrl,
            "id": produc.id,
            'creatorId':userId
          }));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        price: produc.price,
        description: produc.description,
        imageUrl: produc.imageUrl,
        title: produc.title,
      );
      _item.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    //.catchError(onError) can add it but will catch error  befor it so we add after then
//      .then((response){ json.decode( response.body);

//    _item.insert(index, element);//can use it

//    _item.add(value);

//      .catchError((onError){print(onError)});
  }

  updateProduct(String id, Product product) async {
    final productid = _item.indexWhere((element) => element.id == id);
    if (productid >= 0) {
      final url =
          'https://shopazo-b8df7-default-rtdb.firebaseio.com/Products/$id.json?auth=$_authToken';
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      _item[productid] = product;
      notifyListeners();
    } else {
      print('negative');
    }
  }

  Future<void> deletproduct(String id) async{
    //can not use async because we don't understand on this we can add .catchError
    final url =
        'https://shopazo-b8df7-default-rtdb.firebaseio.com/Products/$id.json?auth=$_authToken';
    final existingProductIndex =
        _item.indexWhere((element) => element.id == id);
    var existingProduct = _item[existingProductIndex];

    _item.removeAt(existingProductIndex);
    notifyListeners();


    final response=await http.delete(url);
//      ..then((response) {  because we add async
        //when we return 200 or 300  we ok but if we have number like 400 or 500 there are error
if(response.statusCode>=400){
  item.insert(existingProductIndex, existingProduct);
  notifyListeners();
  throw HttpException("could not delete product ");
}
        existingProduct = null;


  }

}
