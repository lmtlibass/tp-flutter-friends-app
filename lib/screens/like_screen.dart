import 'package:flutter/material.dart';
import 'package:myfriends/main.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  bool liked = false;
  void setlike() {
    setState(() {
      liked = !liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: liked ? AppColors.pink: AppColors.teal,
          foregroundColor: Colors.white,
          elevation: 10,
          padding: EdgeInsets.all(20),
          minimumSize: Size(250,80)
        ),
        onPressed: setlike, 
        child: Text(liked ? 'aimé' : 'j\'aime')
        ),
    );
  }
}
