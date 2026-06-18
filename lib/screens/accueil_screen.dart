import 'package:flutter/material.dart';
import 'package:myfriends/main.dart';
import 'package:myfriends/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accueil')),
      drawer: LeftDrawer(),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Bienvenu dans l\'univers de mes amis',
              style: TextStyle(
                fontSize: 24.2,
                color: AppColors.teal,
                fontWeight: FontWeight(100),
              ),
            ),
            SizedBox(height: 20),

            const Text(
              "MySquad est mon espace pour présenter les personnes qui comptent "
              "le plus pour moi. Chaque ami a sa propre fiche avec son histoire, "
              "ses traits de caractère et nos meilleurs souvenirs partagés. "
              "Découvrez ma bande !",
            ),
            SizedBox(height: 20.2),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list_amis');
              },
              child: Text('Voir mes amis'),
            ),
          ],
        ),
      ),
    );
  }
}
