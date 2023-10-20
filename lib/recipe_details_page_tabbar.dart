import 'package:flutter/material.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';

class RecipeDetailPage extends StatefulWidget {
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
  RecipeDetailPageState createState() => RecipeDetailPageState();
}

class RecipeDetailPageState extends State<RecipeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    String totalIngredients =
        (widget.availableIngredients.length + widget.missingIngredients.length)
            .toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeName),
      ),
      body:
          // SingleChildScrollView(
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          ListView(
        // scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        // padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.sizeOf(context).height) * 0.23,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
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
                image: NetworkImage(widget.thumbnailUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
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
                            Text("${widget.estTimeMin} mins"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child:
                    TabBar(
                      indicatorPadding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                      controller: _controller,
                      tabs: [
                        Tab(
                          child: ListTile(
                            minVerticalPadding: 7,
                            trailing: const Icon(
                              Icons.local_grocery_store,
                              color: Colors.blue,
                              size: 17,
                            ),
                            title: const Padding(
                              padding: EdgeInsets.only(
                                bottom: 0,
                              ),
                              child: Text(
                                "Ingredients",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              "$totalIngredients items",
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            visualDensity: const VisualDensity(
                              horizontal: 0,
                              vertical: -4,
                            ),
                          ),
                        ),
                        Tab(
                          child: ListTile(
                            minVerticalPadding: 7,
                            trailing: const Icon(
                              Icons.menu_book,
                              color: Colors.blue,
                              size: 18,
                            ),
                            title: const Padding(
                              padding: EdgeInsets.only(
                                bottom: 0,
                              ),
                              child: Text(
                                "Instructions",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              "${widget.estTimeMin} mins",
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            visualDensity: const VisualDensity(
                              horizontal: 0,
                              vertical: -4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ),
                    AutoScaleTabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      children: <Widget>[
                        ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          // scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          children: [
                            ...widget.availableIngredients.map(
                              (ingredient) => ListTile(
                                leading: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                title: Text(
                                  ingredient,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                visualDensity: const VisualDensity(
                                  horizontal: 0,
                                  vertical: -4,
                                ),
                              ),
                            ),
                            ...widget.missingIngredients.map(
                              (ingredient) => ListTile(
                                leading: const Icon(
                                  Icons.question_mark,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                title: Text(
                                  ingredient,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                visualDensity: const VisualDensity(
                                  horizontal: 0,
                                  vertical: -4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            // scrollDirection: Axis.vertical,
                            itemCount: widget.instructions.length,
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                                      color: Colors.blueGrey.withOpacity(0.5),
                                      indent: 25,
                                      endIndent: 25,
                                      thickness: 2,
                                    ),
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                minVerticalPadding: 10,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.lightBlue,
                                  radius: 16,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        (index + 1).toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(
                                  widget.instructions['step${index + 1}'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                visualDensity: const VisualDensity(
                                  horizontal: 3,
                                  vertical: 3,
                                ),
                                minLeadingWidth: 10,
                              );
                            }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      //     ],
      //   ),
      // ),
    );
  }
}
