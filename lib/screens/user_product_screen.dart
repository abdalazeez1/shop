import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:max_shop/screens/edit_product_screen.dart';
import 'package:max_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../Provider/products.dart';
import '../widgets/user-product_item.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = "/USerProductScr";
  Future<void> _refresh(BuildContext context)async{
await    Provider.of<Products>(context,listen: false).featchandSetDate(true);
  }

  @override
  Widget build(BuildContext context) {
//    final productData = Provider.of<Products>(context);// here we don't add listen false can put Icon and title const
    //we add// to to previous provider because if we left we enter on loop infinity so we add consumer
    return Scaffold(
      appBar: AppBar(
        title: const Text('product'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
Navigator.of(context).pushNamed(EditProductScreen.routName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder:(ctx,snapShot)=>snapShot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator(),)
            : RefreshIndicator(
          onRefresh: ()=>_refresh(context),
          child: Consumer<Products>(
            builder:(ctx,productData,_)=> Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemBuilder: (_, i) => Column(
                        children: [
                          UserProductItem(
                            id: productData.item[i].id,
                            title: productData.item[i].title,
                            image: productData.item[i].imageUrl,
                          ),
                          Divider()
                        ],
                      ),
                  itemCount: productData.item.length),
            ),
          ),
        ),
      ),
    );
  }
}
