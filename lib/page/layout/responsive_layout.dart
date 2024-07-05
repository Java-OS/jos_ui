import 'package:flutter/material.dart';
import 'package:jos_ui/page/layout/desktop_scaffold.dart';
import 'package:jos_ui/page/layout/mobile_scaffold.dart';
import 'package:jos_ui/page/layout/tablet_scaffold.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget body;

  const ResponsiveLayout({super.key, required this.body});

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 850 && MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return MobileScaffold(content: body);
    } else if (isTablet(context)) {
      return TabletScaffold(content: body);
    } else {
      return DesktopScaffold(content: body);
    }
  }
}
