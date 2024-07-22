import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/kernel_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

final _kernelController = Get.put(KernelController());

Future<void> displayUpdateKernelParameterDialog(String key, String value, Function execute) async {
  _kernelController.selectedSystemKey.value = key;
  _kernelController.systemKernelParameterValueEditingController.text = value;
  displayAddKernelParameterDialog(execute);
}

Future<void> displayAddKernelParameterDialog(Function execute) async {
  var isUpdate = _kernelController.selectedSystemKey.isNotEmpty ? true : false;
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Kernel parameter'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          SizedBox(
            width: 370,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') return _kernelController.allKernelParameters.keys;
                    return _kernelController.filterSuggestions().keys;
                  },
                  displayStringForOption: (option) => option,
                  initialValue: isUpdate ? TextEditingValue(text: _kernelController.selectedSystemKey.value) : TextEditingValue(),
                  onSelected: (k) {
                    _kernelController.selectedSystemKey.value = k;
                    _kernelController.systemKernelParameterValueEditingController.text = _kernelController.allKernelParameters[k] ?? '';
                  },
                  optionsViewBuilder: (context, onSelected, options) => Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
                      ),
                      child: SizedBox(
                        height: 200,
                        width: 400,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          shrinkWrap: false,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return InkWell(
                              onTap: () => onSelected(option),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(option),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                    return TextField(
                      decoration: InputDecoration(
                        counterText: '',
                        label: Text('Parameters'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                        hintStyle: TextStyle(fontSize: 12),
                        isDense: true,
                        contentPadding: EdgeInsets.all(14),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      controller: textEditingController,
                      focusNode: focusNode,
                      onChanged: (e) => _kernelController.selectedSystemKey.value = e,
                    );
                  },
                ),
                // TextFieldBox(controller: _kernelController.systemKeyEditingController, label: 'Parameter', isEnable: isUpdate, maxLines: 1),
                SizedBox(height: 8),
                TextFieldBox(controller: _kernelController.systemKernelParameterValueEditingController, label: 'Value', maxLines: 1),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(onPressed: () => execute(), child: Text('Apply')),
                ),
              ],
            ),
          )
        ],
      );
    },
  );
}

Future<void> displayAddKernelModuleDialog(Function execute) async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Kernel module'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          SizedBox(
            width: 370,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldBox(controller: _kernelController.systemKernelModuleNameEditingController, label: 'name', maxLines: 1),
                SizedBox(height: 8),
                TextFieldBox(controller: _kernelController.systemKernelModuleOptionsEditingController, label: 'Options (comma delimited)', maxLines: 1),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(onPressed: () => execute(), child: Text('Apply')),
                ),
              ],
            ),
          )
        ],
      );
    },
  );
}
