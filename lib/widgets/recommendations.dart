import 'package:flutter/material.dart';

class Recommendations extends StatelessWidget {
  const Recommendations({super.key, required this.recommendations});
  final List<dynamic> recommendations;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recommendations.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  recommendations[index]['image_url'],
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                recommendations[index]['title'],
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
