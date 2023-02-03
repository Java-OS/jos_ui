import 'package:flutter/material.dart';
import 'package:jos_ui/component/TextLogo.dart';
import 'package:jos_ui/service/SecurityService.dart';

import '../component/BlurCard.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: BlurCard(
            height: 300,
            width: 330,
            border: Border.all(color: Colors.blueGrey, width: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: TextLogo(color: Colors.black,),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: usernameController,
                    onSubmitted: (_) {
                      login(context);
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      labelText: "Username",
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    onSubmitted: (_) {
                      login(context);
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.key),
                      labelText: "Password",
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero)),
                    child: Text("Login"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) {
    var future =
        SecurityService.login(usernameController.text, passwordController.text);
    future.then((value) => value
        ? Navigator.of(context).pushReplacementNamed("/")
        : print('Invalid credentials'));
  }
}
