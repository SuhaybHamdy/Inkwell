import 'local.dart';

class ArTranslations {
  static const Map<String, String> map = {
    // App name
    L10n.nameApp: "حبر",

    // Auth screens
    L10n.authScreenLogin: "تسجيل الدخول",
    L10n.authScreenSignUp: "إنشاء حساب",
    L10n.authScreenEmail: "البريد الإلكتروني",
    L10n.authScreenDisplayName: "اسم العرض", // Name (Arabic)
    L10n.authScreenPassword: "كلمة المرور",
    L10n.authScreenForgotPassword: "هل نسيت كلمة المرور؟",
    L10n.authScreenEmailPlaceholder: "أدخل بريدك الإلكتروني",
    L10n.authScreenPasswordPlaceholder: "أدخل كلمة المرور",

    // Confirmation (Optional)
    L10n.confirm: "تأكيد", // Can be used for password confirmation etc.

    // Login related (optional)
    L10n.alreadyHaveAccount: "هل لديك حساب بالفعل؟", // Introductory phrase for login option

    // Note Taking
    L10n.noteTitle: "العنوان",
    L10n.noteContent: "المحتوى",
    L10n.createNote: "إنشاء ملاحظة",
    L10n.editNote: "تحرير الملاحظة",
    L10n.saveNote: "حفظ الملاحظة",
    L10n.discardNote: "تجاهل الملاحظة",
    L10n.deleteNote: "حذف الملاحظة",
    L10n.noteContentPlaceholder: "ابدأ بكتابة ملاحظتك...",

    // To-Do List
    L10n.taskTitle: "عنوان المهمة",
    L10n.taskDescription: "الوصف (اختياري)",
    L10n.dueDate: "تاريخ الاستحقاق",
    L10n.addTask: "إضافة مهمة",
    L10n.editTask: "تحرير المهمة",
    L10n.taskDescriptionPlaceholder: "أضف وصفًا...",

    // General Add and Save
    L10n.addTitle: "إضافة عنوان",
    L10n.save: "حفظ",
    L10n.timing: "التوقيت",
    L10n.allDay: "طوال اليوم",
    L10n.start: "البداية",
    L10n.end: "النهاية",
    L10n.timezone: "المنطقة الزمنية",
    L10n.noRepeat: "بدون تكرار",
    L10n.addInvitees: "إضافة مدعوين",
    L10n.addVideoConference: "إضافة مؤتمر فيديو",
    L10n.addLocation: "إضافة موقع",
    L10n.addDescription: "إضافة وصف",
    L10n.addAttachments: "إضافة مرفقات",

    // Calendar
    L10n.eventTitle: "حدث",
    L10n.addEvent: "إضافة حدث",
    L10n.editEvent: "تحرير الحدث",

    // Reminders (Optional)
    L10n.reminder: "تذكير",
    L10n.addReminder: "إضافة تذكير",
    L10n.editReminder: "تحرير التذكير",

    // Tags (Optional)
    L10n.tagName: "وسم",
    L10n.addTag: "إضافة وسم",
    L10n.editTag: "تحرير الوسم",

    // Common phrases
    L10n.yes: "نعم",
    L10n.no: "لا",
    L10n.cancel: "إلغاء",

    // Repeat Options
    L10n.repeatNever: "أبدًا",
    L10n.repeatDaily: "يوميًا",
    L10n.repeatWeekly: "أسبوعيًا",
    L10n.repeatMonthlyByDay: "شهريًا حسب اليوم",
    L10n.repeatMonthlyByDate: "شهريًا حسب التاريخ",
    L10n.repeatYearly: "سنويًا",
    L10n.repeatCustom: "مخصص",

    // Week Days
    L10n.monday: "الاثنين",
    L10n.tuesday: "الثلاثاء",
    L10n.wednesday: "الأربعاء",
    L10n.thursday: "الخميس",
    L10n.friday: "الجمعة",
    L10n.saturday: "السبت",
    L10n.sunday: "الأحد",

    // Custom Interval
    L10n.customDay: "يوم",
    L10n.customWeek: "أسبوع",
    L10n.customMonthDay: "شهر (حسب اليوم)",
    L10n.customMonthDate: "شهر (حسب التاريخ)",
    L10n.customYear: "سنة",

    // Repeat Options Details
    L10n.repeatOptions: "خيارات التكرار",
    L10n.customInterval: "فاصل مخصص",
    L10n.selectWeekdays: "حدد أيام الأسبوع",
    L10n.customDates: "تواريخ مخصصة",
    L10n.repeatOption: "خيار التكرار",
    L10n.intervalValue: "قيمة الفاصل",
    L10n.startDate: "اختر تاريخ البدء",
    L10n.endDate: "اختر تاريخ الانتهاء",
    L10n.withoutEndDate: "بدون تاريخ انتهاء",
    L10n.saveSchedule: "حفظ الجدول",

    // Category
    L10n.category: 'فئة',
    L10n.selectCategory: 'اختر الفئة',
    L10n.personal: 'شخصي',
    L10n.work: 'عمل',
    L10n.shopping: 'تسوق',
    L10n.ideas: 'أفكار',
    L10n.travel: 'سفر',
    L10n.finance: 'مالية',
    L10n.health: 'صحة',
    L10n.food: 'طعام',
    L10n.learning: 'تعلم',
    L10n.events: 'أحداث',
    L10n.color: 'لون',

    // Checklist
    L10n.checklist: "قائمة التحقق",
    L10n.addItem: "إضافة عنصر",
    L10n.addChecklistItem: "إضافة عنصر قائمة التحقق",
    L10n.priority: "الأولوية",
    L10n.attachments: "المرفقات",
    L10n.addAttachment: "إضافة مرفق",
    L10n.important: "مهم",
    L10n.hint: "تلميح",

    // AI Suggestions Prompts
    L10n.categoryPrompt: '''
لدي الفئات التالية:
{categoryJson}
    
يرجى تحليل "{aiSuggestItem}" وتحديد الفئة التي تكون أكثر صلة بها أو تعتمد عليها.
أرجع فقط معرف الفئة الأنسب، دون أي نص أو تفسير إضافي.''',

    L10n.titlePrompt: '''
استنادًا إلى المحتوى التالي:
"{aiResponse}"

يرجى توليد عنوان موجز وذو صلة بهذا المحتوى. يجب أن يكون العنوان:
1. لا يتجاوز 10 كلمات
2. يعبر عن الفكرة الرئيسية أو الموضوع
3. جذاب ووصفي
4. بدون استخدام علامات الترقيم في النهاية

أرجع العنوان فقط، دون أي نص أو تفسير إضافي.''',

    L10n.aiQueryPrompt: '''
أنشئ محتوى مقالاً مفصلاً بعنوان: "{titleControllerText}".
يجب أن يكون الناتج مصفوفة JSON صالحة يمكن تحليلها واستخدامها مباشرةً مع محرر Quill.

أرجع المحتوى كمصفوفة Quill Delta JSON، وليس كنص عادي أو تنسيق ماركداون. يجب أن تتبع المصفوفة هذا الهيكل:

[
  { "insert": "العنوان الرئيسي\\n", "attributes": { "header": 1 } },
  { "insert": "هذا نص عادي. " },
  { "insert": "هذا نص غامق", "attributes": { "bold": true } },
  { "insert": ". المزيد من النص العادي.\\n" },
  { "insert": "العنوان الفرعي\\n", "attributes": { "header": 2 } },
  { "insert": "هذا نص مائل.\\n", "attributes": { "italic": true } },
  { "insert": "نقطة تعداد 1\\n", "attributes": { "list": "bullet" } },
  { "insert": "نقطة تعداد 2\\n", "attributes": { "list": "bullet" } },
  { "insert": "نقطة مرقمة 1\\n", "attributes": { "list": "ordered" } },
  { "insert": "نقطة مرقمة 2\\n", "attributes": { "list": "ordered" } },
  { "insert": "اقتباس أو بيان مهم\\n", "attributes": { "blockquote": true } },
  { "insert": "عنوان الجدول 1", "attributes": { "bold": true } },
  { "insert": "\\t" },
  { "insert": "عنوان الجدول 2\\n", "attributes": { "bold": true } },
  { "insert": "الصف 1، الخلية 1\\t" },
  { "insert": "الصف 1، الخلية 2\\n" },
  { "insert": "الصف 2، الخلية 1\\t" },
  { "insert": "الصف 2، الخلية 2\\n" },
  { "insert": { "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==" } },
  { "insert": "\\n" }
]

إرشادات لمصفوفة Quill Delta JSON:
1. لا تستخدم تنسيق ماركداون (*, #, -, إلخ). استخدم فقط تنسيق Quill Delta JSON.
2. يجب أن يكون كل عنصر في المصفوفة كائن عملية مع مفتاح "insert".
3. استخدم كائن "attributes" للتنسيق، وليس تنسيق ماركداون أو علامات HTML:
   - للتوجيه: { "insert": "نص RTL", "attributes": {"direction":"rtl"} }
   - لمحاذاة النص: { "insert": "نص محاذى لليمين\\n", "attributes": {"align":"right"} }
   - للنص الغامق: { "insert": "نص غامق", "attributes": { "bold": true } }
   - للنص المائل: { "insert": "نص مائل", "attributes": { "italic": true } }
   - للعناوين: { "insert": "نص العنوان\\n", "attributes": { "header": level } }
   - للقوائم: { "insert": "عنصر قائمة\\n", "attributes": { "list": "bullet" or "list": "ordered" } }
   - للاقتباسات: { "insert": "نص الاقتباس\\n", "attributes": { "blockquote": true } }
   - للتسطير: { "insert": "نص مسطر", "attributes": { "underline": true } }
   - للنص المشطوب: { "insert": "نص مشطوب", "attributes": { "strike": true } }
   - للنص المرتفع: { "insert": "نص مرتفع", "attributes": { "script": "super" } }
   - للنص السفلي: { "insert": "نص سفلي", "attributes": { "script": "sub" } }
   - لأكواد البرمجة: { "insert": "كود\\n", "attributes": { "code-block": true } }
   - للأكواد المدمجة: { "insert": "كود مدمج", "attributes": { "code": true } }
4. تأكد من أن ينتهي كل النص بـ "\\n" لتمثيل سطر جديد، باستثناء التنسيق المدمج والخلايا الجدولية.
5. لا تدرج أي علامات ماركداون أو HTML في النص أو السمات.
6. استخدم مستويات العناوين المناسبة (1 للعناوين الرئيسية، 2 للعناوين الفرعية، إلخ).
7. أدرج على الأقل قائمة واحدة (رموز نقطية أو مرقمة) في المحتوى.
8. نوع تنسيق النص ليشمل الغامق، المائل، التسطير، والنص المشطوب حيثما كان ذلك مناسبًا.
9. تأكد من أن المحتوى متماسك ويتدفق بشكل منطقي من نقطة إلى أخرى.
10. استهدف حدًا أدنى من 300 كلمة في المحتوى المُنشأ.
11. أدرج على الأقل اقتباس أو بيان مهم واحد مُنسق كاقتباس.
12. إذا كان ذلك ذا صلة بالموضوع، أدرج جدول قصير (2x2 أو 3x3) مُنسق بشكل صحيح لـ Quill:
    - استخدم "\\t" لفصل الخلايا أفقيًا
    - استخدم "\\n" لإنهاء الصف
    - مثال:
      { "insert": "العنوان 1\\tالعنوان 2\\n" },
      { "insert": "الصف 1، الخلية 1\\tالصف 1، الخلية 2\\n" },
      { "insert": "الصف 2، الخلية 1\\tالصف 2، الخلية 2\\n" }
13. اختتم المقال بفقرة ختامية أو ملخص.
14. لا تدرج أي روابط خارجية أو مراجع تتطلب تنسيق إضافي.
15. تأكد من أن كل JSON متهرب بشكل صحيح ومنسق ليكون صالحًا.
16. للتأكيد داخل الجملة، اجمع التنسيقات:
    { "insert": "هذا هو " },
    { "insert": "نص غامق ومائل", "attributes": { "bold": true, "italic": true } },
    { "insert": " نص.\\n" }
17. أدرج على الأقل مثال واحد للنص المرتفع والنص السفلي حيثما كان ذلك مناسبًا.
18. استخدم كتل الأكواد لأي محتوى تقني أو متعلق بالبرمجة.
19. دمج الأكواد المدمجة لمقتطفات الكود القصيرة أو المصطلحات التقنية داخل الجمل.

أمثلة وإرشادات إضافية:
- قائمة متداخلة:
  { "insert": "عنصر قائمة رئيسية\\n", "attributes": { "list": "bullet" } },
  { "insert": "عنصر متداخل 1\\n", "attributes": { "list": "bullet", "indent": 1 } },
  { "insert": "عنصر متداخل 2\\n", "attributes": { "list": "bullet", "indent": 1 } }

- محاذاة النص:
  { "insert": "نص محاذى للوسط\\n", "attributes": { "align": "center" } },
  { "insert": "نص محاذى لليمين\\n", "attributes": { "align": "right" } },
  { "insert": "نص مبرر\\n", "attributes": { "align": "justify" } }

- لون النص والخلفية:
  { "insert": "نص ملون", "attributes": { "color": "#ff0000" } },
  { "insert": "نص مميز", "attributes": { "background": "#ffff00" } }

- حجم الخط والعائلة:
  { "insert": "نص كبير", "attributes": { "size": "large" } },
  { "insert": "نص صغير", "attributes": { "size": "small" } },
  { "insert": "خط مخصص", "attributes": { "font": "serif" } }

- تباعد الأسطر والفقرات:
  { "insert": "نص بقيادة\\n", "attributes": { "leading": "10px" } },
  { "insert": "\\n", "attributes": { "leading": "20px" } }

- مسافة الفقرة:
  { "insert": "فقرة منسدلة\\n", "attributes": { "indent": 1 } }

- خط أفقي:
  { "insert": "\\n", "attributes": { "divider": true } }

- إدراج صورة (استخدم صورة موضعية أو مشفرة بـ base64):
  { "insert": { "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==" } },
  { "insert": "\\n" }

- معادلة (إذا كان ذلك قابلاً للتطبيق):
  { "insert": { "formula": "e=mc^2" } },
  { "insert": "\\n" }

- عنصر فيديو موضعي (إذا كان ذلك قابلاً للتطبيق):
  { "insert": { "video": "https://example.com/placeholder-video.mp4" } },
  { "insert": "\\n" }

- اتجاه النص:
  { "insert": "نص من اليسار إلى اليمين\\n" },
  { "insert": "نص من اليمين إلى اليسار\\n", "attributes": { "direction": "rtl" } },
  { "insert": "نص مختلط: ", "attributes": { "direction": "ltr" } },
  { "insert": "نص RTL", "attributes": { "direction": "rtl" } },
  { "insert": " داخل LTR\\n", "attributes": { "direction": "ltr" } }

- نص ثنائي الاتجاه:
  { "insert": "الإنجليزية و", "attributes": { "direction": "ltr" } },
  { "insert": "العربية", "attributes": { "direction": "rtl" } 
'''
,
    L10n.keywordsPrompt: '''
استنادًا إلى المحتوى التالي:
"{aiResponse}"

يرجى توليد مجموعة من الكلمات الرئيسية ذات الصلة (بحد أقصى 10 كلمات). يجب أن تعبر هذه الكلمات الرئيسية عن الأفكار والمواضيع الرئيسية للمحتوى.

أرجع فقط الكلمات الرئيسية، مفصولة بفواصل، دون أي نص أو تفسير إضافي.''',

    L10n.hintPrompt: '''
استنادًا إلى المحتوى التالي:
"{aiResponse}"

يرجى توليد تلميح مفيد أو نصيحة مفيدة قد تكون مفيدة لشخص يقرأ هذا المحتوى. يجب أن يكون التلميح:
1. لا يتجاوز 20 كلمة
2. يقدم قيمة مضافة أو نصيحة مفيدة
3. يكون مرتبطًا مباشرة بالمحتوى

أرجع فقط التلميح، دون أي نص أو تفسير إضافي.''',

    L10n.titleTagPrompt: '''
استنادًا إلى المحتوى التالي:
"{aiResponse}"

يرجى توليد علامة عنوان قصيرة وموجزة تكون مناسبة لأغراض تحسين محركات البحث (SEO). يجب أن تكون علامة العنوان:
1. لا تتجاوز 60 حرفًا
2. تحتوي على الكلمات الرئيسية ذات الصلة
3. تقدم وصفًا واضحًا ودقيقًا للمحتوى

أرجع فقط علامة العنوان، دون أي نص أو تفسير إضافي.''',

    L10n.backgroundPrompt: '''
استنادًا إلى المحتوى التالي:
"{aiResponse}"

يرجى تحليل المحتوى واقتراح خلفية مناسبة. أجب بالشكل التالي:

{
  "type": "color",
  "value": "MaterialColor(primary value: Color(القيمة))"
}

اتبع هذه الإرشادات:
- لـ "الخلفية":
  - النوع والقيمة يجب أن يكونا قيم نصية
  - النوع يمكن أن يكون "لون" أو "ورق حائط"
  - إذا اقترحت لونًا، استخدم التنسيق: MaterialColor(primary value: Color(0xFFXXXXXX))
  - إذا اقترحت لونًا، استخدم تنسيق Color(0xFFFFFF)
  - إذا اقترحت ورق حائط، استخدم التنسيق: assets/image/notes_wallpaper/notes_wallpaper_X.jpg (حيث X هو 1-5)

اختر الخلفية التي تتناسب مع المحتوى ومزاج النص. لا تشمل أي تفسير، فقط قدم JSON.''',

    L10n.checklistPrompt: '''
استنادًا إلى المحتوى التالي:
"{aiResponse}"

يرجى توليد قائمة تحقق بالعناصر ذات الصلة. أجب بالشكل التالي:

[
  "عنصر قائمة التحقق 1",
  "عنصر قائمة التحقق 2",
  "عنصر قائمة التحقق 3"
]

يجب أن تكون قائمة التحقق شاملة، تلتقط النقاط الرئيسية أو المهام ذات الصلة بالمحتوى.
إذا كان الأمر لا يتطلب أي قائمة، قم بإرجاع قيمة فارغة.
أرجع فقط عناصر قائمة التحقق بتنسيق مصفوفة JSON، دون أي نص أو تفسير إضافي.
'''
  };
}
