import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jos_ui/component/top_menu_component.dart';

class PageLayout extends StatelessWidget {
  final Widget? child;

  const PageLayout({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/background.webp',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Color.fromARGB(150, 0, 0, 0),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: SizedBox(
                    width: 700,
                    height: 525,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TopMenuComponent(),
                        SizedBox(height: 8),
                        child ?? emptyContent(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget emptyContent() => Center(
      child: Text('Empty content',
          style: TextStyle(color: Colors.white, fontSize: 55)));
}
