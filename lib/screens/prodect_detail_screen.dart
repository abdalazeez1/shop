import 'package:flutter/material.dart';
import 'package:max_shop/Provider/products.dart';
import 'package:provider/provider.dart';

class ProudectDetailScreen extends StatelessWidget {
  static const routeName = '/product-details ';

  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;
    final lodedProduct =
        Provider.of<Products>(context, listen: false).findById(productid);

    return Scaffold(
//      appBar: AppBar(
//        title: Text('${lodedProduct.title}'),
//      ),
      body: CustomScrollView(
        //because we need to more controller on scroll  and we won't to appbar
        //thing cna scroll is slivers
        slivers: [
          //is the thing will change dynamic
          SliverAppBar(
            expandedHeight: 300,
            pinned: true, //it's visible always when scroll
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${lodedProduct.title}'),
              background: Hero(
                tag: lodedProduct.id,
                child: Image.network(
                  lodedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ), //this the thing will seen when scroll  it's stay hidden
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
            [
              Text(
                '\$${lodedProduct.price}',
                style: TextStyle(fontSize: 20, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  lodedProduct.description,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 800,),
            ],
          ) //it's know how to display content screen
              )
        ],
      ),
    );
  }
}
