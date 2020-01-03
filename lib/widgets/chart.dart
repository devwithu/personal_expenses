import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactioins;

  Chart(this.recentTransactioins);

  List<Map<String, Object>> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactioins.length; i++) {
        if (recentTransactioins[i].date.day == weekDay.day &&
            recentTransactioins[i].date.month == weekDay.month &&
            recentTransactioins[i].date.year == weekDay.year) {
          totalSum += recentTransactioins[i].amount;
        }
      }
      //print(DateFormat.E().format(weekDay));
      //print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay).substring(0,1), 
        'amount': totalSum
      };
    });
  }

  double get totalSpending {
    return groupTransactionValues.fold( 0.0, (sum, item) {
      return sum + item['amount'];
    });
  }
  @override
  Widget build(BuildContext context) {
    //print(groupTransactionValues);

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround ,
          children: groupTransactionValues.map((data) {
            return Flexible(
              //flex: 2,
              fit: FlexFit.tight,
                        child: ChartBar(
                data['day'], 
                data['amount'], 
                totalSpending == 0.0 ? 0.0 : ((data['amount']) as double) / totalSpending),
            );  
          }).toList(),
        ),
      ),
    );
  }
}
