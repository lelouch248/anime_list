import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prime_user_add/screen/auth.dart';
import 'package:prime_user_add/screen/home.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [
          Center(
            child: Text(
              'Who\'s Watching?',
              style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 5,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                childAspectRatio: 2,
                children: [
                  FloatingActionButton(
                    heroTag: "user1",
                    backgroundColor: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    shape: const CircleBorder(),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        child: Image.asset("assets/images/profile.jpg")),
                  ),
                  FloatingActionButton(
                    heroTag: "add_user",
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthScreen()),
                      );
                    },
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.add,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ]),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Text(
                'Edit Profiles',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.red[800],
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
