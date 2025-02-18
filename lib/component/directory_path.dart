import 'package:flutter/material.dart';

class DirectoryPath extends StatelessWidget {
  final double offset;
  final Function(String path)? onClick;
  final String path;

  const DirectoryPath({
    super.key,
    this.offset = 3,
    this.onClick,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    var list = <BreadcrumbItem>[];
    var pathItems = path.split('/').where((e) => e.isNotEmpty).toList();
    pathItems.insert(0, '/');

    String p = '';
    for (var i = 0; i < pathItems.length; i++) {
      p = '$p/${pathItems[i]}';
      list.add(createBredCrumbItem(pathItems[i], p, i));
    }

    list[0].isFirst = true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: offset,
      children: list,
    );
  }

  BreadcrumbItem createBredCrumbItem(String item, String path, int index) {
    var text = Text(item, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12, fontFamily: 'cairo'));
    return BreadcrumbItem(text: text, action: () => onClick!(path), index: index);
  }
}

//ignore: must_be_immutable
class BreadcrumbItem extends StatelessWidget {
  // final double width;
  final double height;
  final double offset;
  final Text text;
  bool _isFirst = false;
  final Function? action;
  final int index;

  BreadcrumbItem({
    super.key,
    this.height = 25,
    this.offset = 0,
    required this.text,
    this.action,
    required this.index,
  });

  set isFirst(bool value) {
    _isFirst = value;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _isFirst ? Offset(0, 0) : Offset((-10 * (index)) as double, 0),
      child: ClipPath(
        clipper: _isFirst ? _StartClipper() : _MiddleClipper(),
        child: SizedBox(
          // width: width,
          height: height,
          child: ElevatedButton(
            onPressed: action != null ? () => action!() : null,
            style: ElevatedButton.styleFrom(
              side: BorderSide.none,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              backgroundColor: Colors.grey[300],
              padding: EdgeInsets.zero,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
    double triangleWidth = 10;

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
    double triangleWidth = 10;

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
