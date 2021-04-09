import'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_management/Product.dart';
import 'package:stock_management/TransactionHistory.dart';


class DatabaseHelper {
  static final _databaseName = "inventoryDatabase.db";
  static final _databaseVersion = 1;
  static final productTable = 'product_table';
  static final transactionTable = 'transaction_table';
  static final columnId = 'id';
  static final columnName = 'productName';
  static final columnItemName = 'itemName';
  static final columnUnit = 'unit';
  static final columnQuantity = 'quantity';
  static final columnRate = 'rate';
  static final columnDate = 'date';
  static final columnType = 'type';
  static final addType = 'add';
  static final saleType = 'sale';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future <void>_onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $productTable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnUnit INTEGER NOT NULL,
            $columnQuantity INTEGER NOT NULL,
            $columnRate INTEGER NOT NULL,
            $columnDate INTEGER NOT NULL)
           
          ''');
    await db.execute('''
          CREATE TABLE $transactionTable (
            $columnId INTEGER PRIMARY KEY,
            $columnItemName TEXT NOT NULL,
            $columnUnit INTEGER NOT NULL,
            $columnQuantity INTEGER NOT NULL,
            $columnRate INTEGER NOT NULL,
            $columnDate INTEGER NOT NULL,
            $columnType TEXT NOT NULL) 
            
          ''');

  }
  Future<void> insertOrUpdateForAdd(Product product) async{
    Product pd=await getProductByNameAndUnit(product);
    if(pd==null){
      insert(product);
      print("product inserted");
    }else{
      update(product);
      print("product updated");
    }

  }
  Future<void>insertTransaction(TransactionHistory history)async{
    Database db = await DatabaseHelper.instance.database;
    await db.insert(
      transactionTable,
      history.toMap()
    );
    print("History added.");
  }

  Future<void> updateForSale(Product product) async{
    Database db = await DatabaseHelper.instance.database;
    Product pd=await getProductByNameAndUnit(product);
    if(pd==null){
      print("No Product To Sale");
    }else{
      if(pd.quantity>product.quantity){
        int availableProduct=pd.quantity-product.quantity;
        pd.quantity=availableProduct;
        await db.update(productTable, pd.toMap());
        insertTransaction(TransactionHistory(itemName: product.productName,unit: product.unit,quantity: product.quantity,rate: product.rate,date: product.date,type: saleType));
        print("item  updated");
        print("item name : ${pd.productName} available item : ${pd.quantity}");

      }else if(pd.quantity==product.quantity){

        await db.delete(productTable,
        where: 'id = ? ',
        whereArgs: [pd.id]);
        print("product deleted");
        insertTransaction(TransactionHistory(itemName: product.productName,unit: product.unit,quantity: product.quantity,rate: product.rate,date: product.date,type: saleType));
      }
    }

  }
  Future<Product>getProductByNameAndUnit(Product product) async{
    Database db = await DatabaseHelper.instance.database;
    var items =await db.rawQuery("SELECT * FROM $productTable WHERE $columnName=? AND $columnUnit=?",[product.productName,product.unit]);
    if(!items.isEmpty){
      return Product(
          id: items[0][columnId],
          productName: items[0][columnName],
          unit: items[0][columnUnit],
          quantity: items[0][columnQuantity],
          rate: items[0][columnRate],
          date: items[0][columnDate]
      );
    }else{
      return null;
    }

  }

  Future<void> insert(Product product) async{
    Database db = await DatabaseHelper.instance.database;
    await db.insert(
      productTable,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    insertTransaction(TransactionHistory(itemName: product.productName,unit: product.unit,quantity: product.quantity,rate: product.rate,date: product.date,type: addType));
  }

  Future <void> update(Product product) async{
    Database db = await DatabaseHelper.instance.database;
    Product pd=await getProductByNameAndUnit(product);
    int newAvailableProduct=pd.quantity+product.quantity;
    pd.quantity=newAvailableProduct;
    await db.update(productTable, pd.toMap());
    insertTransaction(TransactionHistory(itemName: product.productName,unit: product.unit,quantity: product.quantity,rate: product.rate,date: product.date,type: addType));

  }
  Future<List<TransactionHistory>> getHistory() async{
    Database db = await DatabaseHelper.instance.database;
    var allItems=<TransactionHistory>[];
    var items =await db.rawQuery("SELECT * FROM $transactionTable");
    if(items.isNotEmpty){
      for(var singleItem in items){
        TransactionHistory history=TransactionHistory(
          id: singleItem[columnId],
          itemName: singleItem[columnItemName],
          unit: singleItem[columnUnit],
          quantity: singleItem[columnQuantity],
          rate: singleItem[columnRate],
          date: singleItem[columnDate],
          type: singleItem[columnType]
        );
        allItems.add(history);
      }
    }
    return allItems;
  }
  Future<List<Product>>getStock() async{
    Database db = await DatabaseHelper.instance.database;
    var allItems=<Product>[];
    var items =await db.rawQuery("SELECT * FROM $productTable");
    if(items.isNotEmpty){
      for (var value in items) {
        Product product=Product(
            id: value[columnId],
            productName: value[columnName],
            unit: value[columnUnit],
            quantity: value[columnQuantity],
            rate: value[columnRate],
            date: value[columnDate]
        );
        allItems.add(product);


      }
    }


 return allItems;
  }


}