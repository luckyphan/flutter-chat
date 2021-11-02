import 'package:flutter/material.dart';

import 'package:flutter_chat_demo/models/user_model.dart';

class UserProfile extends StatefulWidget {
  final UserModel? userModel;
  UserProfile({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("User Profile"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 65,
                  child: const CircularProgressIndicator(
                    color: Colors.blueGrey,
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundImage:
                      NetworkImage(widget.userModel!.profilePic.toString()),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.userModel!.fullName.toString(),
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.userModel!.email.toString(),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   "             ",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 20,
                  //     color: Colors.blueGrey,
                  //   ),
                  // ),
                  (widget.userModel!.stars! < 1)
                      ? Icon(
                          Icons.star_rate,
                          color: Colors.blueGrey,
                        )
                      : Icon(
                          Icons.star_rate,
                          color: Colors.yellow,
                        ),
                  (widget.userModel!.stars! < 2)
                      ? Icon(
                          Icons.star_rate,
                          color: Colors.blueGrey,
                        )
                      : Icon(
                          Icons.star_rate,
                          color: Colors.yellow,
                        ),
                  (widget.userModel!.stars! < 3)
                      ? Icon(
                          Icons.star_rate,
                          color: Colors.blueGrey,
                        )
                      : Icon(
                          Icons.star_rate,
                          color: Colors.yellow,
                        ),
                  (widget.userModel!.stars! < 4)
                      ? Icon(
                          Icons.star_rate,
                          color: Colors.blueGrey,
                        )
                      : Icon(
                          Icons.star_rate,
                          color: Colors.yellow,
                        ),
                  (widget.userModel!.stars! < 5)
                      ? Icon(
                          Icons.star_rate,
                          color: Colors.blueGrey,
                        )
                      : Icon(
                          Icons.star_rate,
                          color: Colors.yellow,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
