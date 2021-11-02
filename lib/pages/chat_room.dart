import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_demo/models/chat_room_model.dart';
import 'package:flutter_chat_demo/models/message_model.dart';
import 'package:flutter_chat_demo/models/user_model.dart';
import 'package:flutter_chat_demo/pages/user_profile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../main.dart';

class ChatRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChatroomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoom(
      {Key? key,
      required this.targetUser,
      required this.chatRoom,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();

  Future<void> rateUser(BuildContext context) async {
    UserModel ratingUser = widget.targetUser;
    return await showDialog(
      context: (context),
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          title: const Text(
            "Rate user",
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: RatingBar.builder(
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onRatingUpdate: (rating) {
                setState(
                  () {
                    if (ratingUser.stars == 0) {
                      ratingUser.stars = rating;
                    } else {
                      ratingUser.stars = (ratingUser.stars! + rating) / 2;
                    }
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(ratingUser.uid)
                      .set(ratingUser.toMap())
                      .then(
                    (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.blueGrey,
                          duration: Duration(seconds: 1),
                          content: Text("User rated successfully!"),
                        ),
                      );
                    },
                  );
                  Navigator.pop(context);
                },
                child: Text("OK"))
          ],
        );
      },
    );
  }

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: Timestamp.now(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .set(widget.chatRoom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: const CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
              backgroundColor: Colors.transparent,
              foregroundImage:
                  NetworkImage(widget.targetUser.profilePic.toString()),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.targetUser.fullName.toString(),
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserProfile(
                      userModel: widget.targetUser,
                    );
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.person,
              size: 30.0,
            ),
          ),
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20),
            onPressed: () async {
              await rateUser(context);
            },
            icon: const Icon(
              Icons.star_border_outlined,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoom.chatroomId)
                    .collection("messages")
                    .orderBy("createdOn", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          return (currentMessage.sender == widget.userModel.uid)
                              //  FOR LOGGED IN USER
                              ? ListTile(
                                  trailing: CircleAvatar(
                                    child: const CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(
                                        widget.userModel.profilePic.toString()),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blueAccent,
                                        ),
                                        child:
                                            Text(currentMessage.text.toString(),
                                                maxLines: 20,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                )),
                                      ),
                                    ],
                                  ),
                                )
                              //  FOR TARGET USER
                              : ListTile(
                                  leading: CircleAvatar(
                                    child: const CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(widget
                                        .targetUser.profilePic
                                        .toString()),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blueGrey,
                                        ),
                                        child:
                                            Text(currentMessage.text.toString(),
                                                maxLines: 20,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                )),
                                      ),
                                    ],
                                  ),
                                );
                        },
                        itemCount: dataSnapshot.docs.length,
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An error occoured! Please check your internet connection "),
                      );
                    } else {
                      return Center(
                        child: Text("Say Hi to ${widget.targetUser.fullName}"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      style: const TextStyle(color: Colors.blueGrey),
                      decoration: const InputDecoration(
                        hintText: "Enter Message...",
                        hintStyle: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blueGrey,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
