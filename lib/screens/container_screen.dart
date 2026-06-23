import 'package:flutter/material.dart';
import 'package:myfriends/main.dart';
import 'package:myfriends/widgets/drawer.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  Color color = AppColors.gray;

  void changeColor() {
    setState(() {
      color == AppColors.gray ? color = AppColors.pink : color = AppColors.gray;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('container')),

      drawer: LeftDrawer(),

      body: Center(
        child: Column(
          children: [
            Container(height: 200, width: 800, color: color),
            ElevatedButton(onPressed: changeColor, child: Text('changer couleur'))
          ],
        ),
      ),
    );
  }
}
