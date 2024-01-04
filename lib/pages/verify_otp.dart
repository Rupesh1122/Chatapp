// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp/pages/home_page.dart';

class VerifyOTP extends StatefulWidget {
  final String verficiationId;
  final String phoneNumber;
  const VerifyOTP({
    Key? key,
    required this.verficiationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController otpController = TextEditingController();

  bool isClicked = false;
  void otp() async {
    String otp = otpController.text;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verficiationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(
        {'uid': userCredential.user!.uid, 'phone': widget.phoneNumber},
      );
      if (userCredential.user != null) {
        // ignore: use_build_context_synchronously
        isClicked = true;
        setState(() {});
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: ((context) => HomePage())));
      }
      isClicked = false;
      setState(() {});
    } on FirebaseAuthException catch (ex) {
      const snackBar = SnackBar(
        content: Text("Invalid OTP"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: "OTP Verify".text.make()),
        body: Column(
          children: [
            TextField(
              maxLength: 6,
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: "Enter 6 - digit OTP".text.make().centered(),
                counterText: "",
              ),
            ).p12(),
            CupertinoButton.filled(
                child: isClicked
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : "Verify OTP".text.make(),
                onPressed: () {
                  otp();
                }),
          ],
        ),
      ),
    );
  }
}
