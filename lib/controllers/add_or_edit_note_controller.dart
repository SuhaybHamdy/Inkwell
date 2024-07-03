import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inkwell/models/background.dart';
import 'package:inkwell/models/note.dart';
import 'package:inkwell/services/ai_suggest.dart';
import '../models/category.dart';
import '../models/schedule.dart';
import '../models/tag.dart';
import '../services/category_service.dart';
import '../services/local_storage_service.dart';
import 'add_or_edit/ai_note_suggester_data.dart';
import 'add_or_edit/variables_mixin.dart';
import 'note_controller.dart';

class AddOrEditNoteController extends GetxController
    with VariableMixin, ExtensionServiceFunction, AiNoteSuggesterData {
  final NotesService _notesService = NotesService();
  final CategoryService _categoryService = CategoryService();
  Note? currentNote;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  QuillController quillController = QuillController.basic();

  bool isShowToolbar = true;
  RxBool expanded = RxBool(true);
  RxBool isEditable = RxBool(false);

  // RxList<Category> categories = RxList<Category>();
  // Rx<Category?> selectedCategory = Rx<Category?>(null);

  Rx<String?> selectedImage = Rx<String?>(null);
  RxBool isColorMode = true.obs;

  Schedule? schedule;

  List<MaterialColor> noteColors = [];
  List<String> images = [
    'assets/image/notes_wallpeper/notes_wallpeper 1.jpg',
    'assets/image/notes_wallpeper/notes_wallpeper 2.webp',
    'assets/image/notes_wallpeper/notes_wallpeper 3.jpg',
    'assets/image/notes_wallpeper/notes_wallpeper 4.jpg',
    'assets/image/notes_wallpeper/notes_wallpeper 5.jpg',
  ];

  List<Tag> tags = [
    Tag(
      id: '1',
      name: 'football',
    ),
    Tag(
      id: '2',
      name: 'basketball',
    ),
    Tag(
      id: '3',
      name: 'swimming',
    ),
  ];

  RxBool isOverlayVisible = false.obs;

  void toggleOverlay() {
    isOverlayVisible.toggle();
    update();
  }

  RxBool isImportant = RxBool(false);
  RxBool isHint = RxBool(false);

  List<String> attachments = ['agenda.pdf', 'presentation.pptx'];

  RxString priority = RxString('Low');

  @override
  void onInit() {
    super.onInit();
    initAll();
    initColors();
  }

  initAll() async {
    await initializeNote();
    await loadCategories().whenComplete(() {
      getTheCategoryListString();

      if (currentNote != null) {
        if (currentNote!.category != null) {
          for (var category in categories.value) {
            if (category.id.toString() == currentNote!.category) {
              selectedCategory.value = category;
            }
          }
        }

// Initialize the selected color
        if (currentNote!.background?.type == 'color' &&
            currentNote!.background?.value != null) {
          isColorMode.value = true;
          final colorValue = parseColor(currentNote!.background!.value!);
          noteColors.firstWhere((color) => color.value == colorValue,
              orElse: () => noteColors[0]);
        }

        // Initialize the selected image
        if (currentNote!.background?.type == 'wallpaper' &&
            currentNote!.background?.value != null) {
          isColorMode.value = false;
          selectedImage.value = currentNote!.background!.value;
        }
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    selectedCategory.value = null;
    selectedImage.value = null;
    categories.value = [];
  }

  void initColors() {
    noteColors = [
      createMaterialColor(Color(0xffd43b71)),
      createMaterialColor(Color(0xff2baa84)),
      createMaterialColor(Color(0xffec9f29)),
      createMaterialColor(Color(0xffd0a013)),
      createMaterialColor(Color(0xffff9800)),
      createMaterialColor(Color(0xffeed68a)),
      createMaterialColor(Color(0xffd8b1ff)),
      createMaterialColor(Color(0xfff02a7)),
      createMaterialColor(Color(0xff07b7cc)),
      createMaterialColor(Color(0xff009688)),
    ];
  }

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

  void updateSelectedImage(String newImage) {
    // if (!isColorMode.value && selectedColor.value != null) {
    //   selectedColor.value = null;
    // }

    selectedImage.value = newImage;

    final newBackground = Background(type: 'wallpaper', value: newImage);
    currentNote = (currentNote ?? Note()).copyWith(background: newBackground);

    update();
  }

  void toggleMode() {
    isColorMode.value = !isColorMode.value;
  }

  Future<void> pickImageFromStorage(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Camera"),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    updateSelectedImage(image.path);
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    updateSelectedImage(image.path);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void updateSelectedCategory(Category? newValue) {
    selectedCategory.value = newValue!;
    currentNote!.category = newValue.id;
    update();
  }

  void updateSelectedColor(Color newColor) {
    isColorMode.value == true ? selectedImage.value = null : null;
    selectedColor = newColor.obs;
    currentNote = currentNote != null
        ? currentNote!.copyWith(
            color: selectedColor.value,
            background: Background(
                type: 'color', value: selectedColor.value.toString()))
        : Note(
            color: selectedColor.value,
            background: Background(
                type: 'color', value: selectedColor.value.toString()));
    ;
    update();
  }

  final uniqueCategories = <Category>{}; // Using a Set to ensure uniqueness

  Future<void> loadCategories() async {
    final fetchedCategories = await _categoryService.getCategories();

    // Add each category to the set
    for (var category in fetchedCategories) {
      uniqueCategories.add(category);
    }

    // Convert the set back to a list and assign to categories
    categories.assignAll(uniqueCategories.toList());
  }

  Future<void> initializeNote() async {
    final arguments = Get.arguments;
    if (arguments != null && arguments is String) {
      currentNote = await _findNoteById(arguments);
      isEditable.value == true;
      print(
          'this is the current note content: ${currentNote?.content ?? 'null ${isEditable.value}'}');
    } else {
      isEditable.value == false;
    }

    if (currentNote != null) {
      await _initializeQuillControllerWithNoteContent(currentNote!);
    } else {
      _initializeBasicQuillController();
    }
    update();
  }

  Note? _findNoteById(String id) {
    final notesController = Get.find<NotesController>();
    return notesController.notes.firstWhereOrNull((note) => note.id == id);
  }

  Future<void> _initializeQuillControllerWithNoteContent(Note note) async {
    try {
      print('Initializing QuillController with note content.');

      // Set the note title
      titleController.text = note.title ?? '';
      print('Set note title: ${note.title ?? 'No Title'}');

      // Determine if the note content is JSON-formatted or plain text
      List<dynamic> deltaJson;
      if (note.content?.contains('insert') ?? false) {
        // If JSON-formatted, decode it
        print(
            'Note content might be JSON-formatted.1 ${note.content.runtimeType}');

        var decodedContent = jsonDecode(note.content!);

        if (decodedContent is List) {
          deltaJson = decodedContent;
          print('Note content is JSON-formatted: 2 ${deltaJson.toString()}');
        } else {
          throw FormatException('JSON is not a list');
        }
        print('Note content is JSON-formatted.3');

        print('Note content is JSON-formatted. :${deltaJson.toString()}');
      } else {
        // If plain text, convert it to Quill-compatible format
        print('Note content is plain text.');
        deltaJson = [
          {"insert": note.content ?? ''}
        ];
      }

      // Ensure the last insert operation ends with a newline character
      if (deltaJson.isNotEmpty) {
        var lastOperation = deltaJson.last;
        if (lastOperation is Map<String, dynamic> &&
            lastOperation.containsKey('insert')) {
          if (!(lastOperation['insert'] as String).endsWith('\n')) {
            lastOperation['insert'] = lastOperation['insert'] + '\n';
          }
        }
      }

      final delta = Delta.fromJson(deltaJson);
      print('Converted Delta: ${delta.toString()}');

      // Initialize the QuillController with the Delta document
      quillController = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
      print('QuillController initialized with document.');
      // Additional initialization logic can go here if needed
    } catch (e) {
      print('Error initializing QuillController: $e');
      _initializeBasicQuillController();
    }
    update();
  }

  void _initializeBasicQuillController() {
    // Fallback initialization logic for the QuillController
    quillController = QuillController.basic();
    print('Initialized basic QuillController');
  }

  String extractPlainTextFromNoteContent(Note note) {
    try {
      final deltaJson = jsonDecode(note.content ?? '[]') as List<dynamic>;
      final delta = Delta.fromJson(deltaJson);
      var controllerQuill = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
      return controllerQuill.document.toPlainText();
    } catch (e) {
      return '';
    }
  }

  Future<void> saveNote() async {
    if (currentNote != null) {
      currentNote!.title = titleController.text;
      currentNote!.content =
          jsonEncode(quillController.document.toDelta().toJson());

      try {
        await _notesService.addNote(currentNote!);
        final notesController = Get.find<NotesController>();
        final index = notesController.notes
            .indexWhere((note) => note.id == currentNote!.id);
        if (index != -1) {
          notesController.notes[index] = currentNote!;
        } else {
          notesController.notes.add(currentNote!);
        }
        notesController.filteredNotes.assignAll(notesController.notes);
      } catch (e) {
        _showErrorSnackbar('Failed to save note: $e');
      }
    }
  }

  void editNote() {
    if (currentNote != null) {
      final notesController = Get.find<NotesController>();
      final index = notesController.notes
          .indexWhere((note) => note.id == currentNote!.id);
      if (index != -1) {
        notesController.notes[index] = currentNote!;
        notesController.update();
      } else {
        _showErrorSnackbar('Note not found for editing');
      }
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  void toggleToolbar() {
    isShowToolbar = !isShowToolbar;
  }

  NotesService notesService = NotesService();

  // now recode this in bsat way
  Future<void> saveOrUpdateNote({
    Note? currentNote,
  }) async {
    currentNote ??= this.currentNote;
    final contentJson = currentNote?.content != null
        ? jsonEncode(currentNote?.content)
        : jsonEncode(quillController.document.toDelta().toJson());

    if (currentNote != null) {
      _printNoteDetails(currentNote);
    }

    final newNote = Note(
      id: currentNote?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: currentNote?.title ?? titleController.text,
      isImportant: currentNote?.isImportant,
      content: contentJson,
      date: currentNote?.date,
      tags: currentNote?.tags,
      color: parseColor(currentNote?.background?.value),
      category: currentNote?.category,
      background: currentNote?.background,
      location: currentNote?.location,
      attachments: currentNote?.attachments,
      isHint: currentNote?.isHint,
      reminder: currentNote?.reminder,
      lastEdited: DateTime.now(),
      author: currentNote?.author,
      priority: currentNote?.priority,
      checklist: currentNote?.checklist,
      relatedLinks: currentNote?.relatedLinks,
      collaborators: currentNote?.collaborators,
      status: currentNote?.status,
      repeatInterval: currentNote?.repeatInterval ?? schedule,
    );
    print('this is the created note ${newNote.toJson()}');
    await _saveOrUpdateNoteInService(newNote, notesService);

    Get.find<NotesController>().loadNotes();
    Get.back();
  }

  void _printNoteDetails(Note currentNote) {
    print(
        'Color item: ${currentNote.color ?? 'null color'} - Background: ${currentNote.background?.value ?? 'null background'}');
    print('ID: ${currentNote.id}');
    print('Title: ${currentNote.title}');
    print('Content: (JSON data omitted)');
    print('Date: ${currentNote.date}');
    print('Tags: ${currentNote.tags?.join(', ') ?? 'no tags'}');
    print('Category: ${currentNote.category}');
    print('Location: ${currentNote.location}');
    print('Attachments: ${currentNote.attachments?.length ?? 0}');
    print('Reminder: ${currentNote.reminder ?? 'no reminder'}');
    print('Author: ${currentNote.author ?? 'no author'}');
    print('Priority: ${currentNote.priority ?? 'no priority'}');
    print('Checklist: ${currentNote.checklist ?? 'no checklist'}');
    print('Related Links: ${currentNote.relatedLinks ?? 'no related links'}');
    print('Collaborators: ${currentNote.collaborators ?? 'no collaborators'}');
    print('Status: ${currentNote.status ?? 'no status'}');
    print(
        'Repeat Interval: ${currentNote.repeatInterval ?? 'no repeat interval'}');
  }

  Future<void> _saveOrUpdateNoteInService(
      Note newNote, NotesService notesService) async {
    if (isEditable.isFalse) {
      await notesService.addNote(newNote);
    } else {
      await notesService.updateNote(newNote);
    }
  }

  void updateStartDateTime(DateTime dateTime) {
    startDateTime.value = dateTime;
  }

  void updateEndDateTime(DateTime dateTime) {
    endDateTime.value = dateTime;
  }

  void toggleAllDay(bool value) {
    isAllDay.value = value;
    if (value) {
      var now = DateTime.now();
      startDateTime.value = DateTime(now.year, now.month, now.day);
      endDateTime.value = DateTime(now.year, now.month, now.day + 1);
    } else {
      startDateTime.value = DateTime.now();
      endDateTime.value = DateTime.now().add(Duration(hours: 1));
    }
    update();
  }

  selectedCategoryNullable() {
    print(
        "selectedCategory is : ${selectedCategory.value?.name ?? 'null value - and the category is ${categories.length} or is null '}");
    // items == null || items.isEmpty || value == null
    if (selectedCategory == null ||
        categories.value.isEmpty ||
        categories.value == null ||
        selectedCategory.value == null) {
      return null;
    } else {
      return selectedCategory.value;
    }
  }

  String categoryListString = '';

  void getTheCategoryListString() {
    categories.value.forEach((element) {
      categoryListString += element.toJson().toString();
    });
  }

  int count = 4;

  void addTag(String value) {
    tags.add(Tag(id: '$count', name: value));
    List<String> tagsName = [];
    for (var element in tags) {
      tagsName.add(element.name!);
    }
    currentNote = currentNote!.copyWith(tags: tagsName);
    count++;
    update();
  }

  void toggleImportant() {
    isImportant.value = !isImportant.value;
    currentNote = currentNote!.copyWith(isImportant: isImportant.value);
    update();
  }

  void toggleHint() {
    isHint.value = !isHint.value;
    currentNote = currentNote!.copyWith(isHint: isHint.value);
    update();
  }

  void removeAttachment(String attachment) {
    attachments.removeWhere((element) => element == attachment);
    currentNote = currentNote!.copyWith(attachments: attachments!);

    update();
  }

  int countImage = 0;

  void addAttachment() {
    String value = 'image_$countImage';
    attachments.add(value);
    currentNote = currentNote!.copyWith(attachments: attachments!);
    countImage++;
    update();
  }

  void updatePriority(String s) {
    priority.value = s;
    currentNote = currentNote!.copyWith(priority: priority.value!);
    update();
  }

  final RxList<String> checklist = <String>[].obs;
  final RxSet<String> completedItems = <String>{}.obs;

  void addChecklistItem(String item) {
    checklist.add(item);
    currentNote!.checklist =
        checklist.toList(); // Ensure to update currentNote if needed
    update();
  }

  void toggleChecklistItem(String item) {
    if (completedItems.contains(item)) {
      completedItems.remove(item);
    } else {
      completedItems.add(item);
    }

    update();
  }

  bool isItemCompleted(String item) {
    return completedItems.contains(item);
  }

  AiSuggesterService aiSuggesterService = AiSuggesterService();
  RxBool suggestionsLoading = false.obs;

  Future<void> generateContentUsingAI() async {
    print('بدء تحميل الاقتراحات...');
    suggestionsLoading = true.obs;
    update();

    try {
      // الحصول على استجابات الذكاء الاصطناعي
      final String aiResponse = await getAIContentResponse(titleController);
      print('استجابة الذكاء الاصطناعي للمحتوى: $aiResponse');

      // تحليل استجابة الذكاء الاصطناعي إلى مصفوفة Quill Delta JSON وتحديث المتحكم
      print('تحليل استجابة الذكاء الاصطناعي إلى مصفوفة Quill Delta JSON...');
      final List<dynamic> deltaJson = _parseAIResponse(aiResponse);
      print('تحديث متحكم Quill بالمحتوى الجديد...');
      _updateQuillControllerWithNewContent(deltaJson);

      final String aiTitleResponse = await getAITitleResponse(aiResponse);
      print('استجابة الذكاء الاصطناعي للعناوين: $aiTitleResponse');

      // تحديث نص العنوان باستخدام العنوان المقترح من الذكاء الاصطناعي
      print('تحديث نص العنوان بالمقترح من الذكاء الاصطناعي...');
      titleController.text = aiTitleResponse;

      final String aiBackgroundResponse = await getAIBackgroundResponse(aiResponse);
      print('استجابة الذكاء الاصطناعي للخلفية: $aiBackgroundResponse');

      // فك تشفير استجابة الخلفية وإنشاء كائن الخلفية
      print('فك تشفير استجابة الخلفية...');
      Map<String, dynamic> decodedJson = jsonDecode(aiBackgroundResponse);
      Background background = Background.fromJson(decodedJson);
      print('كائن الخلفية الذي تم إنشاؤه: ${background.toJson()}');

      // تحديث الملاحظة الحالية بالخلفية المقترحة
      print('تحديث الملاحظة الحالية بالخلفية المقترحة...');
      currentNote = currentNote?.copyWith(background: background);

      final String aiCategoryResponse = await getAICategoryResponse(aiResponse, categories);
      print('استجابة الذكاء الاصطناعي للفئات: $aiCategoryResponse');

      // تحديث الفئة المحددة
      print('تحديث الفئة المحددة...');
      final selectedCategory = categories.value.firstWhere(
            (element) => element.id == aiCategoryResponse,
        orElse: () => categories.value.first, // Fallback to first category if not found
      );
      print('تم تحديث الفئة المحددة: ${selectedCategory.id}');
      currentNote = currentNote?.copyWith(category: selectedCategory.id);
      update();

      // الحصول على قائمة المراجعة المقترحة من الذكاء الاصطناعي
      print('جاري الحصول على قائمة المراجعة من الذكاء الاصطناعي...');
      List<String> checklist = await getAICheckListResponse(aiResponse);
      print('تحديث قائمة المراجعة...');
      currentNote = currentNote!.copyWith(checklist: checklist);
      print('قائمة المراجعة المحدثة: ${currentNote!.checklist}');
    } catch (e) {
      print('حدث خطأ: $e');
      Fluttertoast.showToast(
        msg: "حدث خطأ أثناء جلب البيانات: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      _handleError(e);
    }

    print('انتهاء تحميل الاقتراحات.');
    suggestionsLoading = false.obs;
    update();
  }

  List<dynamic> _parseAIResponse(String response) {
    try {
      return jsonDecode(response) as List<dynamic>;
    } catch (e) {
      throw FormatException('Failed to parse AI response as JSON: $e');
    }
  }

  void _updateQuillControllerWithNewContent(List<dynamic> deltaJson) {
    final delta = Delta.fromJson(deltaJson);
    quillController = QuillController(
      document: Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );
    print('QuillController initialized with AI-generated content.');
  }

  void _handleError(dynamic error) {
    print('Error generating content: $error');
    _initializeBasicQuillController();
  }

  /// Constructs a query to suggest a checklist for the given content.
  ///
  /// [aiResponse] is the content for which the checklist suggestion is needed.
  // String _constructCheckListAIQuery(String aiResponse) {
  //   return _getLocalizedString('checklistPrompt', {'aiResponse': aiResponse});
  // }

  /// Gets the AI-suggested checklist response for the given content.
  ///
  /// [aiResponse] is the response from the AI.
  // Future<List<String>> getAICheckListResponse(String aiResponse) async {
  //   final checklistQuery = _constructCheckListAIQuery(aiResponse);
  //   final responseCheckList =
  //       await aiSuggesterService.suggestItems(checklistQuery, []);
  //   return List<String>.from(jsonDecode(responseCheckList));
  // }

  // Example method usage
  Future<void> updateNoteWithChecklist(
      Note currentNote, String aiResponse) async {}

//   Future<void> witeTheContentUsignAI() async {
//     // Document.fromDelta(delta)
//     String query =
//         'write the content of this using the quill document delta json to return  the List<dynamic>  \"${titleController.text}';
//     print('this is the query is :  ${query}');
//
//     var item = await iaSuggesterService.suggestItems(query, []);
//     print('this is the type of the suggestion: ${item}');
//     item=item.toString().replaceAll('json', '');
//     item=item.toString().replaceAll('```', '');
//     // print('this is the type of the suggestion: ${item}');
//
//     var deltaJson = jsonDecode(item);
//     print('this is the type of the josn: ${deltaJson.runtimeType}');
//
// // if(deltaJson.runtimeType==List<dynamic>){
// //   print('the suggestion json is a list of dynamic objects');
// //
// //   final delta = Delta.fromJson(deltaJson);
// //   print('Converted Delta: ${delta.toString()}');
// //
// //   // Initialize the QuillController with the Delta document
// //   quillController = QuillController(
// //     document: Document.fromDelta(delta),
// //     selection: const TextSelection.collapsed(offset: 0),
// //   );
// // }
//     try {
//       // Ensure the last insert operation ends with a newline character
//       // if (deltaJson.isNotEmpty) {
//       //   var lastOperation = deltaJson.last;
//       //   if (lastOperation is Map<String, dynamic> &&
//       //       lastOperation.containsKey('insert')) {
//       //     if (!(lastOperation['insert'] as String).endsWith('\n')) {
//       //       lastOperation['insert'] = lastOperation['insert'] + '\n';
//       //     }
//       //   }
//       // }
//
//       // final delta = Delta.fromJson(deltaJson);
//       // print('Converted Delta: ${delta.toString()}');
//       //
//       // // Initialize the QuillController with the Delta document
//       // quillController = QuillController(
//       //   document: Document.fromDelta(delta),
//       //   selection: const TextSelection.collapsed(offset: 0),
//       // );
//       print('QuillController initialized with document.');
//       // Additional initialization logic can go here if needed
//     } catch (e) {
//       print('Error initializing QuillController: $e');
//       _initializeBasicQuillController();
//     }
//     update();
//   }
}
