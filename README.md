## Inkwell: A Rich Text Editor for Flutter

Inkwell is a Flutter application designed to provide a user-friendly and powerful rich text editing experience. It leverages the capabilities of the `flutter_quill` package to offer features like:

* **Rich Text Editing:** Format your text with bold, italics, underline, headings, and more.
* **Customizable Styles:** Tailor the editor's appearance to match your preferences or branding.
* **Note Management:** Create, edit, and save notes for easy access and organization.
* **Optional Local Storage:** (Optional) Store notes locally for offline access (using GetStorage).
* **Firebase Firestore Integration:** (Optional) Store notes in the cloud for seamless syncing across devices (using Firebase Firestore).

**Getting Started**

1. **Prerequisites:**
    - Ensure you have Flutter installed on your development machine. You can follow the official guide at [https://flutter.dev/get-started](https://flutter.dev/get-started).
    - Basic understanding of Dart programming is recommended.

2. **Installation:**

   Clone the repository:

   ```bash
   git clone https://github.com/your-username/inkwell.git
   ```

   Navigate to the project directory:

   ```bash
   cd inkwell
   ```

   Install dependencies:

   ```bash
   flutter pub get
   ```

3. **Firebase Setup (Optional):**

    - If you intend to use Firebase Firestore for cloud storage, you'll need to configure Firebase for your project. Follow the official guide at [https://firebase.google.com/docs/flutter/setup](https://firebase.google.com/docs/flutter/setup).
    - Replace placeholders in `lib/services/local_storage_service.dart` with your actual Firebase project credentials.

4. **Run the App:**

   ```bash
   flutter run
   ```

This will launch the Inkwell app on your connected device or emulator.

**Using Inkwell**

- **Creating a Note:**
    - Tap the "+" button in the app bar.
    - Enter a title for your note.
    - Use the rich text editor to format your content.
    - Tap the "Save" button to save the note.

- **Editing a Note:**
    - Open an existing note from the list.
    - Make your edits within the rich text editor.
    - Tap the "Save" button to update the note.

- **Deleting a Note:**
    - Swipe left on a note in the list (or long-press depending on the platform).
    - Confirm the deletion.

**Customization**

Inkwell offers some basic customization options. You can explore the source code and modify styles, colors, and fonts to match your desired theme.

**Contributing**

We welcome contributions to Inkwell! Feel free to fork the repository, make changes, and submit pull requests.

**License**

Inkwell is distributed under the MIT License. See the LICENSE file for details.
