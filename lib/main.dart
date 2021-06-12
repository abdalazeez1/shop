import 'package:flutter/material.dart';
import 'package:max_shop/Provider/orders.dart';
import 'package:max_shop/screens/4.1%20auth_screen.dart';
import 'package:max_shop/screens/cart_shop_screen.dart';
import 'package:max_shop/screens/order_screen.dart';
import 'package:max_shop/screens/products_overview_screen.dart';
import 'package:max_shop/screens/user_product_screen.dart';
import './screens/prodect_detail_screen.dart';
import './Provider/products.dart';
import 'package:provider/provider.dart';
import './Provider/cart.dart';
import './screens/order_screen.dart';
import './screens/edit_product_screen.dart';
import './Provider/auth.dart';

void main() {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProduct) => Products(
                auth.token,
                previousProduct == null ? [] : previousProduct.item,
                auth.userId),
          ),

          ChangeNotifierProvider(
            create: (_) => Cart(),
          ),
//          ChangeNotifierProvider.value(
//            value: Orders(),
//          )to use constructor
          ChangeNotifierProxyProvider<Auth, Orders>(

              update: (ctx, auth, previousOrders) => Orders(
                  previousOrders == null ? [] : previousOrders.order ?? [],
                  auth.token,
                  auth.userId)),
        ],

        child: Consumer<Auth>(

          builder: (ctx, auth, _) => MaterialApp(

              theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: 'lato'),
              home: auth.isAuth ? ProductOverViewScreen() : AuthScreen(),
              routes: {
                ProductOverViewScreen.routeName: (_) => ProductOverViewScreen(),
                CartScreen.cart: (ctx) => CartScreen(),
                ProudectDetailScreen.routeName: (ctx) => ProudectDetailScreen(),
                MyHomePage.myHomepage: (_) => MyHomePage(),
                OrderScreen.routeName: (_) => OrderScreen(),
                UserProductScreen.routeName: (_) => UserProductScreen(),
                EditProductScreen.routName: (ctx) => EditProductScreen(),
              },)

        )),
  );
}

class MyHomePage extends StatelessWidget {
  static String myHomepage = './';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductOverViewScreen(),
    );
  }
}
//the propleme in auth with log out and app drawer when we log out dont work