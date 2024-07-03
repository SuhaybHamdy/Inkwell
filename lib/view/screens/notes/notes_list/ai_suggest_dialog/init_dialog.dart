import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/note_controller.dart';
import 'package:inkwell/models/note.dart';
import 'package:inkwell/services/ai_suggest.dart';
import '../../../../../controllers/add_or_edit_note_controller.dart';
import '../../../../widget/note_add_or_edit_widgets/build_form.dart';
import 'ai_suggest_dialog.dart';

Future<void> showCustomSuggestionDialog(
    BuildContext context, AiSuggesterService aiSuggesterService) {
  // Controllers for form inputs
  TextEditingController customQueryController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController folderPathController = TextEditingController();
  TextEditingController reminderController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController attachmentsController = TextEditingController();
  TextEditingController checklistController = TextEditingController();
  TextEditingController relatedLinksController = TextEditingController();
  TextEditingController collaboratorsController = TextEditingController();

  RxString? selectedCategory;
  Rx<Color> selectedColor = Colors.white.obs;
  RxBool isImportant = false.obs;
  RxBool isHint = false.obs;
final NotesController notesController=Get.find();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          String categoryListString = notesController.categoryListString;
          bool isLoading = false;

          void _generateSuggestion() async {
            String? title =
                titleController.text.isNotEmpty ? titleController.text : null;
            String? content = contentController.text.isNotEmpty
                ? contentController.text
                : null;
            String? tags =
                tagsController.text.isNotEmpty ? tagsController.text : null;
            String? location = locationController.text.isNotEmpty
                ? locationController.text
                : null;
            String? folderPath = folderPathController.text.isNotEmpty
                ? folderPathController.text
                : null;
            String? reminder = reminderController.text.isNotEmpty
                ? reminderController.text
                : null;
            String? author =
                authorController.text.isNotEmpty ? authorController.text : null;
            String? priority = priorityController.text.isNotEmpty
                ? priorityController.text
                : null;
            String? status =
                statusController.text.isNotEmpty ? statusController.text : null;
            String? attachments = attachmentsController.text.isNotEmpty
                ? attachmentsController.text
                : null;
            String? checklist = checklistController.text.isNotEmpty
                ? checklistController.text
                : null;
            String? relatedLinks = relatedLinksController.text.isNotEmpty
                ? relatedLinksController.text
                : null;
            String? collaborators = collaboratorsController.text.isNotEmpty
                ? collaboratorsController.text
                : null;

            String customQuery = customQueryController.text;

            final List<Note> existingNotes =
                Get.find<NotesController>().notes.value;
            final Note firstNote = existingNotes.isNotEmpty
                ? existingNotes.last
                : Note(); // Fallback if no notes exist
            // Build the query JSON string

            String query = '''Generate a JSON object for a comprehensive note with the following specifications:

1. Structure:
   {
     "id": string,
     "title": string,
     "content": array of Quill Delta JSON objects,
     "date": ISO 8601 string,
     "tags": array of strings,
     "isImportant": boolean,
     "isHint": boolean,
     "color": integer (representing a color value),
     "category": string (use a realistic ID),
     "background": {
       "type": string ("color" or "wallpaper"),
       "value": string
     },
     "location": string,
     "attachments": array of strings,
     "reminder": ISO 8601 string,
     "lastEdited": ISO 8601 string,
     "author": string,
     "priority": string,
     "checklist": array of strings,
     "relatedLinks": array of strings,
     "collaborators": array of strings,
     "repeatInterval": {
       "repeatOption": string,
       "customInterval": string (optional),
       "customIntervalValue": integer (optional),
       "customWeekDays": array of strings (optional),
       "customDates": array of integers (optional),
       "startDate": ISO 8601 string,
       "endDate": ISO 8601 string
     }
   }

2. Content Requirements:
   - Use valid Quill Delta JSON format for the "content" field
   - Include a variety of text formatting: bold, italic, large text, colored text, background-colored text, ordered and unordered lists, bullet points, code blocks, blockquotes, unchecked list items, hyperlinks, and multiple header levels
   - Incorporate emojis and special characters where appropriate
   - Balance informational and casual text

3. Formatting Guidelines:
   - Use ISO 8601 format for all date fields
   - For "background":
     * If type is "color", use format: MaterialColor(primary value: Color(0xFFXXXXXX))
     * If type is "wallpaper", use format: assets/image/notes_wallpeper/notes_wallpeper X.jpg (where X is 1-5)
   - For "repeatInterval", ensure "repeatOption" is one of: "never", "daily", "weekly", "monthlyByDay", "monthlyByDate", "yearly", "custom"

4. Content Example:
   "content": [
     {"insert":"Header","attributes":{"bold":true,"size":"large"}},
     {"insert":"\nRegular text with "},
     {"insert":"formatting","attributes":{"italic":true,"color":"#FF0000"}},
     {"insert":"\n• Bullet point\n","attributes":{"list":"bullet"}},
     {"insert":"1. Numbered item\n","attributes":{"list":"ordered"}},
     {"insert":"Code block\n","attributes":{"code-block":true}},
     {"insert":"Blockquote\n","attributes":{"blockquote":true}},
     {"insert":"Link","attributes":{"link":"https://example.com"}}
   ]

5. General Instructions:
   - Ensure all values are realistic and coherent
   - Create a thematically consistent note (e.g., work project, travel plan, recipe, etc.)
   - Do not include explanations or comments outside the JSON structure

Please generate a complete JSON object based on these specifications, with unique and creative content different from any previous examples.''';

            if (customQuery.isNotEmpty) {
              query += "\nCustom Query: $customQuery";
            }

            print('Generated Query: $query');

// try {
//   String itemQuery = '';
//   firstNote.suggestValues(aiSuggesterService);
// }catch (e) {}
            try {
              isLoading = true;
              final List<Note> suggestedNotes =
                  await aiSuggesterService.suggestNotes(query, existingNotes) ??
                      [];
              if (suggestedNotes.isNotEmpty) {
                _showSuggestionDialog(
                    context, suggestedNotes, 0); // Show the first suggestion
              }
            } catch (e) {
              print('Error: $e');
            } finally {
              isLoading = false;
            }
          }

          return AlertDialog(
            title: Text('Custom Suggestion'),
            content: isLoading == true
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Custom form elements
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(labelText: "Title"),
                        ),
                        TextField(
                          controller: contentController,
                          decoration: InputDecoration(labelText: "Content"),
                          maxLines: 3,
                        ),
                        TextField(
                          controller: tagsController,
                          decoration: InputDecoration(labelText: "Tags"),
                        ),
                        DropdownButton<String>(
                          // value: selectedCategory!=null??selectedCategory.value,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              // selectedCategory.value = newValue;
                            }
                          },
                          items: <String>['Uncategorized', 'Work', 'Personal']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        // Obx(() =>,
                        Obx(() => SwitchListTile(
                              title: Text('Is Important'),
                              value: isImportant.value,
                              onChanged: (bool value) {
                                isImportant.value = value;
                              },
                            )),
                        Obx(() => SwitchListTile(
                              title: Text('Is Hint'),
                              value: isHint.value,
                              onChanged: (bool value) {
                                isHint.value = value;
                              },
                            )),
                        TextField(
                          controller: locationController,
                          decoration: InputDecoration(labelText: "Location"),
                        ),
                        TextField(
                          controller: folderPathController,
                          decoration: InputDecoration(labelText: "Folder Path"),
                        ),
                        TextField(
                          controller: reminderController,
                          decoration: InputDecoration(labelText: "Reminder"),
                        ),
                        TextField(
                          controller: authorController,
                          decoration: InputDecoration(labelText: "Author"),
                        ),
                        TextField(
                          controller: priorityController,
                          decoration: InputDecoration(labelText: "Priority"),
                        ),
                        TextField(
                          controller: statusController,
                          decoration: InputDecoration(labelText: "Status"),
                        ),
                        TextField(
                          controller: attachmentsController,
                          decoration: InputDecoration(
                              labelText: "Attachments (comma separated)"),
                        ),
                        TextField(
                          controller: checklistController,
                          decoration: InputDecoration(
                              labelText: "Checklist (comma separated)"),
                        ),
                        TextField(
                          controller: relatedLinksController,
                          decoration: InputDecoration(
                              labelText: "Related Links (comma separated)"),
                        ),
                        TextField(
                          controller: collaboratorsController,
                          decoration: InputDecoration(
                              labelText: "Collaborators (comma separated)"),
                        ),
                        TextField(
                          controller: customQueryController,
                          decoration: InputDecoration(
                              hintText: "Enter your custom suggestion query"),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _generateSuggestion();
                },
                child: isLoading==true? CircularProgressIndicator():Text('Generate'),
              )
            ],
          );
        },
      );
    },
  );
}

Future<void> _showSuggestionDialog(
    BuildContext context, List<Note> suggestions, int index) async {
  showDialog(
    context: context,
    builder: (context) {
      return SuggestionDialog(
        suggestions: suggestions,
        initialIndex: index,
      );
    },
  );
}

class SuggestionDialog extends StatefulWidget {
  final List<Note> suggestions;
  final int initialIndex;

  SuggestionDialog({
    required this.suggestions,
    this.initialIndex = 0,
  });

  @override
  _SuggestionDialogState createState() => _SuggestionDialogState();
}

class _SuggestionDialogState extends State<SuggestionDialog> {
  late int currentIndex;
  final AddOrEditNoteController controller = Get.find();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void showNextSuggestion() {
    // controller.saveOrUpdateNote(currentNote: widget.suggestions.first);
    setState(() {
      // currentIndex = (currentIndex + 1) % widget.suggestions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    Note currentNote = widget.suggestions[currentIndex];

    return AlertDialog(
      // title: SingleChildScrollView(
      //   child: Container(
      //       height: Get.height - 200,
      //       child: SelectableText(currentNote.title ?? 'Untitled')),
      // ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNoteProperty('ID', currentNote.id),
            _buildNoteProperty('Title', currentNote.title),
            _buildNoteProperty('Content', currentNote.content),
            _buildNoteProperty('Date', currentNote.date?.toString()),
            // Format date if necessary
            _buildNoteProperty('Tags', currentNote.tags?.join(', ')),
            _buildNoteProperty(
                'Important', currentNote.isImportant?.toString()),
            // Convert bool to string
            _buildNoteProperty('Hint', currentNote.isHint?.toString()),
            // Convert bool to string
            _buildNoteProperty('Color', currentNote.color),
            _buildNoteProperty('Category', currentNote.category),
            _buildNoteProperty(
                'Background', currentNote.background?.toString()),
            // Handle background object
            _buildNoteProperty('Location', currentNote.location),
            _buildNoteProperty('Folder Path', currentNote.folderPath),
            _buildNoteProperty(
                'Attachments', currentNote.attachments?.join(', ')),
            _buildNoteProperty('Reminder', currentNote.reminder?.toString()),
            // Handle reminder object
            _buildNoteProperty(
                'Last Edited', currentNote.lastEdited?.toString()),
            // Format date if necessary
            _buildNoteProperty('Author', currentNote.author),
            _buildNoteProperty('Priority', currentNote.priority),
            _buildNoteProperty('Checklist', currentNote.checklist?.join(', ')),
            _buildNoteProperty(
                'Related Links', currentNote.relatedLinks?.join(', ')),
            _buildNoteProperty(
                'Collaborators', currentNote.collaborators?.join(', ')),

            // Add separate properties for complex data types (e.g., reminder details)
            // if (currentNote.reminder != null) {
            //   Text(
            //     'Reminder Details: ${_formatReminder(currentNote.reminder)}',
            //   ),
            // },

            // ... Add similar checks for other complex data types
            _buildNoteProperty('Status', currentNote.status),
            _buildNoteProperty('Repeat Interval', currentNote.repeatInterval),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: showNextSuggestion,
          child: Text('Next'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildNoteProperty(String label, dynamic value) {
    if (value == null) return Container(); // Handle null values gracefully

    return Container(
      // height: Get.height - 200,
      child: Row(
        children: [
          Container(
            width: Get.width - 200,
            child: Text(
              '$label: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value.toString(), // Convert value to string for display
              overflow: TextOverflow.ellipsis, // Handle long text with ellipsis
            ),
          ),
        ],
      ),
    );
  }
}



String quillDeltaJSONWay= '''[
  {
    "insert": "Extended Flutter Quill Editor Tools\n",
    "attributes": {
      "header": 1
    }
  },
  {
    "insert": "Here's a comprehensive guide to the tools available in the Flutter Quill editor:\n\n"
  },
  {
    "insert": "1. Text Formatting\n",
    "attributes": {
      "header": 2
    }
  },
  {
    "insert": "Bold",
    "attributes": {
      "bold": true
    }
  },
  {
    "insert": ": Emphasize text. Select and click the bold button or use Ctrl+B (Cmd+B on Mac).\n"
  },
  {
    "insert": "Italic",
    "attributes": {
      "italic": true
    }
  },
  {
    "insert": ": For slight emphasis. Use the italic button or Ctrl+I (Cmd+I on Mac).\n"
  },
  {
    "insert": "Underline",
    "attributes": {
      "underline": true
    }
  },
  {
    "insert": ": Underline text. Use the underline button or Ctrl+U (Cmd+U on Mac).\n"
  },
  {
    "insert": "Strikethrough",
    "attributes": {
      "strike": true
    }
  },
  {
    "insert": ": For deleted text. Click the strikethrough button.\n\n"
  },
  {
    "insert": "2. Text Alignment\n",
    "attributes": {
      "header": 2
    }
  },
  {
    "insert": "Left align: Default alignment.\nCenter align: Center your text.\nRight align: Align text to the right.\nJustify: Spread text evenly.\n\nUse the alignment buttons in the toolbar to change text alignment.\n\n"
  },
  {
    "insert": "3. Lists and Indentation\n",
    "attributes": {
      "header": 2
    }
  },
  {
    "insert": "• Bullet lists: For unordered items.\n1. Numbered lists: For sequential items.\n   Indentation: Use tab or the indent button.\n\nClick the respective list buttons or use tab for indentation.\n\n"
  },
  {
    "insert": "4. Headings and Blocks\n",
    "attributes": {
      "header": 2
    }
  },
  {
    "insert": "Headings",
    "attributes": {
      "header": 3
    }
  },
  {
    "insert": ": Use for document structure. Select from H1 to H6 in the dropdown.\n"
  },
  {
    "insert": "Quote",
    "attributes": {
      "blockquote": true
    }
  },
  {
    "insert": "\nFor quotations or highlights. Use the quote button.\n"
  },
  {
    "insert": "Code Block",
    "attributes": {
      "code-block": true
    }
  },
  {
    "insert": "\nFor code snippets. Use the code block button.\n\n"
  },
  {
    "insert": "5. Links and Media\n",
    "attributes": {
      "header": 2
    }
  },
  {
    "insert": "Link",
    "attributes": {
      "link": "https://example.com"
    }
  },
  {
    "insert": ": Add hyperlinks. Select text, click link button, enter URL.\n"
  },
  {
    "insert": "Image: Insert images. Click the image button and provide the image URL.\n"
  },
  {
    "insert": "Video: Embed videos. Use the video button and provide the video URL.\n\n"
  },
  {
    "insert": "6. Color and Style\n",
    "attributes": {
      "header": 2
    }
  },
  {
    "insert": "Text Color",
    "attributes": {
      "color": "#ff0000"
    }
  },
  {
    "insert": ": Change text color. Use the color picker.\n"
  },
  {
    "insert": "Background Color",
    "attributes": {
      "background": "#ffff00"
    }
  },
  {
    "insert": ": Highlight text. Use the background color picker.\n"
  },
  {
    "insert": "Font Size: Adjust text size. Use the font size dropdown.\n"
  },
  {
    "insert": "Font Family: Change the font. Select from the font family dropdown.\n\n"
  },
  {
    "insert": "7. Advanced Features\n",
    "attributes": {
      "header": 2
    }
  },
  {
    "insert": "Subscript",
    "attributes": {
      "script": "sub"
    }
  },
  {
    "insert": " and "
  },
  {
    "insert": "Superscript",
    "attributes": {
      "script": "super"
    }
  },
  {
    "insert": ": For mathematical or chemical formulas.\n"
  },
  {
    "insert": "Table: Insert and edit tables for structured data.\n"
  },
  {
    "insert": "Clear Formatting: Remove all formatting from selected text.\n"
  },
  {
    "insert": "Undo/Redo: Reverse or reapply recent changes.\n\n"
  },
  {
    "insert": "8. Custom Formats\n",
    "attributes": {
      "header": 2
    }
  },
  {
    "insert": "Flutter Quill allows for custom formats. Developers can add custom buttons and styles to suit specific needs.\n\n"
  },
  {
    "insert": "Remember, some features may depend on your specific Flutter Quill implementation. Experiment with these tools to create rich, formatted text in your editor!"
  }
]''';