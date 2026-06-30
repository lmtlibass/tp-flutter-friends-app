import 'package:flutter/material.dart';
import 'package:myfriends/main.dart';
import 'package:myfriends/widgets/drawer.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController   = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulaire exemple')),

      drawer: LeftDrawer(),

      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "exemple@gmail.com",
                    suffixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vueillez saisir un email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25),

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "*********",
                    suffixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return "Le champ mots de pass doit avoir plus de 8 char..";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 25),

                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 4.2,
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.white,
                      minimumSize: Size(100, 60),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) print('ok');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 2.0,
                      children: [Text('Connexion'), Icon(Icons.login)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
