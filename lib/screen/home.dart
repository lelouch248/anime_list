import 'package:flutter/material.dart';
import 'package:prime_user_add/Loader/ducks.dart';
import 'package:prime_user_add/screen/add_modal.dart';
import 'package:prime_user_add/screen/anime_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/anime_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = false; // To control search bar visibility

  @override
  Widget build(BuildContext context) {
    final user = _firebase.currentUser;
    final animeListRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('animeList');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Toggle the search bar visibility
              setState(() {
                showSearchBar = !showSearchBar;
                if (!showSearchBar) {
                  searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Show the modal and wait for the user input
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AddAnimeModal();
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: animeListRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DucksLoader();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final animeList = snapshot.data?.docs ?? [];
          List<DocumentSnapshot> filteredAnimeList = animeList;

          // Apply search filter if search query is not empty
          if (searchController.text.isNotEmpty) {
            final searchQuery = searchController.text.toLowerCase();
            filteredAnimeList = animeList
                .where((anime) => (anime['title'] as String)
                    .toLowerCase()
                    .contains(searchQuery))
                .toList();
          }

          return Column(
            children: [
              if (showSearchBar)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: searchController,
                    onChanged: (query) {
                      setState(() {
                        // Update the filter on each input change
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search anime...',
                    ),
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  itemCount: filteredAnimeList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    final anime =
                        animeList[index].data() as Map<String, dynamic>;
                    return AnimeCard(
                      imageUrl: anime['image_url'],
                      title: anime['title'],
                      onTap: () {
                        // Handle card click, e.g., navigate to a details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AnimeDetailPage(animeData: anime),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
