import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final String recipeName;
  final String estTimeMin;
  final List availableIngredients;
  final List missingIngredients;
  final Map<String, dynamic> instructions;
  final String thumbnailUrl;

  const RecipeDetailPage({
    super.key,
    required this.recipeName,
    required this.estTimeMin,
    required this.availableIngredients,
    required this.missingIngredients,
    required this.instructions,
    required this.thumbnailUrl,
  });
  @override
  Widget build(BuildContext context) {
    String totalIngredients =
        (availableIngredients.length + missingIngredients.length).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              children: [
                Image.network(thumbnailUrl),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.timer,
                      size: 15,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "$estTimeMin mins",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.0,
                    ),
                    child: Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "$totalIngredients items",
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                ...availableIngredients.map(
                  (ingredient) => ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                    title: Text(
                      ingredient,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: 0,
                      vertical: -4,
                    ),
                  ),
                ),
                ...missingIngredients.map(
                  (ingredient) => ListTile(
                    leading: const Icon(
                      Icons.question_mark,
                      color: Colors.blue,
                      size: 18,
                    ),
                    title: Text(
                      ingredient,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: 0,
                      vertical: -4,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    right: 20,
                    left: 20,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.0,
                    ),
                    child: Text(
                      "Instructions",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "$estTimeMin mins",
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: instructions.length,
                separatorBuilder: (BuildContext context, int index) => Divider(
                      color: Colors.blueGrey.withOpacity(0.5),
                      indent: 25,
                      endIndent: 25,
                      thickness: 2,
                    ),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      radius: 15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      instructions['step${index + 1}'],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: 2,
                      vertical: 2,
                    ),
                    minLeadingWidth: 10,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
