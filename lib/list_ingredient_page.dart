import 'package:flutter/material.dart';

class ListIngredientPage extends StatelessWidget {
  final List resultData;
  final int resultLength;

  const ListIngredientPage(
      {super.key, required this.resultData, required this.resultLength});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Ingredient List"),
      ),
      body: ListView.builder(
        itemCount: resultLength,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(resultData[index]['ingredientName']),
              subtitle: Text(resultData[index]['count']),
            ),
          );
        },
      ),
    );
  }
}
