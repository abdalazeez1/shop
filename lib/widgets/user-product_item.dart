import 'package:flutter/material.dart';
import 'package:max_shop/screens/edit_product_screen.dart';
import '../Provider/products.dart';
import 'package:provider/provider.dart';
class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String image;

  UserProductItem({this.title, this.image,this.id});

  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(image)
//      AssetImage(image)
      ),

//      leading: CircleAvatar(backgroundImage: AssetImage(image)),
      //here is NetWorkImage is class
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routName,arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () async{
                  try {
                  await   Provider.of<Products>(context, listen: false).deletproduct(
                        id);
                  }catch(error){
                    // because found async .of(context) don't work
                    scaffold.showSnackBar(SnackBar(content:Text( "Deleting Failed!",textAlign: TextAlign.center,)));

                  }
                  }),
          ],
        ),
      ),
    );
  }
}
