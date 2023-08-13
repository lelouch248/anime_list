import 'package:flutter/material.dart';

class AnimeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onTap;

  const AnimeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color:
                      Theme.of(context).colorScheme.background.withOpacity(0.8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
