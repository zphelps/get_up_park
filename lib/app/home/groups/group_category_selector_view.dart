import 'package:flutter/material.dart';
import 'package:get_up_park/constants/news_categories.dart';

class GroupCategorySelectorView extends StatelessWidget {
  const GroupCategorySelectorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: GridView.count(
        crossAxisSpacing: 15,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        children: List.generate(NewsCategories.categories.length, (index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Image(
                  image: AssetImage('assets/campus.JPG'),
                  fit: BoxFit.cover,
                  height: 180,
                  width: 180,
                ),
              ),
              Positioned(
                bottom: 15,
                right: 12,
                child: Text(
                  NewsCategories.categories[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        }
        ),
      ),
    );
  }
}
