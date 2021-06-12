import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productid;
  final String titel;
  final double price;
  final int quantitiy;

  CartItem({this.id, this.titel, this.price, this.quantitiy, this.productid});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction){
      return  showDialog(context: context,builder: (ctx)=>AlertDialog(
          title: Text('Are You Sure? '),
        content: Text('Do You remove item from Cart ?'),
        actions: [
        FlatButton(onPressed: (){
        Navigator.of(ctx).pop(true);
        }, child: Text('YES')),
        FlatButton(onPressed: (){
        Navigator.of(ctx).pop(false);
        }, child: Text('NO'))
        ],
        ));
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context,listen: false).remove(productid);
      },
      child: Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(
                    '\$price)',
                  ),
                ),
              )),
              title: Text(titel),
              subtitle: Text("\$${price * quantitiy}"),
              trailing: Text("$quantitiy x"),
            ),
          )),
    );
  }
}
