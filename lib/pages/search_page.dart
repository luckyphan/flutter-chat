import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/models/chat_room_model.dart';
import 'package:flutter_chat_demo/models/user_model.dart';
import 'package:flutter_chat_demo/pages/chat_room.dart';
import 'package:flutter_chat_demo/pages/user_profile.dart';

import '../main.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatroomModel?> getChatroomModel(UserModel targetUser) async {
    ChatroomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      ChatroomModel existingChatroom =
          ChatroomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;
      log("chatroom exists");
    } else {
      ChatroomModel newChatroom = ChatroomModel(
        chatroomId: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomId)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;
      log("chatroom dont exists");
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListTile(
                title: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    label: Text(
                      "Email Address",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                    hintText: "Enter Email...",
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            (searchController.text.trim() != "")
                ? Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where("email",
                              isGreaterThanOrEqualTo:
                                  searchController.text.trim())
                          .where("email", isNotEqualTo: widget.userModel.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            QuerySnapshot dataSnapshot =
                                snapshot.data as QuerySnapshot;

                            if (dataSnapshot.docs.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: dataSnapshot.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> userMap =
                                        dataSnapshot.docs[index].data()
                                            as Map<String, dynamic>;

                                    UserModel searchedUser =
                                        UserModel.fromMap(userMap);
                                    if (searchedUser.email!.contains(
                                        searchController.text.trim())) {
                                      return ListTile(
                                        onTap: () async {
                                          ChatroomModel? chatroomModel =
                                              await getChatroomModel(
                                                  searchedUser);
                                          if (chatroomModel != null) {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return ChatRoom(
                                                    targetUser: searchedUser,
                                                    chatRoom: chatroomModel,
                                                    userModel: widget.userModel,
                                                    firebaseUser:
                                                        widget.firebaseUser,
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
                                        leading: CircleAvatar(
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.blueGrey,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          foregroundImage: NetworkImage(
                                              searchedUser.profilePic!),
                                        ),
                                        title: Text(
                                          searchedUser.fullName!,
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          searchedUser.email!,
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return UserProfile(
                                                    userModel: searchedUser,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.person,
                                            size: 40.0,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  });
                            } else {
                              return const Text(
                                "No results found!",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return const Text(
                              "An error occoured!",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            );
                          } else {
                            return const Text(
                              "No results found!",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            );
                          }
                        } else {
                          return Center(
                              child: const CircularProgressIndicator());
                        }
                      },
                    ),
                  )
                : Text(
                    "No results found!",
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
