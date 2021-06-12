import 'package:flutter/material.dart';
import 'package:max_shop/Provider/cart.dart';
import '../Provider/product.dart';
import 'package:provider/provider.dart';
import '../screens/prodect_detail_screen.dart';
import '../Provider/auth.dart';

class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageURL;
//
//
//  ProductItem({this.id, this.title, this.imageURL});

  @override
  Widget build(BuildContext context) {
    //if we put
    final product = Provider.of<Product>(context, listen: false);
    final authDate=Provider.of<Auth>(context,listen: false);
    final cart=Provider.of<Cart>(context,listen: false);
    print('all rebuild'); //will not change favourite
//    final product=Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProudectDetailScreen.routeName,
                  arguments: product.id);
            },
            child: 
//                Image.asset('asset/images/jar.jpg',  fit: BoxFit.cover,),
            Hero(
tag: product.id,
              child: FadeInImage(placeholder: AssetImage('asset/images/gg.png'),
                image: NetworkImage(
                  product.imageUrl),
                   fit: BoxFit.cover
              ),
            )

         ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                    icon: Icon(product.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    onPressed: () {
                      product.toggleFavouriteState(authDate.token,authDate.userId);
                      print("consumer rebuild");
                    },
                    color: Theme.of(context).accentColor,
                  )),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added Item To Cart!'),
                duration:Duration(seconds: 2) ,
                action:SnackBarAction(
                  label: "UNDO",
                  onPressed: (){
                    cart.removeSingleItem(product.id);
                  } ,
                ) ,
              ));
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
