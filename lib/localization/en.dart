import 'local.dart';

class EnTranslations {
  static const Map<String, String> map = {
    // App name
    L10n.nameApp: "Inkwell",

    // Auth screens
    L10n.authScreenLogin: "Login",
    L10n.authScreenSignUp: "Sign Up",
    L10n.authScreenEmail: "Email",
    L10n.authScreenDisplayName: "Display Name",
    // Name (Arabic)
    L10n.authScreenPassword: "Password",
    L10n.authScreenForgotPassword: "Forgot Password?",
    L10n.authScreenEmailPlaceholder: "Enter your email",
    L10n.authScreenPasswordPlaceholder: "Enter your password",

    // Confirmation (Optional)
    L10n.confirm: "Confirm",
    // Can be used for password confirmation etc.

    // Login related (optional)
    L10n.alreadyHaveAccount: "Already have an account?",
    // Introductory phrase for login option

    // Note Taking
    L10n.noteTitle: "Title",
    L10n.noteContent: "Content",
    L10n.createNote: "Create Note",
    L10n.editNote: "Edit Note",
    L10n.saveNote: "Save Note",
    L10n.discardNote: "Discard Note",
    L10n.deleteNote: "Delete Note",
    L10n.noteContentPlaceholder: "Start writing your note...",

    // To-Do List
    L10n.taskTitle: "Task Title",
    L10n.taskDescription: "Description (optional)",
    L10n.dueDate: "Due Date",
    L10n.addTask: "Add Task",
    L10n.editTask: "Edit Task",
    L10n.taskDescriptionPlaceholder: "Add a description...",

    // General Add and Save
    L10n.addTitle: "Add Title",
    L10n.save: "Save",
    L10n.timing: "Timing",
    L10n.allDay: "All Day",
    L10n.start: "Start",
    L10n.end: "End",
    L10n.timezone: "Timezone",
    L10n.noRepeat: "No Repeat",
    L10n.addInvitees: "Add Invitees",
    L10n.addVideoConference: "Add Video Conference",
    L10n.addLocation: "Add Location",
    L10n.addDescription: "Add Description",
    L10n.addAttachments: "Add Attachments",

    // Calendar
    L10n.eventTitle: "Event",
    L10n.addEvent: "Add Event",
    L10n.editEvent: "Edit Event",

    // Reminders (Optional)
    L10n.reminder: "Reminder",
    L10n.addReminder: "Add Reminder",
    L10n.editReminder: "Edit Reminder",

    // Tags (Optional)
    L10n.tagName: "Tag",
    L10n.addTag: "Add Tag",
    L10n.editTag: "Edit Tag",

    // Common phrases
    L10n.yes: "Yes",
    L10n.no: "No",
    L10n.cancel: "Cancel",

    // Repeat Options
    L10n.repeatNever: "Never",
    L10n.repeatDaily: "Daily",
    L10n.repeatWeekly: "Weekly",
    L10n.repeatMonthlyByDay: "Monthly by Day",
    L10n.repeatMonthlyByDate: "Monthly by Date",
    L10n.repeatYearly: "Yearly",
    L10n.repeatCustom: "Custom",

    // Week Days
    L10n.monday: "Monday",
    L10n.tuesday: "Tuesday",
    L10n.wednesday: "Wednesday",
    L10n.thursday: "Thursday",
    L10n.friday: "Friday",
    L10n.saturday: "Saturday",
    L10n.sunday: "Sunday",

    // Custom Interval
    L10n.customDay: "Day",
    L10n.customWeek: "Week",
    L10n.customMonthDay: "Month (by day)",
    L10n.customMonthDate: "Month (by date)",
    L10n.customYear: "Year",

    // Repeat Options Details
    L10n.repeatOptions: "Repeat Options",
    L10n.customInterval: "Custom Interval",
    L10n.selectWeekdays: "Select Weekdays",
    L10n.customDates: "Custom Dates",
    L10n.repeatOption: "Repeat Option",
    L10n.intervalValue: "Interval Value",
    L10n.startDate: "Select Start Date",
    L10n.endDate: "Select End Date",
    L10n.withoutEndDate: "Without End Date",
    L10n.saveSchedule: "Save Schedule",

    // Category
    L10n.category: 'Category',
    L10n.selectCategory: 'Select Category',
    L10n.personal: 'Personal',
    L10n.work: 'Work',
    L10n.shopping: 'Shopping',
    L10n.ideas: 'Ideas',
    L10n.travel: 'Travel',
    L10n.finance: 'Finance',
    L10n.health: 'Health',
    L10n.food: 'Food',
    L10n.learning: 'Learning',
    L10n.events: 'Events',
    L10n.color: 'Color',

    // Checklist
    L10n.checklist: "Checklist",
    L10n.addItem: "Add Item",
    L10n.addChecklistItem: "Add Checklist Item",
    L10n.priority: "Priority",
    L10n.attachments: "Attachments",
    L10n.addAttachment: "Add Attachment",
    L10n.important: "Important",
    L10n.hint: "Hint",

    // AI Suggestions Prompts
    L10n.categoryPrompt: '''
I have the following categories:
{categoryJson}
    
Please analyze "{aiSuggestItem}" and determine which category it is most relevant to or dependent on.
Return only the id of the most appropriate category, without any additional text or explanation.''',

    L10n.titlePrompt: '''
Based on the following content:
"{aiResponse}"

Please generate a concise and relevant title for this content. The title should:
1. Be no longer than 10 words
2. Capture the main idea or theme of the content
3. Be engaging and descriptive
4. Not use any punctuation at the end

Return only the title, without any additional text or explanation.''',

    L10n.aiQueryPrompt: '''
Generate a detailed article content for the title: "{titleControllerText}".
The output must be a valid JSON array that can be directly parsed and used with a Quill editor.

Return the content as a Quill Delta JSON array, NOT as markdown or plain text. The array should follow this structure:

[
  { "insert": "Main Header\\n", "attributes": { "header": 1 } },
  { "insert": "This is normal text. " },
  { "insert": "This is bold text", "attributes": { "bold": true } },
  { "insert": ". More normal text.\\n" },
  { "insert": "Subheader\\n", "attributes": { "header": 2 } },
  { "insert": "This is italic text.\\n", "attributes": { "italic": true } },
  { "insert": "Bullet point 1\\n", "attributes": { "list": "bullet" } },
  { "insert": "Bullet point 2\\n", "attributes": { "list": "bullet" } },
  { "insert": "Numbered point 1\\n", "attributes": { "list": "ordered" } },
  { "insert": "Numbered point 2\\n", "attributes": { "list": "ordered" } },
  { "insert": "Quote or important statement\\n", "attributes": { "blockquote": true } },
  { "insert": "Table header 1", "attributes": { "bold": true } },
  { "insert": "\\t" },
  { "insert": "Table header 2\\n", "attributes": { "bold": true } },
  { "insert": "Row 1, Cell 1\\t" },
  { "insert": "Row 1, Cell 2\\n" },
  { "insert": "Row 2, Cell 1\\t" },
  { "insert": "Row 2, Cell 2\\n" },
  { "insert": { "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==" } },
  { "insert": "\\n" }
]

Guidelines for the Quill Delta JSON array:
1. Do NOT use markdown syntax (*, #, -, etc.). Use only the Quill Delta JSON format.
2. Each element in the array must be an operation object with an "insert" key.
3. Use the "attributes" object for formatting, not markdown or HTML tags:
   - For direction: { "insert": "RTL text", "attributes": {"direction":"rtl"} }
   - For text alignment: { "insert": "Aligned text\\n", "attributes": {"align":"right"} }
   - For bold: { "insert": "bold text", "attributes": { "bold": true } }
   - For italic: { "insert": "italic text", "attributes": { "italic": true } }
   - For headers: { "insert": "Header text\\n", "attributes": { "header": level } }
   - For lists: { "insert": "List item\\n", "attributes": { "list": "bullet" or "list": "ordered" } }
   - For blockquotes: { "insert": "Quote text\\n", "attributes": { "blockquote": true } }
   - For underline: { "insert": "underlined text", "attributes": { "underline": true } }
   - For strikethrough: { "insert": "strikethrough text", "attributes": { "strike": true } }
   - For superscript: { "insert": "superscript", "attributes": { "script": "super" } }
   - For subscript: { "insert": "subscript", "attributes": { "script": "sub" } }
   - For code blocks: { "insert": "code\\n", "attributes": { "code-block": true } }
   - For inline code: { "insert": "inline code", "attributes": { "code": true } }
4. Ensure all text ends with "\\n" to represent a new line, except for inline formatting and table cells.
5. Do NOT include any markdown or HTML tags in the text or attributes.
6. Use appropriate header levels (1 for main header, 2 for subheaders, etc.).
7. Include at least one list (bullet or numbered) in the content.
8. Vary text formatting to include bold, italic, underline, and strikethrough where appropriate.
9. Ensure the content is coherent and flows logically from one point to the next.
10. Aim for a minimum of 300 words in the generated content.
11. Include at least one quote or important statement formatted as a blockquote.
12. If relevant to the topic, include a short table (2x2 or 3x3) formatted correctly for Quill:
    - Use "\\t" to separate cells horizontally
    - Use "\\n" to end a row
    - Example:
      { "insert": "Header 1\\tHeader 2\\n" },
      { "insert": "Row 1, Cell 1\\tRow 1, Cell 2\\n" },
      { "insert": "Row 2, Cell 1\\tRow 2, Cell 2\\n" }
13. End the article with a conclusion or summary paragraph.
14. Do not include any external links or references that would require additional formatting.
15. Ensure all JSON is properly escaped and formatted to be valid.
16. For emphasis within a sentence, combine formats:
    { "insert": "This is " },
    { "insert": "bold and italic", "attributes": { "bold": true, "italic": true } },
    { "insert": " text.\\n" }
17. Include at least one example of superscript and subscript text where appropriate.
18. Use code blocks for any technical or programming-related content.
19. Incorporate inline code for short code snippets or technical terms within sentences.

Additional examples and guidelines:
- Nested list:
  { "insert": "Main list item\\n", "attributes": { "list": "bullet" } },
  { "insert": "Nested item 1\\n", "attributes": { "list": "bullet", "indent": 1 } },
  { "insert": "Nested item 2\\n", "attributes": { "list": "bullet", "indent": 1 } }

- Text alignment:
  { "insert": "Center aligned text\\n", "attributes": { "align": "center" } },
  { "insert": "Right aligned text\\n", "attributes": { "align": "right" } },
  { "insert": "Justified text\\n", "attributes": { "align": "justify" } }

- Text color and background:
  { "insert": "Colored text", "attributes": { "color": "#ff0000" } },
  { "insert": "Highlighted text", "attributes": { "background": "#ffff00" } }

- Font size and family:
  { "insert": "Large text", "attributes": { "size": "large" } },
  { "insert": "Small text", "attributes": { "size": "small" } },
  { "insert": "Custom font", "attributes": { "font": "serif" } }

- Line and paragraph spacing:
  { "insert": "Text with leading\\n", "attributes": { "leading": "10px" } },
  { "insert": "\\n", "attributes": { "leading": "20px" } }

- Text indentation:
  { "insert": "Indented paragraph\\n", "attributes": { "indent": 1 } }

- Horizontal rule:
  { "insert": "\\n", "attributes": { "divider": true } }

- Image insertion (use placeholder or base64 encoded image):
  { "insert": { "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==" } },
  { "insert": "\\n" }

- Formula (if applicable):
  { "insert": { "formula": "e=mc^2" } },
  { "insert": "\\n" }

- Video placeholder (if applicable):
  { "insert": { "video": "https://example.com/placeholder-video.mp4" } },
  { "insert": "\\n" }

- Text direction:
  { "insert": "Left-to-right text\\n" },
  { "insert": "Right-to-left text\\n", "attributes": { "direction": "rtl" } },
  { "insert": "Mixed direction: ", "attributes": { "direction": "ltr" } },
  { "insert": "RTL text", "attributes": { "direction": "rtl" } },
  { "insert": " within LTR\\n", "attributes": { "direction": "ltr" } }

- Bidirectional text:
  { "insert": "English and ", "attributes": { "direction": "ltr" } },
  { "insert": "العربية", "attributes": { "direction": "rtl" }''',
    L10n.keywordsPrompt: '''
Based on the following content:
"{aiResponse}"

Please generate a set of up to 10 relevant keywords. These keywords should capture the main ideas and themes of the content.

Return only the keywords, separated by commas, without any additional text or explanation.''',

    L10n.hintPrompt: '''
Based on the following content:
"{aiResponse}"

Please generate a helpful hint or insight that would be useful to someone reading this content. The hint should:
1. Be no longer than 20 words
2. Provide a valuable takeaway or tip
3. Be directly related to the content

Return only the hint, without any additional text or explanation.''',

    L10n.titleTagPrompt: '''
Based on the following content:
"{aiResponse}"

Please generate a short and concise title tag that would be suitable for SEO purposes. The title tag should:
1. Be no longer than 60 characters
2. Contain relevant keywords
3. Provide a clear and accurate description of the content

Return only the title tag, without any additional text or explanation.''',

    L10n.backgroundPrompt: '''
Based on the following content:
"{aiResponse}"

Please analyze the content and suggest an appropriate background. Respond in the following format:

{
  "type": "color",
  "value": "MaterialColor(primary value: Color(value))"
}

Follow these guidelines:
- For "Background":
  - the type and value should be string values
  - the type can be "color" or "wallpaper"
  - If suggesting a color, use the format: MaterialColor(primary value: Color(0xFFXXXXXX))
  - If suggesting a color, use Color(0xFFFFFF) format
  - If suggesting a wallpaper, use the format: assets/image/notes_wallpaper/notes_wallpaper_X.jpg (where X is 1-5)

Choose the background that best matches the content and mood of the text. Do not include any explanation, just provide the JSON.''',

    L10n.checklistPrompt: '''
Based on the following content:
"{aiResponse}"

Please generate a checklist with relevant items. Respond in the following format:

[
  "Checklist item 1",
  "Checklist item 2",
  "Checklist item 3"
]

The checklist should be comprehensive, capturing key points or tasks relevant to the content.
If the command does not require any list, return null.

Return only the checklist items in JSON array format, without any additional text or explanation.
'''
  };
}
