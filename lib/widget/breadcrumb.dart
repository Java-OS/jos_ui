import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';

class Breadcrumb extends StatelessWidget {
  final double offset;

  const Breadcrumb({super.key, this.offset = 3});

  @override
  Widget build(BuildContext context) {
    var currentRoute = Get.currentRoute;
    var list = <BreadcrumbItem>[];

    String path = '/';
    for (var value in currentRoute.split('/')) {
      if (value.isNotEmpty) {
        path = path + value;
        list.add(createBredCrumbItem(path));
        path = '$path/';
      }
    }

    list[0].isFirst = true;
    list[0].color = Colors.grey;
    return Row(
      spacing: offset,
      children: list,
    );
  }

  BreadcrumbItem createBredCrumbItem(String path) {
    var text = Text(Routes.find(path).title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16, fontFamily: 'cairo'));
    return BreadcrumbItem(text: text, action: () => navigator!.pushNamed(path));
  }
}

//ignore: must_be_immutable
class BreadcrumbItem extends StatelessWidget {
  // final double width;
  final double height;
  final double offset;
  final Text text;
  Color color;
  bool _isFirst = false;
  final Function action;

  BreadcrumbItem({super.key, this.height = 40, this.offset = 0, required this.text, this.color = Colors.blueAccent, required this.action});

  set isFirst(bool value) {
    _isFirst = value;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _isFirst ? Offset(0, 0) : Offset(-15, 0),
      child: ClipPath(
        clipper: _isFirst ? _StartClipper() : _MiddleClipper(),
        child: SizedBox(
          // width: width,
          height: height,
          child: ElevatedButton(
            onPressed: _isFirst ? null : () => action(),
            style: ElevatedButton.styleFrom(
              side: BorderSide.none,
              disabledBackgroundColor: color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              backgroundColor: color,
              padding: EdgeInsets.zero,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: !_isFirst ? 25 : 20.0, right: _isFirst ? 25 : 20.0),
              child: text,
            ),
          ),
        ),
      ),
    );
  }
}

class _StartClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double triangleWidth = 15;

    path.moveTo(0, 0);
    path.lineTo(size.width - triangleWidth, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - triangleWidth, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _MiddleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double triangleWidth = 15;

    path.moveTo(0, 0);
    path.lineTo(size.width - triangleWidth, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - triangleWidth, size.height);
    path.lineTo(0, size.height);
    path.lineTo(triangleWidth, size.height / 2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
