import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:whatsapp/pages/login_page.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            "Welcome to Chatapp".text.bold.xl4.make().py16().px4(),
            Image.asset("assets/welcome_image.png"),
            const SizedBox().h(context.screenHeight / 7),
            "Read our Privacy Policy. Tap \"Agree and Continue\" to accept the Terms and Services"
                .text
                .make()
                .px24()
                .py20(),
            const SizedBox(
              height: 12,
            ),
            CupertinoButton.filled(
                child: "AGREE AND CONTINUE".text.make(),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => LoginPage()));
                })
          ],
        ),
      ),
    );
  }
}
