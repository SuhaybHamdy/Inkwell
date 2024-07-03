import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/note.dart';
import '../models/message.dart';

class AiSuggesterService {
  final ChatService _chatService = ChatService();

  /// Suggest notes based on the user's query and note history
  Future<List<Note>>? suggestNotes(String query, List<Note> noteHistory) async {
    // Convert note history to a format suitable for the AI model
    List<Content> history =
        noteHistory.map((note) => Content.text(note.content ?? '')).toList();

    try {
      // Send the query and note history to the AI model
      final response = await _chatService.sendMessage(query, history);

      String noteString = response.text ?? 'Null';
      noteString = noteString.replaceAll('json', '');
      noteString = noteString.replaceAll('\"', '');
      noteString = noteString.replaceAll('```', '');
      print('this is the note string : ${noteString}');
      var content = _parseSuggestions(noteString);
      print(' suggesting  ${content.length}');

      return content;
    } catch (e) {
      print('Error suggesting notes: $e');
      return [];
    }
  }

  /// Suggest items based on the user's query and note history
  Future<dynamic> suggestItems(String query, List<Note> noteHistory) async {
    // Convert note history to a format suitable for the AI model
    List<Content> history =
        noteHistory.map((note) => Content.text(note.content ?? '')).toList();

    try {
      // Send the query and note history to the AI model
      final response = await _chatService.sendMessage(query, history);

      String responseString = response.text ?? 'Null';

      print('This is the response string: $responseString');
      var content = _parseDynamicSuggestions(responseString);
      print('Suggesting items: $content');

      return content;
    } catch (e) {
      print('Error suggesting items: $e');
      return null; // Return null in case of error
    }
  }

  /// Parse the AI model's response into a dynamic result
  dynamic _parseDynamicSuggestions(String? response) {
    // This is a placeholder implementation. Customize this method based on your response format.
    if (response == null || response.isEmpty) {
      return null;
    }

    try {
      // You can further process the decodedResponse based on your specific response format
      // For example, if the response is a list of items or a single item:
      return response;
    } catch (e) {
      print('Error parsing response: $e');
      return null;
    }
  }

  /// Parse the AI model's response into a list of notes
  List<Note> _parseSuggestions(String? response) {
    // This is a placeholder implementation. Customize this method based on your response format.
    if (response == null || response.isEmpty) {
      return [];
    }
    var suggestionsJson = jsonDecode(response!);
    print(
        'this is a placeholder implementation. Customize this method based on your response format : ${suggestionsJson.toString()}');
    Note? note = response != null ? Note.fromJson(jsonDecode(response!)) : null;
    // Example parsing logic
    List<Note> suggestions = [];
    note != null ? suggestions.add(note) : null;

    return suggestions;
  }
}

class ChatService {
  static const String modelName = 'gemini-1.5-flash';
  static const String apiKey = 'AIzaSyAbiCugnhf3vPDRJ2cP1KvTZiyk6R1n1qw';

  final GenerativeModel model =
      GenerativeModel(model: modelName, apiKey: apiKey);
  final RxList<Message> _messages = <Message>[].obs;

  List<Message> get messages => _messages;

  Stream<Message> sendMessageStream(
      String message, List<Content>? history) async* {
    final StreamController<Message> controller = StreamController();

    try {
      final chat = model.startChat(history: history);
      final response = await chat.sendMessage(Content.text(message));

      controller.add(
          Message(asq: message, answer: response.text ?? '', isUser: true));
    } catch (e) {
      controller.addError(e);
      rethrow;
    } finally {
      await controller.close();
    }
  }

  // Send a message to the chat service
  Future<GenerateContentResponse> sendMessage(
      String message, List<Content>? history) async {
    try {
      final chat = model.startChat(history: history);
      final response = await chat.sendMessage(Content.text(message));
      return response;
      _updateMessages([
        Message(asq: message, answer: response.text ?? '', isUser: true),
      ]);

      print('Sending message to chat service: $message');

      // return Message(asq: message, answer: response.text ?? '', isUser: false);
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  void _updateMessages(List<Message> messages) {
    // Update state with new messages:
    _messages.addAll(messages);
  }
}

class MessageModel {
  final List<MessageItem> contents;
  final GenerationConfig generationConfig;
  final List<SafetySetting> safetySettings;

  MessageModel({
    required this.contents,
    required this.generationConfig,
    required this.safetySettings,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    List<MessageItem> contents = (json['contents'] as List<dynamic>)
        .map((content) => MessageItem.fromJson(content))
        .toList();

    GenerationConfig generationConfig =
        GenerationConfig.fromJson(json['generationConfig']);

    List<SafetySetting> safetySettings =
        (json['safetySettings'] as List<dynamic>)
            .map((setting) => SafetySetting.fromJson(setting))
            .toList();

    return MessageModel(
      contents: contents,
      generationConfig: generationConfig,
      safetySettings: safetySettings,
    );
  }
}

class MessageItem {
  final String role;
  final List<MessagePart> parts;

  MessageItem({
    required this.role,
    required this.parts,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    List<MessagePart> parts = (json['parts'] as List<dynamic>)
        .map((part) => MessagePart.fromJson(part))
        .toList();

    return MessageItem(
      role: json['role'],
      parts: parts,
    );
  }
}

class MessagePart {
  final String text;

  MessagePart({
    required this.text,
  });

  factory MessagePart.fromJson(Map<String, dynamic> json) {
    return MessagePart(
      text: json['text'],
    );
  }
}

class GenerationConfig {
  final double temperature;
  final int topK;
  final double topP;
  final int maxOutputTokens;
  final List<String> stopSequences;

  GenerationConfig({
    required this.temperature,
    required this.topK,
    required this.topP,
    required this.maxOutputTokens,
    required this.stopSequences,
  });

  factory GenerationConfig.fromJson(Map<String, dynamic> json) {
    List<String> stopSequences = (json['stopSequences'] as List<dynamic>)
        .map((sequence) => sequence.toString())
        .toList();

    return GenerationConfig(
      temperature: json['temperature'],
      topK: json['topK'],
      topP: json['topP'],
      maxOutputTokens: json['maxOutputTokens'],
      stopSequences: stopSequences,
    );
  }
}

class SafetySetting {
  final String category;
  final String threshold;

  SafetySetting({
    required this.category,
    required this.threshold,
  });

  factory SafetySetting.fromJson(Map<String, dynamic> json) {
    return SafetySetting(
      category: json['category'],
      threshold: json['threshold'],
    );
  }
}
