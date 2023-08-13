import 'package:flutter/material.dart';
import 'package:prime_user_add/widgets/recommendations.dart';
import 'package:prime_user_add/widgets/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AnimeDetailPage extends StatelessWidget {
  final Map<String, dynamic> animeData;

  const AnimeDetailPage({super.key, required this.animeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animeData['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(animeData['image_url']),
            const SizedBox(height: 16),
            Text(
              'Score: ${animeData['score']}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Year: ${animeData['year']}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Categories: ${animeData['categories'].join(', ')}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Synopsis:',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              animeData['synopsis'],
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    wordSpacing: 3,
                    letterSpacing: 2,
                    fontFamily: 'RobotoMono',
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Trailer Link:',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () {
                launchUrl(animeData['trailer_link']);
              },
              child: Text(
                animeData['trailer_link'] ?? 'No trailer link',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            VideoPlayerScreen(videoUrl: animeData['trailer_link']),
            Text(
              'Recommendations:',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Recommendations(recommendations: animeData['recommendations']),
            
            
          ],
        ),
      ),
    );
  }
}
