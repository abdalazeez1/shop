import 'package:flutter/material.dart';
import 'package:max_shop/Provider/orders.dart';
import 'package:provider/provider.dart';
import '../Provider/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static String cart = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total ",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  //to avoid convert all class to stateful we extract widget and convert it
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          //can add Expanded Widget
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, i) => CartItem(
                  //here item is a map  so we use .values.toList() to convert to list
                      id: cart.item.values.toList()[i].id,
                      productid: cart.item.keys.toList()[i],
                      price: cart.item.values.toList()[i].price,
                      quantitiy: cart.item.values.toList()[i].quantitiy,
                      titel: cart.item.values.toList()[i].title,
                    )),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed:(widget.cart.totalAmount<=0 ||_isLoading)?null : () async{
          setState(() {
            _isLoading=true;
          });
         await  Provider.of<Orders>(context,listen: false).addORder( widget.cart.item.values.toList(),widget.cart.totalAmount);
          widget.cart.clear();
          setState(() {
            _isLoading=false;
          });
        },
        child:_isLoading?CircularProgressIndicator(): Text(
          "ORDER NOW",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ));
  }
}
