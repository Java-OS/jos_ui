import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({Key? key}) : super(key: key);

  static String currentPage = '/';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: AssetImage("images/Jos-Logo.png"),
          width: 80,
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            goto('/',context);
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.white;
                } else {
                  return Colors.white54;
                }
              },
            ),
          ),
          child: Text(
            "Dashboard",
            style: TextStyle(fontSize: 18),
          ),
        ),
        TextButton(
          onPressed: () {
            goto('/modules',context);
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.white;
                } else {
                  return Colors.white54;
                }
              },
            ),
          ),
          child: Text(
            "Modules",
            style: TextStyle(fontSize: 18),
          ),
        ),
        TextButton(
          onPressed: () {
            goto('/settings',context);
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.white;
                } else {
                  return Colors.white54;
                }
              },
            ),
          ),
          child: Text(
            "Settings",
            style: TextStyle(fontSize: 18),
          ),
        ),
        IconButton(
          onPressed: () {},
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.white;
                } else {
                  return Colors.white54;
                }
              },
            ),
          ),
          icon: Icon(
            Icons.logout,
            size: 18,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  void goto(String target,BuildContext context) {
    if (currentPage != target)  {
      Navigator.of(context).pushReplacementNamed(target);
      currentPage = target;
    }
  }
}
