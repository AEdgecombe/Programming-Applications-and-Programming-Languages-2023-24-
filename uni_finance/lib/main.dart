import 'package:flutter/material.dart';

void main() {
  runApp(BudgetApp());
}

class BudgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BudgetHome(),
    );
  }
}

class BudgetHome extends StatefulWidget {
  @override
  _BudgetHomeState createState() => _BudgetHomeState();
}

class _BudgetHomeState extends State<BudgetHome> {
  List<Transaction> transactions = [];

  void _addNewTransaction(String title, double amount) {
    final newTransaction = Transaction(
      title: title,
      amount: amount,
    );

    setState(() {
      transactions.add(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget App'),
      ),
      body: Column(
        children: [
          BudgetSummary(transactions),
          TransactionList(transactions),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return AddTransaction(_addNewTransaction);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Transaction {
  final String title;
  final double amount;

  Transaction({required this.title, required this.amount});
}

class BudgetSummary extends StatelessWidget {
  final List<Transaction> transactions;

  BudgetSummary(this.transactions);

  double get totalSpending {
    return transactions.fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Spending:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${totalSpending.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: transactions.isEmpty
          ? Column(
              children: [
                Text('No transactions added yet!'),
                SizedBox(height: 20),
                Image.asset('assets/images/waiting.png', fit: BoxFit.cover),
              ],
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                              '\$${transactions[index].amount.toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                    title: Text(transactions[index].title),
                  ),
                );
              },
            ),
    );
  }
}

class AddTransaction extends StatelessWidget {
  final Function addTransaction;
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  AddTransaction(this.addTransaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
            ),
            TextButton(
              onPressed: () {
                addTransaction(
                  titleController.text,
                  double.parse(amountController.text),
                );
                Navigator.of(context).pop();
              },
              child: Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
