import 'package:flutter/material.dart';
import 'package:max_shop/Provider/cart.dart';
import 'package:max_shop/Provider/products.dart';
import 'package:max_shop/screens/cart_shop_screen.dart';
import 'package:max_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:max_shop/widgets/products_grid.dart';
import '../widgets/badge.dart';

//import '../models/product.dart';
enum filterFavorites { favorites, all }

class ProductOverViewScreen extends StatefulWidget {
//  final List<Product> overLoaded ;
  static const routeName='/sdf';
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {

  var _showOnlyFavoriate = false;
  var _isinit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    //can add async and methode will return future and we must add then()

    if (_isinit) {
      setState(() {
        _isLoading = true;
      });
      try{
     Provider.of<Products>(context,listen: false).featchandSetDate().then((_) {
        setState(() {
          _isLoading = false;
        });
      });}
      catch(r){  print('in product over view');
      print(r);}
      _isinit = false;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
//    final providerContainer = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('SHOP'), actions: <Widget>[
        PopupMenuButton(
          onSelected: (filterFavorite) {
            setState(() {
              if (filterFavorite == filterFavorites.favorites) {
//              providerContainer.showFavoriteOnly();
                _showOnlyFavoriate = true;
              } else {
//              providerContainer.showAll();
                _showOnlyFavoriate = false;
              }
            });
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text('Only Favorites'),
              value: filterFavorites.favorites,
            ),
            PopupMenuItem(
              child: Text('Show All'),
              value: filterFavorites.all,
            ),
          ],
        ),
        Consumer<Cart>(
          builder: (_, cart, child) => Badge(
            value: cart.itemCount.toString(),
            child: IconButton(
                icon: child,
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.cart);
                }),
          ),
          child: Icon(Icons.shopping_cart),
        )
      ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavoriate),
    );
  }
}
