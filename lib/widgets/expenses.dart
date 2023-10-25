
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import '../model/epense.dart';
import 'chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  final List<Expense> _registeredExpense = [
    Expense(
        title: "Flutter Course",
        amount: 19.80,
        date: DateTime.now(),
        category: Category.work,
    ),

    Expense(
      title: "Cinema",
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    )

  ];

  void _openAddExpenseOverlay(){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: double.infinity,
      ),
      builder: (context) =>
          NewExpense(onAddExpense: _addExpense,
          ),
    );
  }

  void _addExpense(Expense expanse){
   setState(() {
     _registeredExpense.add(expanse);
   });
  }

  void _removeExpense(Expense expanse){
    final expenseIndex = _registeredExpense.indexOf(expanse);
    setState(() {
      _registeredExpense.remove(expanse);
    });
   ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text("Expense Delete"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: (){
             setState(() {
               _registeredExpense.insert(expenseIndex, expanse);
             });
            },
          ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {


    Widget mainContent = const Center(
      child: Text("No expenses found. Start adding some!"),
    );
    if(_registeredExpense.isNotEmpty){
      mainContent =  ExpensesList(
        expenses: _registeredExpense,
        onRemoveExpense: _removeExpense,
      );
    }



    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flutter ExpenseTracker"),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: MediaQuery.of(context).size.width < 600
          ? Column(
        children: [
          Chart(expenses: _registeredExpense,),
          Expanded(
              child: mainContent,
          ),
        ],
      )
          : Row(children: [
        Expanded(child: Chart(expenses: _registeredExpense,)),
        Expanded(
          child: mainContent,
        ),
      ],),
    );
  }
}
