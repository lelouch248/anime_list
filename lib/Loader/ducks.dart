import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DucksLoader extends StatelessWidget {
  const DucksLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWaveSpinner(
        color: Theme.of(context).primaryColor, // Set the color of the loader
        waveColor: Colors.green.shade300,
        size: 70.0, // Set the size of the loader
      ),
    );
  }
}
