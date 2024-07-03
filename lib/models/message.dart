// message.dart
class Message {
  final String asq;
  final String answer;
  final bool isUser;

  Message({
    required this.asq,
    required this.answer,
    required this.isUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'asq': asq,
      'answer': answer,
      'isUser': isUser,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      asq: json['asq'],
      answer: json['answer'],
      isUser: json['isUser'],
    );
  }
}


class MessageHistory {
  final String id;
  final String title;
  List<Message> messages;

  MessageHistory({
    required this.id,
    required this.title,
    required this.messages,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  factory MessageHistory.fromJson(Map<String, dynamic> json) {
    return MessageHistory(
      id: json['id'],
      title: json['title'],
      messages: List<Message>.from(
        json['messages'].map((message) => Message.fromJson(message)),
      ),
    );
  }
}
