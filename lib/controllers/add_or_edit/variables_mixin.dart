import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:inkwell/models/note.dart';

import '../../models/category.dart';
import '../../models/schedule.dart';
import '../../services/category_service.dart';
import '../../services/local_storage_service.dart';

mixin VariableMixin {
  // Services
  final NotesService _notesService = NotesService();
  final CategoryService _categoryService = CategoryService();

  // Note related
  Note? currentNote;

  // Controllers
  final TextEditingController titleController = TextEditingController();
  QuillController quillController = QuillController.basic();



  // Category related
  RxList<Category> categories = RxList<Category>();
  Rx<Category?> selectedCategory = Rx<Category?>(null);

  // Image related
  Rx<String?> selectedImage = Rx<String?>(null);

  // Color related
  Rx<Color?> selectedColor = Rx<Color?>(null);


  // Mode toggle
  RxBool isColorMode = true.obs;

  // Schedule related
  Schedule? schedule;

  // Note colors
  List<MaterialColor> noteColors = [];

  // Predefined images
  List<String> images = [
    'assets/image/notes_wallpeper/notes_wallpeper 1.jpg',
    'assets/image/notes_wallpeper/notes_wallpeper 2.webp',
    'assets/image/notes_wallpeper/notes_wallpeper 3.jpg',
    'assets/image/notes_wallpeper/notes_wallpeper 4.jpg',
    'assets/image/notes_wallpeper/notes_wallpeper 5.jpg',
  ];

  // All-day event toggle
  var isAllDay = false.obs;

  // Event times
  var startDateTime = DateTime.now().obs;
  var endDateTime = DateTime.now().add(Duration(hours: 1)).obs;

  // Timezone
  var timezone = 'التوقيت العربي الرسمي'.obs;
}


mixin ExtensionServiceFunction {
  Color? invertColor(Color? color) {
    if (color != null) {
      return Color.fromARGB(
        color.alpha,
        255 - color.red,
        255 - color.green,
        255 - color.blue,
      );
    }
    return null;
  }

  Color parseColor(String? colorString) {
    if (colorString != null &&
        colorString.startsWith('MaterialColor(primary value: Color(') &&
        colorString.endsWith('))')) {
      print('is in condition');
      final startIndex = colorString.indexOf('0x') + 2;
      final endIndex = colorString.indexOf(')', startIndex);
      final hexString = colorString.substring(startIndex, endIndex);
      final colorValue = int.parse(hexString, radix: 16);
      return Color(colorValue);
    }
    return Colors.transparent;
  }

// this is important function it used to return the color value for the add or edit note controller
  MaterialColor createMaterialColor(Color color) {
    List<double> strengths = [.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}

