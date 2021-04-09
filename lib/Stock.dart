import 'package:flutter/material.dart';
import 'package:stock_management/DatabaseHelper.dart';
import 'package:stock_management/Product.dart';

class StockScreen extends StatefulWidget {
  static String routeName="/Stock";
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("All Products"),
        ),
        body:FutureBuilder<List<Product>>(
          future: DatabaseHelper.instance.getStock(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return ListView.builder(
                itemCount: snapshot.data.length,
                  itemBuilder: (context,index){
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Product Name : ${snapshot.data[index].productName}"),
                            Text("Product Unit : ${snapshot.data[index].unit}"),
                            Text("Available  : ${snapshot.data[index].quantity} item"),
                          ],
                        ),
                      ),
                    );
                  });
            }else{
              return Center(
                child: Text("Loading Data..."),
              );
            }
          },
        )
      ),
    );
  }
}
