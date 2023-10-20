import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/epense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

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
  
  @override
  void dispose() {
    _titleInputController.dispose();
    _amountController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleInputController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text("Title"),
            ),
          ),
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
                  onPressed: (){
                    print(_titleInputController.text);
                    print(_amountController.text);
                  },
                  child: const Text("Save Expense"),),
            ],
          ),
        ],
      ),
    );
  }
}

