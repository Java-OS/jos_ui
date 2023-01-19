import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: AssetImage("images/Jos-Logo.png"),
          width: 40,
        ),
        Spacer(),
        TextButton(
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
          child: Text(
            "Dashboard",
            style: TextStyle(fontSize: 8),
          ),
        ),
        TextButton(
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
          child: Text(
            "Modules",
            style: TextStyle(fontSize: 8),
          ),
        ),
        TextButton(
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
          child: Text(
            "Settings",
            style: TextStyle(fontSize: 8),
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
            size: 12,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
