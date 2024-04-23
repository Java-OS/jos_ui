import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jos_ui/component/top_menu_component.dart';

Widget getPageContent({Widget? child}) {
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
                  width: 600,
                  height: 500,
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

Widget emptyContent() => Center(child: Text('Empty content', style: TextStyle(color: Colors.white, fontSize: 55)));
