import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/service/api_service.dart';
import 'package:jos_ui/component/breadcrumb.dart';

class CardContent extends StatelessWidget {
  final Widget child;
  final List<Widget>? controllers;
  final _apiService = Get.put(ApiService());

  CardContent({super.key, this.controllers, required this.child});

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
                  Breadcrumb(),
                  Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: controllers ?? [SizedBox.shrink()],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Divider(height: 1),
              ),
              Obx(
                () => Visibility(
                  visible: _apiService.isLoading.isFalse,
                  replacement: Expanded(child: SpinKitCircle(color: Colors.blueAccent)),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
