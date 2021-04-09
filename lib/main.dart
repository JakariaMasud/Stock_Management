import 'package:flutter/material.dart';
import 'package:stock_management/AddProduct.dart';
import 'package:stock_management/History.dart';
import 'package:stock_management/SaleProduct.dart';
import 'package:stock_management/Stock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static String routeName="/Home";
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.routeName,
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (context)=>HomeScreen(),
        AddProductScreen.routeName: (context)=>AddProductScreen(),
        SaleProductScreen.routeName: (context)=>SaleProductScreen(),
        StockScreen.routeName: (context)=> StockScreen(),
        HistoryScreen.routeName: (context)=>HistoryScreen(),
      },
    );
  }
}
class HomeScreen extends StatefulWidget {
  static String routeName="/Home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Container(
          padding: EdgeInsets.all(25.0),
          child: GridView(
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            children: [
              SingleCard(
                  "assets/images/add.png", "Add Product", Colors.green),
              SingleCard("assets/images/dollar-symbol.png", "Sale Product",
                  Colors.pink),
              SingleCard("assets/images/history.png", "History", Colors.blue),
              SingleCard("assets/images/stock.png", "Stock", Colors.purple),
            ],
          ),
        ),
      ),
    );
  }
}


class SingleCard extends StatelessWidget {
  final String imgLink, cardText;
  final Color color;
  SingleCard(this.imgLink, this.cardText, this.color);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(cardText=="Add Product"){
          print("Add Product Clicked");
          Navigator.pushNamed(context, AddProductScreen.routeName);
        }else if(cardText=="Sale Product"){
          print("Sale Product clicked");
          Navigator.pushNamed(context, SaleProductScreen.routeName);
        }
        else if(cardText=="History"){
          print("history card clicked");
          Navigator.pushNamed(context, HistoryScreen.routeName);
        }else if(cardText=="Stock"){
          print("stock is clicked");
          Navigator.pushNamed(context, StockScreen.routeName);
        }
      },
      child: Container(
        child: Card(
          elevation: 7.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(imgLink), fit: BoxFit.none)),
              ),
              SizedBox(height: 20.0,),
              Text(cardText)
            ],
          ),
        ),
      ),
    );
  }
}
