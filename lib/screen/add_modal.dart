import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:prime_user_add/Loader/ducks.dart';

final _firebase = FirebaseAuth.instance;

class AddAnimeModal extends StatefulWidget {
  const AddAnimeModal({Key? key}) : super(key: key);

  @override
  _AddAnimeModalState createState() => _AddAnimeModalState();
}

class _AddAnimeModalState extends State<AddAnimeModal> {
  // Define TextEditingController for each input field
  final TextEditingController _titleController = TextEditingController();
  bool _isFectingData = false;

  Future<Map<String, dynamic>> fetchAnimeInfo(String query) async {
    final apiUrl = Uri.parse(
        'https://api.jikan.moe/v4/anime?q=$query&min_score=4.0&sfw=true&page=1');

    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'][0];
    } else {
      throw Exception('Failed to fetch anime data');
    }
  }

  Future<List<dynamic>> fetchAnimeRecommendations(int query) async {
    final apiUrl =
        Uri.parse('https://api.jikan.moe/v4/anime/$query/recommendations');

    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to fetch anime data');
    }
  }

  void _popScreen(Map<String, dynamic> animeData) {
    // Use a post-frame callback to ensure that the current build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop(animeData);
    });
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving anime data: ${error.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> animeInfo = {};

    return _isFectingData
        ? const DucksLoader()
        : Dialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 25),
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      labelStyle:
                          TextStyle(fontSize: 18, color: Colors.white30),
                      hintStyle: TextStyle(color: Colors.red),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isFectingData = !_isFectingData;
                      });
                      final animeRecommendationsList = [];

                      // Save the entered data and close the modal
                      final animeInfo =
                          await fetchAnimeInfo(_titleController.text);
                      final animeRecomendations =
                          await fetchAnimeRecommendations(animeInfo['mal_id']);

                      for (var anime in animeRecomendations) {
                        animeRecommendationsList.add({
                          'image_url': anime['entry']['images']['jpg']
                              ['image_url'],
                          'title': anime['entry']['title'],
                        });
                      }
                      List<String> combinedCategories = [];

                      if (animeInfo['genres'] != null) {
                        for (var genre in animeInfo['genres']) {
                          combinedCategories.add(genre['name']);
                        }
                      }

                      if (animeInfo['themes'] != null) {
                        for (var theme in animeInfo['themes']) {
                          combinedCategories.add(theme['name']);
                        }
                      }

                      if (animeInfo['demographics'] != null) {
                        for (var demographic in animeInfo['demographics']) {
                          combinedCategories.add(demographic['name']);
                        }
                      }

                      final animeData = {
                        'mal_id': animeInfo['mal_id'],
                        'title': _titleController.text,
                        'image_url': animeInfo['images']['jpg']['image_url'],
                        'score': animeInfo['score'],
                        'trailer_link': animeInfo['trailer']['url'],
                        'year': animeInfo['year'],
                        'categories':
                            combinedCategories, // Combine categories into a single string
                        'recommendations': animeRecommendationsList,
                        'synopsis': animeInfo['synopsis'],
                      };
                      try {
                        final user = _firebase.currentUser;
                        final animeListRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .collection('animeList');
                        await animeListRef.add(animeData);
                      } catch (error) {
                        _showError(error);
                      }
                      setState(() {
                        _isFectingData = false;
                      });
                      _popScreen(animeData);
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
