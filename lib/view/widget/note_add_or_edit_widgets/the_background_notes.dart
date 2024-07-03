import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../../../controllers/add_or_edit_note_controller.dart';

class TheBackgroundNotes extends StatelessWidget {
  final AddOrEditNoteController controller = Get.put(AddOrEditNoteController());

  TheBackgroundNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Color"),
              Switch(
                value: controller.isColorMode.value,
                onChanged: (value) {
                  controller.toggleMode();
                },
              ),
              const Text("Image"),
            ],
          );
        }),
        Obx(() {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: controller.isColorMode.value
                ? _buildColorChoices(context)
                : _buildImageChoices(context),
          );
        }),
      ],
    );
  }
  Widget _buildColorChoices(BuildContext context) {

      return Wrap(
        spacing: 8.0,
        children: [
          ...controller.noteColors.map((color) {
            return GestureDetector(
              onTap: () {
                controller.updateSelectedColor(color);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: controller.selectedColor.value == color
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                  border: Border.all(
                    color: controller.selectedColor.value == color
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ),
            );
          }).toList(),
          GestureDetector(
            onTap: () => _pickColor(context),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              child: Icon(
                Icons.add,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          )
        ],
      );

  }

  Widget _buildImageChoices(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 8.0,
        children: [
          ...controller.images.map((image) {
            return GestureDetector(
              onTap: () {
                controller.updateSelectedImage(image);
              },
              child: Container(
                width: 45,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: controller.selectedImage.value == image
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ),
            );
          }).toList(),
          GestureDetector(
            onTap: () => controller.pickImageFromStorage(context),
            child: Container(
              width: 45,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              child: Icon(
                Icons.add,
                size: 24,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      );
    });
  }

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        Color? pickerColor = controller.selectedColor.value;
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor ?? Colors.blue,
              onColorChanged: (color) {
                pickerColor = color;
              },
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                Color newColor = pickerColor ?? Colors.blue;
                MaterialColor materialColor = controller.createMaterialColor(newColor);
                if (!controller.noteColors.contains(materialColor)) {
                  controller.noteColors.add(materialColor);
                }

                controller.updateSelectedColor(controller.noteColors.last);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Color? parseColor() =>controller.currentNote==null?null: controller.parseColor(controller.currentNote!.background!.value);

}
