import 'package:flutter/material.dart';
import 'recipe_details_page_tabbar.dart';

class RecipeCard extends StatelessWidget {
  final String recipeName;
  final String estTimeMin;
  final List availableIngredients;
  final List missingIngredients;
  final Map<String, dynamic> instructions;
  final String thumbnailUrl;
  final String llmModel;

  const RecipeCard({
    super.key,
    required this.recipeName,
    required this.estTimeMin,
    required this.availableIngredients,
    required this.missingIngredients,
    required this.instructions,
    required this.thumbnailUrl,
    required this.llmModel,
  });

  String transformText(llmModel) {
    switch (llmModel) {
      case "falcon-40b":
        return "Falcon 40B";
      case "jurassic-2-mid":
        return "Jurassic-2 Mid";
      case "claude-instant":
        return "Claude Instant";
      default:
        return "null";
    }
  }

  @override
  Widget build(BuildContext context) {
    String llmModelName = transformText(llmModel);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailPage(
                recipeName: recipeName,
                estTimeMin: estTimeMin,
                availableIngredients: availableIngredients,
                missingIngredients: missingIngredients,
                instructions: instructions,
                thumbnailUrl: thumbnailUrl,
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.35),
              BlendMode.multiply,
            ),
            image: NetworkImage(thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade800,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.bubble_chart,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          "LLM: $llmModelName",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  recipeName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: Colors.blue,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Text("$estTimeMin mins"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
