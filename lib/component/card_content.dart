import 'package:flutter/material.dart';
import 'package:jos_ui/widget/breadcrumb.dart';

class CardContent extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? controllers;

  const CardContent({super.key, required this.title, this.controllers, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'cairo')),
                  Breadcrumb(
                    items: [
                      BreadcrumbItem(
                        text: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16, fontFamily: 'cairo')),
                        action: () => print('Hello'),
                      ),
                      BreadcrumbItem(
                        offset: 2,
                        text: Text('Test', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16, fontFamily: 'cairo')),
                        action: () => print('Bye'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: controllers ?? [SizedBox.shrink()],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Divider(height: 1),
              ),
              child
            ],
          ),
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(14.0),
    //   child: SizedBox(
    //     width: double.infinity,
    //     child: Card(
    //       child: Padding(
    //         padding: const EdgeInsets.all(18.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'cairo')),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   children: controllers ?? [SizedBox.shrink()],
    //                 ),
    //               ],
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
    //               child: Divider(height: 1),
    //             ),
    //             child,
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    // return Expanded(
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Container(
    //       width: double.infinity,
    //       color: secondaryColor,
    //       child: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    //                 Row(children: controllers),
    //               ],
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
    //               child: Divider(color: Colors.white24, height: 1),
    //             ),
    //             child,
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
