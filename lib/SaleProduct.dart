import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_management/DatabaseHelper.dart';
import 'package:stock_management/Product.dart';
import 'package:intl/intl.dart';
class SaleProductScreen extends StatefulWidget {
  static String routeName="/SaleProduct";
  @override
  _SaleProductScreenState createState() => _SaleProductScreenState();
}

class _SaleProductScreenState extends State<SaleProductScreen> {
  DateTime _selectedDate;
  final nameController=new TextEditingController();
  final unitController=new TextEditingController();
  final quantityController=new TextEditingController();
  final rateController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sale Product"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: TextInputType.name,
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Product Name",
                hintText: "Enter Product Name",
              ),
            ),
            SizedBox(height: 15.0,),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters:<TextInputFormatter> [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: unitController,
              decoration: InputDecoration(
                labelText: "Product Unit",
                hintText: "Enter Product Unit",
              ),
            ),
            SizedBox(height: 15.0,),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters:<TextInputFormatter> [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: quantityController,
              decoration: InputDecoration(
                labelText: "Product Quantity",
                hintText: "Enter Product Quantity",
              ),
            ),
            SizedBox(height: 15.0,),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters:<TextInputFormatter> [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              controller: rateController,
              decoration: InputDecoration(
                labelText: "Product rate",
                hintText: "Enter Rate In Taka",
              ),
            ),
            SizedBox(height: 15.0,),
            ElevatedButton(onPressed:
                (){
              showDatePicker(
                context: context,
                initialDate:  _selectedDate != null ? _selectedDate : DateTime.now(),
                firstDate: DateTime(2019, 1),
                lastDate: DateTime(2030, 12),
              ).then((pickedDate) {
                //do whatever you want
                _selectedDate=pickedDate;
                setState(() {});
              });
            },
                child:
                Text("Select Date")),
            Text(_selectedDate==null?"No Date Selected" :DateFormat('yyyy-MM-dd').format(_selectedDate)),
            SizedBox(height: 15.0,),
            Row(
              children: [
                Spacer(),
                ElevatedButton(
                    onPressed: (){
                      String name=nameController.text.toString();
                      String unit=unitController.text.toString();
                      String quantity=quantityController.text.toString();
                      String rate=rateController.text.toString();
                      DatabaseHelper.instance.updateForSale(Product(productName: name,unit: int.parse(unit),quantity: int.parse(quantity),rate: int.parse(rate),date: _selectedDate.microsecondsSinceEpoch));
                      Navigator.pop(context);
                    },
                    child: Text("Sale Product"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
