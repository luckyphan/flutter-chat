import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/models/user_model.dart';

class RateUser extends StatefulWidget {
  final UserModel userModel;
  RateUser({Key? key, required this.userModel}) : super(key: key);

  @override
  _RateUserState createState() => _RateUserState();
}

class _RateUserState extends State<RateUser> {
  
  int ratings = 0;
  @override
  Widget build(BuildContext context) {
    UserModel ratingUser = widget.userModel;
    return Center(
      child: Column(
        children: [
          const Text(
            "Rate user",
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () async {
                        ratings = 1;
                        setState(() {});        
                        ratingUser.stars = ratings;
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
                      icon: (ratings < 1)
                          ? Icon(
                              Icons.star_rate,
                              color: Colors.grey,
                              size: 20,
                            )
                          : Icon(
                              Icons.star_rate,
                              color: Colors.yellow,
                              size: 20,
                            ),
                    ),
                    IconButton(
                      onPressed: () async {
                        ratings = 2;
                        setState(() {});
                        ratingUser.stars = ratings;
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
                      icon: (ratings < 2)
                          ? Icon(
                              Icons.star_rate,
                              color: Colors.grey,
                              size: 20,
                            )
                          : Icon(
                              Icons.star_rate,
                              color: Colors.yellow,
                              size: 20,
                            ),
                    ),
                    IconButton(
                      onPressed: () async {
                        ratings = 3;
                        setState(() {});
                        ratingUser.stars = ratings;
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
                      icon: (ratings < 3)
                          ? Icon(
                              Icons.star_rate,
                              color: Colors.grey,
                              size: 20,
                            )
                          : Icon(
                              Icons.star_rate,
                              color: Colors.yellow,
                              size: 20,
                            ),
                    ),
                    IconButton(
                      onPressed: () async {
                        ratings = 4;
                        setState(() {});
                        ratingUser.stars = ratings;
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
                      icon: (ratings < 4)
                          ? Icon(
                              Icons.star_rate,
                              color: Colors.grey,
                              size: 20,
                            )
                          : Icon(
                              Icons.star_rate,
                              color: Colors.yellow,
                              size: 20,
                            ),
                    ),
                    IconButton(
                      onPressed: () async {
                        ratings = 5;
                        setState(() {});
                        ratingUser.stars = ratings;
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
                      icon: (ratings < 5)
                          ? Icon(
                              Icons.star_rate,
                              color: Colors.grey,
                              size: 20,
                            )
                          : Icon(
                              Icons.star_rate,
                              color: Colors.yellow,
                              size: 20,
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
