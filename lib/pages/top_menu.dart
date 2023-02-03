import 'package:flutter/material.dart';
import 'package:jos_ui/component/TextLogo.dart';
import 'package:jos_ui/service/SecurityService.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({Key? key}) : super(key: key);

  static String currentPage = '/';
  static bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextLogo(
          color: Colors.white,
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            goto('/', context);
          },
          style: ButtonStyle(
            foregroundColor: setButtonColor('/'),
          ),
          child: Text(
            "Dashboard",
            style: TextStyle(fontSize: 18),
          ),
        ),
        TextButton(
          onPressed: () {
            goto('/modules', context);
          },
          style: ButtonStyle(foregroundColor: setButtonColor("/modules")),
          child: Text(
            "Modules",
            style: TextStyle(fontSize: 18),
          ),
        ),
        TextButton(
          onPressed: () {
            goto('/settings', context);
          },
          style: ButtonStyle(foregroundColor: setButtonColor("/settings")),
          child: Text(
            "Settings",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 80),
          child: IconButton(
            style: ButtonStyle(foregroundColor: setButtonColor(null)),
            color: Colors.white54,
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ),
      ],
    );
  }

  MaterialStateProperty<Color> setButtonColor(String? page) {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return Colors.white;
        } else if (page == currentPage) {
          return Colors.yellowAccent;
        } else {
          return Colors.white54;
        }
      },
    );
  }

  void goto(String target, BuildContext context) {
    if (currentPage != target) {
      Navigator.of(context).pushReplacementNamed(target);
      currentPage = target;
    }
  }

  void logout(BuildContext context) {
    SecurityService.logout()
        .then((value) => Navigator.of(context).pushReplacementNamed("/login"));
  }
}
