import 'package:flutter/material.dart';
import 'package:stock_management/TransactionHistory.dart';
import 'package:stock_management/DatabaseHelper.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  static String routeName="/History";
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Timeline"),
          ),
          body:FutureBuilder<List<TransactionHistory>>(
            future: DatabaseHelper.instance.getHistory(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done){
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,index){
                      var history=snapshot.data[index];
                      String date= DateFormat('d MMM y').format(DateTime.fromMicrosecondsSinceEpoch(history.date));
                      return Container(
                        height: 100.0,
                        child: Card(
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(history.type==DatabaseHelper.addType ? "${index+1}. Purchased ${history.quantity} ${history.itemName} of ${history.unit} Unit at the rate of ${history.rate}  at $date" :
                            "${index+1}. sold  ${history.quantity} ${history.itemName} of ${history.unit} Unit at the rate of ${history.rate}  at $date"),
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
