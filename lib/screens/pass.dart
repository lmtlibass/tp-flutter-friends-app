import 'package:flutter/material.dart';
import 'package:myfriends/widgets/drawer.dart';

class PassScreen extends StatefulWidget {
  const PassScreen({super.key});

  @override
  State<PassScreen> createState() => _PassScreenState();
}

class _PassScreenState extends State<PassScreen> {
  bool obscure = false;
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mot de ass')),

      drawer: LeftDrawer(),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.20),

          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() => email = value);
                },
              ),

              TextField(
                 onChanged: (value) {
                  setState(() => password = value);
                },
                obscureText: obscure,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => obscure = !obscure);
                    },
                  ),
                ),
              ),

              Text("email $email"),
              Text("pasword: $password"),
            ],
          ),
        ),
      ),
    );
  }
}
