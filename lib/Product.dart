class Product {
  int id,unit,quantity,rate,date;
  String productName;


  Product({this.id, this.unit, this.quantity, this.rate, this.date,
      this.productName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'unit': unit,
      'quantity':quantity,
      'rate':rate,
      'date':date,

    };
  }
}