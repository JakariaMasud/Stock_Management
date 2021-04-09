import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_management/DatabaseHelper.dart';
import 'package:stock_management/Product.dart';
import 'package:intl/intl.dart';

class AddProductScreen extends StatefulWidget {
    static  String routeName="/AddProduct";
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  DateTime _selectedDate;
  final nameController=new TextEditingController();
  final unitController=new TextEditingController();
  final quantityController=new TextEditingController();
  final rateController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
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
                      setState(() {
                      });
                    });
                  },
              child:
          Text("Select Date")),
          Text(_selectedDate==null?"No Date Selected" : DateFormat('d MMM y').format(_selectedDate)),
            SizedBox(height: 15.0,),
          Row(
            children: [
              Spacer(),
              ElevatedButton(
                  onPressed: (){
                   var productName=nameController.text.toString();
                   var unit=unitController.text.toString();
                   var quantity=quantityController.text.toString();
                   var rate=rateController.text.toString();
                   DatabaseHelper.instance.insertOrUpdateForAdd(Product(productName: productName,unit: int.parse(unit),quantity: int.parse(quantity),rate: int.parse(rate),date: _selectedDate.microsecondsSinceEpoch));
                   Navigator.pop(context);
                  },
                  child: Text("Add Product"))
            ],
          )
          ],
        ),
      ),
    );
  }
}
