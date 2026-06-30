import 'package:flutter/material.dart';
import 'package:myfriends/main.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.teal),
            child: Text(
              'Menu Principal',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: AppColors.pink),
            title: Text('Accueil', style: TextStyle(color: AppColors.dark)),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.list, color: AppColors.pink),
            title: Text('List Amis', style: TextStyle(color: AppColors.dark)),
            onTap: () {
              Navigator.pushNamed(context, '/list_amis');
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: AppColors.pink),
            title: Text('Best', style: TextStyle(color: AppColors.dark)),
            onTap: () {
              Navigator.pushNamed(context, '/best');
            },
          ),
          ListTile(
            leading: Icon(Icons.timer, color: AppColors.pink),
            title: Text('Compteur', style: TextStyle(color: AppColors.dark)),
            onTap: () {
              Navigator.pushNamed(context, '/compteur');
            },
          ),
           ListTile(
            leading: Icon(Icons.thumb_up, color: AppColors.pink),
            title: Text('like', style: TextStyle(color: AppColors.dark)),
            onTap: () {
              Navigator.pushNamed(context, '/like');
            },
          ),
          ListTile(
            leading: Icon(Icons.password, color: AppColors.pink),
            title: Text('pass', style: TextStyle(color: AppColors.dark)),
            onTap: () {
              Navigator.pushNamed(context, '/pass');
            },
          ),
          ListTile(
            leading: Icon(Icons.eleven_mp, color: AppColors.pink),
            title: Text('container', style: TextStyle(color: AppColors.dark)),
            onTap: () {
              Navigator.pushNamed(context, '/container');
            },
          ),
           ListTile(
            leading: Icon(Icons.add, color: AppColors.pink),
            title: Text('formulaire', style: TextStyle(color: AppColors.dark)),
            onTap: () {
              Navigator.pushNamed(context, '/formulaire');
            },
          ),
          
        ],
      ),
    );
  }
}
