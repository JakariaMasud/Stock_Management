class TransactionHistory {
  int id,rate,date,unit,quantity;
  String type,itemName;
  TransactionHistory({this.id,this.itemName,this.unit,this.quantity,this.rate,this.date,this.type});




  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'unit': unit,
      'quantity':quantity,
      'rate':rate,
      'date':date,
      'type':type,

    };
  }
}