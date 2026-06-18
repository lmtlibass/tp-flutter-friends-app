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
        ],
      ),
    );
  }
}
