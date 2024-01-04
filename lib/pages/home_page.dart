import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp/pages/landing_page.dart';
import 'package:whatsapp/pages/user_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.push(context,
        CupertinoPageRoute(builder: (context) => const LandingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              logOut(context);
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
        title: "Chatapp".text.make(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> usermap = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;
                    // if (FirebaseAuth.instance.currentUser != null &&
                    //     ) {
                    return FirebaseAuth.instance.currentUser!.uid ==
                            usermap['uid']
                        ? const Text("")
                        : Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => UserPage(
                                        phone: usermap['phone'].toString(),
                                        receiverId: usermap['uid'].toString()),
                                  ),
                                );
                              },
                              title: Text(usermap["phone"].toString()),
                            ),
                          );
                  }
                  // },
                  );
            } else {
              return const Text("No data");
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
