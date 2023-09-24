import 'package:flutter/material.dart';

import 'recipes_card.dart';

class ListRecipesPage extends StatelessWidget {
  final List resultData;
  final int resultLength;

  const ListRecipesPage({
    super.key,
    required this.resultData,
    required this.resultLength,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Let's Get Cookin' 🍳")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: resultLength,
              itemBuilder: (context, index) {
                return RecipeCard(
                  recipeName: resultData[index]['recipe_name'],
                  estTimeMin: resultData[index]['est_time_min'],
                  availableIngredients: resultData[index]
                      ['available_ingredients'],
                  missingIngredients: resultData[index]['missing_ingredients'],
                  instructions: resultData[index]['instructions'],
                  thumbnailUrl: resultData[index]['imgUrl'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
