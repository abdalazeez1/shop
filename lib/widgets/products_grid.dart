import 'package:flutter/material.dart';
import 'package:max_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../Provider/products.dart';

class ProductGrid extends StatelessWidget {
final bool showFgs;

ProductGrid(this.showFgs); //  final List<Product> overLoaded;

  @override
  Widget build(BuildContext context) {

    final Productdata=Provider.of<Products>(context);
    final products=showFgs?Productdata.favoritesItems:Productdata.item;
    return GridView.builder(
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 2,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
          value:products[i],
          child: ProductItem(),
        ));
  }
}