import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../model/epense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle = '';
  // void _saveTitleInput(String inputValue){
  //   /// through text field value save in variable with use onChanged method in text field
  //    _enteredTitle = inputValue;
  // }
  final _titleInputController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;


  void _presentDatePicker() async{
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1 , now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }
  void _showDialog(){
    if(Platform.isIOS){
      showCupertinoDialog(
          context: context,
          builder: (ctx) =>  CupertinoAlertDialog(
            title: const Text("Invalid input"),
            content: const Text("Please make sure a valid title amount, date and category was entered"),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"),
              ),
            ],
          ));

    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Invalid input"),
            content: const Text("Please make sure a valid title amount, date and category was entered"),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"),
              ),
            ],
          ));

    }


  }
  void _submitExpenseData(){
     final enteredAmount = double.tryParse(_amountController.text);
     final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if(_titleInputController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null ){
      _showDialog();
      return;
    }
     widget.onAddExpense(
       Expense(
           title: _titleInputController.text,
           amount: enteredAmount,
           date: _selectedDate!,
           category: _selectedCategory,
       ),
     );
    Navigator.pop(context);
    print(_titleInputController.text);
    print(_amountController.text);
  }


  @override
  void dispose() {
    _titleInputController.dispose();
    _amountController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints){
      print("width ${constraints.maxWidth}");
      print("width ${constraints.minWidth}");
      print("height ${constraints.maxHeight}");
      print("height ${constraints.minHeight}");

      
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyBoardSpace + 16),
            child: Column(
              children: [
               if(width >= 600)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _titleInputController,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          label: Text("Title"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24,),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: "\$ ",
                          label: Text("Amount"),
                        ),
                      ),
                    ),
                  ],
                )
                else
                 TextField(
                   controller: _titleInputController,
                   maxLength: 50,
                   decoration: const InputDecoration(
                     label: Text("Title"),
                   ),
                 ),
                if(width >= 600)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) =>
                              DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase())
                              ),
                        ).toList(),
                        onChanged: (value){
                          if(value == null){
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            _selectedDate == null
                                ? "No Date Selected"
                                : formatter.format(_selectedDate!),

                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(
                                Icons.calendar_month
                            ),
                          ),
                          // hassan
                        ],
                      ),
                  ],)
                else
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: "\$ ",
                          label: Text("Amount"),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            _selectedDate == null
                                ? "No Date Selected"
                                : formatter.format(_selectedDate!),

                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(
                                Icons.calendar_month
                            ),
                          ),
                          // hassan
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                if(width >= 600) Row(children: [
                  const Spacer(),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: _submitExpenseData,
                    child: const Text("Save Expense"),),
                ],)
                else
                  Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            (category) =>
                            DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase())
                            ),
                      ).toList(),
                      onChanged: (value){
                        if(value == null){
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text("Save Expense"),),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

