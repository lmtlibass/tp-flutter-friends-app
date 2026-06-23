import 'package:flutter/material.dart';
import 'package:myfriends/main.dart';
import 'package:myfriends/widgets/drawer.dart';

class CompteurScreen extends StatefulWidget {
  const CompteurScreen({super.key});

  @override
  State<CompteurScreen> createState() => _CompteurScreenState();
}

class _CompteurScreenState extends State<CompteurScreen> {
  int compteur = 0;

  void incrementer() {
    setState(() {
      compteur++;
    });
  }

  void reset() {
    setState(() {
      compteur = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compteur')),
      drawer: LeftDrawer(),

      body: Center(child: Text("$compteur", style: TextStyle(fontSize: 42))),

      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: AppColors.teal,
            foregroundColor: Colors.white,
            onPressed: incrementer,
            child: Icon(Icons.plus_one),
          ),
          SizedBox(width: 20,),
          FloatingActionButton(
            backgroundColor: AppColors.pink,
            foregroundColor: Colors.white,
            onPressed: reset,
            child: Icon(Icons.reset_tv),
          ),
        ],
      ),
    );
  }
}
