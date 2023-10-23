import 'package:flutter/material.dart';
import 'package:expense_tracker/model/epense.dart';
class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expanse,{super.key});
   final Expense expanse;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expanse.title,style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(height: 4,),
            Row(
              children: [
                Text("\$${expanse.amount.toStringAsFixed(2)}"),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expanse.category]),
                    const SizedBox(width: 8,),
                    Text(expanse.formattedData),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
