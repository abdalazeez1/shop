import 'package:flutter/material.dart';
import 'package:max_shop/main.dart';
import 'package:max_shop/screens/user_product_screen.dart';
import '../screens/order_screen.dart';
import 'package:provider/provider.dart';
import '../Provider/auth.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(title: Text('hallo friend'),
        automaticallyImplyLeading: false,
        ) // never add butto
        ,Divider(),
        ListTile(leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: (){
            Navigator.pushReplacementNamed(context,MyHomePage.myHomepage);
          },),
        ListTile(leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: (){
            Navigator.pushReplacementNamed(context,OrderScreen.routeName);
          },),
        ListTile(leading: Icon(Icons.edit),
          title: Text('Manage Product'),
          onTap: (){
            Navigator.pushReplacementNamed(context,UserProductScreen.routeName);
          },),
        ListTile(leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: (){

           Provider.of<Auth>(context,listen: false).logOut();
           Navigator.of(context).pop();
          },)// n for back
      ],),
    );
  }
}
