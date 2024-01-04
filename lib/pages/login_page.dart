import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp/pages/verify_otp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController numController = TextEditingController();
  bool isClicked = false;
  void sendOTP() async {
    String phoneNumber = "+91" + numController.text.trim();
    if (phoneNumber.length == 13) {
      isClicked = true;
      setState(() {});
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, resendToken) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => VerifyOTP(
                        verficiationId: verificationId,
                        phoneNumber:phoneNumber
                      )));
          isClicked = false;
          setState(() {});
        },
        verificationCompleted: (credential) {},
        verificationFailed: (ex) {
          log(ex.code.toString());
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 30),
      );
    } else {
      const snackBar = SnackBar(
        content: Text("Invalid Number"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Enter your phone number".text.make(),
      ),
      body: Column(
        children: [
          "Chatapp will need to verify your phone number"
              .text
              .make()
              .py24()
              .centered(),
          TextField(
            keyboardType: TextInputType.number,
            controller: numController,
            decoration: InputDecoration(
              label: "Phone Number".text.make(),
            ),
          ).p12(),
          CupertinoButton.filled(
              child: isClicked
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : "Send OTP".text.make(),
              onPressed: () {
                sendOTP();
              }),
        ],
      ),
    );
  }
}
