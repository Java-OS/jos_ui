import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/authentication_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authenticationController = Get.put(AuthenticationController());

  @override
  void initState() {
    // _authenticationController.requestPublicKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Color.fromRGBO(46, 46, 46, 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 80.0),
                      child: Text(
                        'JVM/Linux operating system',
                        style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: 'smooch', fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text(
                        '⬤   Open Source Software Under GPL v2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text(
                        '⬤   Easy to use',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text(
                        '⬤   Fast and Secure',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text(
                        '⬤   Modular',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 360,
              color: Color.fromRGBO(25, 25, 25, 100),
            )
          ],
        ),
        // body: Stack(
        //   children: [
        //     Container(
        //       color: Color.fromARGB(150, 0, 0, 0),
        //       width: double.infinity,
        //       height: double.infinity,
        //       child: Center(
        //         child: Center(
        //           child: SizedBox(
        //             width: 280,
        //             height: 400,
        //             child: Card(
        //               color: Colors.transparent,
        //               shadowColor: Colors.transparent,
        //               shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white38), borderRadius: BorderRadius.zero),
        //               child: Padding(
        //                 padding: const EdgeInsets.all(14.0),
        //                 child: Column(
        //                   children: [
        //                     SvgPicture.asset(
        //                       'assets/images/jos-logo.svg',
        //                       colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        //                       height: 80,
        //                     ),
        //                     TextField(
        //                       controller: _authenticationController.usernameEditingController,
        //                       enableSuggestions: false,
        //                       autocorrect: false,
        //                       style: TextStyle(color: Colors.white),
        //                       decoration: InputDecoration(
        //                         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
        //                         enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
        //                         labelText: 'Username',
        //                         labelStyle: TextStyle(color: Colors.white38, fontSize: 12),
        //                         contentPadding: EdgeInsets.all(14),
        //                       ),
        //                       onSubmitted: (_) => _authenticationController.login(),
        //                     ),
        //                     SizedBox(height: 10),
        //                     TextField(
        //                       controller: _authenticationController.passwordEditingController,
        //                       obscureText: true,
        //                       enableSuggestions: false,
        //                       autocorrect: false,
        //                       style: TextStyle(color: Colors.white),
        //                       decoration: InputDecoration(
        //                         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
        //                         enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
        //                         labelText: 'Password',
        //                         labelStyle: TextStyle(color: Colors.white38, fontSize: 12),
        //                         contentPadding: EdgeInsets.all(14),
        //                       ),
        //                       onSubmitted: (_) => _authenticationController.login(),
        //                     ),
        //                     SizedBox(height: 10),
        //                     SizedBox(
        //                       height: 50,
        //                       width: double.infinity,
        //                       child: Row(
        //                         crossAxisAlignment: CrossAxisAlignment.center,
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           Expanded(
        //                             child: SizedBox(
        //                               height: 50,
        //                               child: Stack(
        //                                 alignment: Alignment.center,
        //                                 children: [Obx(() => captchaWidget())],
        //                               ),
        //                             ),
        //                           ),
        //                           SizedBox(
        //                             width: 50,
        //                             height: 50,
        //                             child: OutlinedButton(
        //                               style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, side: BorderSide(color: Colors.white30)),
        //                               onPressed: () => _authenticationController.requestPublicKey(),
        //                               child: Icon(Icons.refresh, size: 28, color: Colors.blue),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     SizedBox(height: 10),
        //                     TextField(
        //                       controller: _authenticationController.captchaEditingController,
        //                       enableSuggestions: false,
        //                       autocorrect: false,
        //                       style: TextStyle(color: Colors.white),
        //                       decoration: InputDecoration(
        //                         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
        //                         enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
        //                         labelText: 'Captcha',
        //                         labelStyle: TextStyle(color: Colors.white38, fontSize: 12),
        //                         contentPadding: EdgeInsets.all(14),
        //                       ),
        //                       onSubmitted: (_) => _authenticationController.login(),
        //                     ),
        //                     SizedBox(height: 10),
        //                     SizedBox(
        //                       width: double.infinity,
        //                       height: 50,
        //                       child: ElevatedButton(onPressed: () => _authenticationController.login(), child: Text('Login')),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }

  Widget captchaWidget() {
    return Visibility(
      visible: _authenticationController.captchaImage.value != null,
      replacement: SizedBox(width: 16, height: 16, child: CircularProgressIndicator()),
      child: ClipRRect(borderRadius: BorderRadius.circular(3), child: _authenticationController.captchaImage.value),
    );
  }
}
