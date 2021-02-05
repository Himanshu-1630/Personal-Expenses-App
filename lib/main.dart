import './widgets/chart.dart';

import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Transactions',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.greenAccent,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  
  // MediaQuery.

  final List<Transaction> _userTransactions = [
    // Transaction(
    //   amount: 69.99,
    //   date: DateTime.now(),
    //   id: 't1',
    //   title: 'Dog Purchase',
    // ),
    // Transaction(
    //   amount: 89.99,
    //   date: DateTime.now(),
    //   id: 't2',
    //   title: 'Grocceries Purchase',
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: txDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String idNumber) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == idNumber);
    });
  }
  bool _showchart = false;

  @override
  Widget build(BuildContext context) {
    final isLandscape=MediaQuery.of(context).orientation == Orientation.landscape;
    final appbar = AppBar(
      title: Text(
        'Personal Transactions',
        // style: TextStyle(
        //   fontSize: 20,
        //   fontWeight: FontWeight.bold,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            size: 35,
          ),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    final txlist= Container(
              height: (MediaQuery.of(context).size.height -
                      appbar.preferredSize.height -MediaQuery.of(context).padding.top) *
                  0.7,
              child: TransactionList(_userTransactions, _deleteTransaction),
            );
    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if(isLandscape)
            (
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart'),
                Switch(value: _showchart, onChanged:(val){ 
                  setState(() {
                    _showchart = val;
                  });
                } ,),
              ],
            )
            ),
            if(isLandscape) (
            _showchart ? 
            Container(
              height: (MediaQuery.of(context).size.height -
                      appbar.preferredSize.height- MediaQuery.of(context).padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
            :
            txlist  ),
            if(!isLandscape)
            (Container(
              height: (MediaQuery.of(context).size.height -
                      appbar.preferredSize.height- MediaQuery.of(context).padding.top) *
                  0.3,
              child: Chart(_recentTransactions),
            )
            ),
            if(!isLandscape)(
            txlist  ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
