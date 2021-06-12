import 'package:flutter/material.dart';
import 'package:max_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../Provider/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = '/order';

//  @override
//  _OrderScreenState createState() => _OrderScreenState();
//}
//
//class _OrderScreenState extends State<OrderScreen> {
//  var _isLoading = false;

//  @override
//  void initState() {
//    //1can put async but we will not do that
//    //2 after edit because we use listen false in init state we can delete Future.Delayed and we use methode then
//    // TODO: implement initState
//    super.initState();
//////  Future.delayed(Duration.zero).then((_) async{
//////    setState(() {
////      _isLoading=true;
//////    });
////  Provider.of<Orders>(context,listen: false).fetchAndSetOrders().then((value) {
////
////
////   setState(() {
////     _isLoading=false;
////   });
////  });
////  });
//  }

  @override
  Widget build(BuildContext context) {
    //we can add print('building');if we leave tow call of provider
//    final orderData = Provider.of<Orders>(context);//if we leave the line here we enter to infinity loop because this provider and that provider will call method build many time
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Screen'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              // ignore: missing_return
              .fetchAndSetOrders(),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else
              {
//              if (dataSnapShot.error != null) {
////              do error handling
//                return Center(
//                  child: Text('an error occurred'),
//                );
//              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderData, _) => ListView.builder(
                        itemBuilder: (context, i) =>
                            OrderItem(orderData.order[i]),
                        itemCount: orderData.order.length));
              }
            }
//          },
        ));
  }
}
