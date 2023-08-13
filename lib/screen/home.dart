import 'package:flutter/material.dart';
import 'package:prime_user_add/screen/add_modal.dart';
import 'package:prime_user_add/screen/anime_details.dart';

import '../widgets/anime_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final animeList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Show the modal and wait for the user input
              final animeData = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AddAnimeModal();
                },
              );
              // Handle the returned data
              if (animeData != null) {
                // Add the anime data to your database or state
                setState(() {
                  animeList.add(animeData);
                });
              }
            },
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: animeList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns
            childAspectRatio: 0.7,
            crossAxisSpacing: 10),
        itemBuilder: (context, index) {
          final anime = animeList[index];
          return AnimeCard(
            imageUrl: anime['image_url'],
            title: anime['title'],
            onTap: () {
              // Handle card click, e.g., navigate to a details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeDetailPage(animeData: anime),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
