import 'package:clinique/controller/rating.controller.dart';
import 'package:clinique/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class RatingScreen extends StatefulWidget {
  String? clinic;
  RatingScreen({Key? key, this.clinic}) : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatingController>(
        init: RatingController(),
        builder: (controller) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tell Us Your Experience",
                    style: TextStyle(fontSize: 20, color: Color(0xff8A1818)),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Obx(
                    () => Text(
                      "Rating : ${controller.ratingStar}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RatingBar.builder(
                      initialRating: 1.0,
                      minRating: 1.0,
                      itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                      onRatingUpdate: (rating) {
                        controller.changedRatingStart(rating);
                      }),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () {
                        controller.saveRating(widget.clinic, context);
                      },
                      child: Text("SUBMIT"))
                ],
              ),
            ),
          );
        });
  }
}
