import '../widgets/how_it_works_section.dart';
import 'package:flutter/material.dart';
import '../widgets/featured_items_list.dart';
import '../widgets/footer_section.dart';
import '../widgets/nav_links_bar.dart';
import 'package:dtu_bazaar/pages/cart_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SearchController _searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        title: const NavLinksBar(),

        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.android_rounded, color: Colors.blueGrey),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search, color: Colors.blueGrey),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                  icon: Icon(Icons.shopping_cart, color: Colors.blueGrey),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(40.0),
              width: double.infinity,
              color: Color(0xFF4169E1),
              child: Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Welcome to DTU Bazaar",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "The official marketplace for DTU students. Buy, sell, and trade within your \n campus community.",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 48,
                          child: SearchBar(
                            controller: _searchController,
                            hintText: 'Search...',
                            leading: Icon(Icons.search),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onSubmitted: (value) {},
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text("Search"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // This already scrolls horizontally, no changes needed
            FeaturedItemsList(),
            SizedBox(height: 2),
            HowItWorksSection(),
            SizedBox(height: 2),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}
