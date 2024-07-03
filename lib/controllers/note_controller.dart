import 'dart:convert';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inkwell/models/note.dart';
import 'package:inkwell/services/category_service.dart';
import '../models/category.dart';
import '../services/local_storage_service.dart';
import '../routes/app_routes.dart';
import '../theme/util.dart';

class NotesController extends GetxController {
  final RxList<Note> notes = RxList<Note>([]);
  final NotesService _notesService = NotesService();
  final TextEditingController searchController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final GetStorage _box = GetStorage();
  final CategoryService _categoryService = CategoryService();

  ScrollController scrollController = ScrollController();

  RxBool isAuth = RxBool(true);
  RxBool isDateSelected = RxBool(false);
  var filteredNotes = <Note>[].obs;

  RxDouble startHour = RxDouble(1);
  RxDouble endHour = RxDouble(23);

  final dayViewKey = GlobalKey<DayViewState>();

  RxDouble scrollOffset = 0.0.obs;

  final ScrollController hoursScrollController = ScrollController();

  String categoryListString = '';

  void getTheCategoryListString() {
    categories.forEach((element) {
      categoryListString += element.toJson().toString();
    });
  }

  @override
  void onInit() {
    super.onInit();
    // uploadCategories();
    //

    // Initialize the scroll controllers
    listViewScrollController = ScrollController();
    singleChildScrollViewScrollController = ScrollController();

    // Add listeners to synchronize the scrolling
    listViewScrollController.addListener(_syncScroll);
    singleChildScrollViewScrollController.addListener(_syncScroll);

    scrollController.addListener(_scrollListener);
    debounce(scrollOffset, _handleScrollOffsetChange,
        time: Duration(milliseconds: 200));
    scrollOffset.listen((value) {
      _scrollToOffset(value);
    });

    searchController.addListener(_onSearchChanged);
    initAuth();
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

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    // Remove listeners when the widget is disposed
    listViewScrollController.removeListener(_syncScroll);
    singleChildScrollViewScrollController.removeListener(_syncScroll);

    listViewScrollController.dispose();
    singleChildScrollViewScrollController.dispose();
  }

  late ScrollController listViewScrollController;
  late ScrollController singleChildScrollViewScrollController;

  void _syncScroll() {
    // Check which controller triggered the event
    if (listViewScrollController.hasClients &&
        singleChildScrollViewScrollController.hasClients) {
      if (listViewScrollController.offset !=
          singleChildScrollViewScrollController.offset) {
        if (listViewScrollController.position.isScrollingNotifier.value) {
          singleChildScrollViewScrollController
              .jumpTo(listViewScrollController.offset);
        } else if (singleChildScrollViewScrollController
            .position.isScrollingNotifier.value) {
          listViewScrollController
              .jumpTo(singleChildScrollViewScrollController.offset);
        }
      }
    }
  }

  void _scrollListener() {
    scrollOffset.value = scrollController.offset;
  }

  void _scrollToOffset(double offset) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleScrollOffsetChange(double value) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToSpecificOffset(double offset) {
    if (dayViewKey.currentState != null) {
      dayViewKey.currentState!.scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void jumpToEvent(CalendarEventData event) {
    if (dayViewKey.currentState != null) {
      dayViewKey.currentState!.jumpToEvent(event);
    }
  }

  List<Category> categories = [];
  CategoryService categoryService = CategoryService();

// Upload categories (using Future.wait for parallelism)
  Future<void> uploadCategories() async {
    await Future.wait(categories.map(categoryService.addCategory).toList());
  }

  void onDateTap(DateTime date) async {
    isDateSelected.value = true;
    startHour.value = date.hour.toDouble();
    endHour.value = date.hour.toDouble() + 1;

    double hourHeight =
        60.0; // Assuming each hour represents 60 pixels in height
    double offset = date.hour * hourHeight;
    await Future.delayed(Duration(milliseconds: 100));
    scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    print('Current time in the current hour: ${offset}');
  }

  EventController<Object?> eventController = EventController<Object?>();

  void initCalenderController() {
    List<Note> weekNotes = notes.where((note) {
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

      DateTime? startTime = note.repeatInterval?.startDate ?? note.lastEdited;
      DateTime? endTime = note.repeatInterval?.endDate ?? note.lastEdited;

      return startTime!
              .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          endTime!.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();

    for (var note in weekNotes) {
      eventController.add(CalendarEventData(
        titleStyle: Get.textTheme.bodySmall,
        event: note,
        color: note.color ?? Colors.blue,
        title: note.title ?? 'No Title',
        date: note.lastEdited ?? DateTime.now(),
        startTime: note.repeatInterval?.startDate ?? DateTime.now(),
        endTime: note.repeatInterval?.endDate ??
            DateTime.now().add(Duration(hours: 1)),
      ));
    }
    update();
  }

  void _onSearchChanged() {
    searchNotes(searchController.text);
  }

  Future<void> initAuth() async {
    if (isAuth.isTrue) {
      loadNotes();
    } else {
      Get.toNamed(AppRoutes.login);
    }
    await loadCategories().whenComplete(() {
      getTheCategoryListString();
    });
  }

  bool loading = false;

  // Future<void> loadCategories() async {
  //   categories.assignAll(await _categoryService.getCategories());
  // }
  Future<void> loadNotes() async {
    // await uploadCategories(categories);

    loading = true;
    await loadCategories();

    update();
    try {
      final loadedNotes = await _notesService.getNotes();
      notes.assignAll(loadedNotes);
      filteredNotes.assignAll(notes);
      initCalenderController();
    } catch (e) {
      _showErrorSnackbar('Failed to load notes: $e');
    }
    loading = false;
    update();
  }

  Future<void> deleteNoteById(String id) async {
    try {
      await _notesService.deleteNote(id);
      notes.removeWhere((note) => note.id == id);
      filteredNotes.assignAll(notes);
    } catch (e) {
      _showErrorSnackbar('Failed to delete note: $e');
    }
    update();
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  void searchNotes(String query) {
    if (query.isEmpty) {
      filteredNotes.assignAll(notes);
    } else {
      filteredNotes.assignAll(
        notes
            .where((note) =>
                note.title!.contains(query) || note.content!.contains(query))
            .toList(),
      );
    }
    update();
  }

  String extractPlainTextFromNoteContent(Note note) {
    try {
      final deltaJson = jsonDecode(note.content!) as List<dynamic>;
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

  Future<void> deleteNote(Note currentNote) async {
    if (currentNote != null) {
      try {
        await _notesService.deleteNote(currentNote.id!);
        notes.removeWhere((note) => note.id == currentNote.id);
        filteredNotes.assignAll(notes);
      } catch (e) {
        _showErrorSnackbar('Failed to delete note: $e');
      }
      update();
    }
  }

  var viewMode = ViewMode.grid.obs;
  var calendarFormat = CustomCalendarFormat.cityView.obs;

  void toggleViewMode(ViewMode mode) {
    viewMode.value = mode;
    update();
  }

  void changeCalendarFormat(CustomCalendarFormat format) {
    calendarFormat.value = format;
  }

  Color? invertColor(Color? color) {
    if (color != null) {
      return Color.fromARGB(
        color.alpha,
        255 - color.red,
        255 - color.green,
        255 - color.blue,
      );
    }
  }

  void unSelectedDate() {
    isDateSelected.value = false;
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
}
