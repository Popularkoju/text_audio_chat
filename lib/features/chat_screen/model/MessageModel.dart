// class MessageModel {
//   final String ?idFriend;
//   final String ?image;
//   final String? name;
//   final String ?message;
//   final String ?date;
//   final bool ?seen;
//   final String? color;
//
//   MessageModel(
//       {this.idFriend,
//         this.image,
//         this.name,
//         this.message,
//         this.date,
//         this.seen,
//         this.color});
// }

enum MessageType {
  own,
  receiver,
}

enum MessageFormat {
  text,
  audio,
  pdf, // not in this app
}

class ChatMessageModel {
  final String message;
  final MessageType type;
  final DateTime dateTime;
  final MessageFormat messageFormat;

  ChatMessageModel({
    required this.message,
    required this.dateTime,
    required this.type,
    required this.messageFormat,
  });
}
