class ChatroomModel {
  String? chatroomId;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatroomModel({
    this.lastMessage,
    this.chatroomId,
    this.participants,
  });

  ChatroomModel.fromMap(Map<String, dynamic> map) {
    chatroomId = map["chatroomId"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomId": chatroomId,
      "participants": participants,
      "lastMessage": lastMessage,
    };
  }
}
