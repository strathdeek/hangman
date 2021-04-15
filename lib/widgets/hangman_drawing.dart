import 'dart:math';

import 'package:flutter/material.dart';

class HangmanDrawing extends StatelessWidget {
  final int guesses;
  final bool hasLost;
  final Size size;
  final bool isThumbnail;
  const HangmanDrawing(
      {Key key,
      this.guesses,
      this.hasLost = false,
      this.size,
      this.isThumbnail = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: size,
        painter: HangmanPainter(size, guesses, hasLost, isThumbnail),
      ),
    );
  }
}

class HangmanPainter extends CustomPainter {
  bool needsPainting = true;
  Paint hangmanPaint;

  double headSize;
  double eyeSize;
  double mouthSize;

  Offset head;
  Offset neck;
  Offset shoulder;
  Offset hip;
  Offset leftHand;
  Offset rightHand;
  Offset leftFoot;
  Offset rightFoot;
  Offset leftEye;
  Offset rightEye;
  Offset mouth;

  final int guesses;
  final bool hasLost;

  List<Function(Canvas canvas)> drawingSteps;

  HangmanPainter(Size size, this.guesses, this.hasLost, bool isThumbnail) {
    var height = size.height;
    var width = size.width;
    double heightUnit = height / 6;
    double center = width / 2;
    headSize = heightUnit;
    eyeSize = headSize / 3;
    mouthSize = headSize / 3;

    head = Offset(center, headSize);
    neck = Offset(center, 2 * headSize);
    shoulder = Offset(center, heightUnit * 2.5);
    hip = Offset(center, heightUnit * 4.5);
    leftHand = Offset(0, 3.5 * heightUnit);
    rightHand = Offset(width, 3.5 * heightUnit);
    leftFoot = Offset(0, height);
    rightFoot = Offset(width, height);
    leftEye = Offset(
      (center - (headSize * .4)) - (eyeSize / 2),
      .5 * headSize,
    );
    rightEye = Offset(
      (center + (headSize * .4)) - (eyeSize / 2),
      .5 * headSize,
    );
    mouth = Offset(center - (headSize / 2), 1.5 * headSize);
    needsPainting = true;

    hangmanPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isThumbnail ? 2 : 5;

    drawingSteps = <Function(Canvas canvas)>[
      (canvas) => canvas.drawCircle(head, headSize, hangmanPaint),
      (canvas) => canvas.drawLine(neck, hip, hangmanPaint),
      (canvas) => canvas.drawLine(shoulder, rightHand, hangmanPaint),
      (canvas) => canvas.drawLine(shoulder, leftHand, hangmanPaint),
      (canvas) => canvas.drawLine(hip, leftFoot, hangmanPaint),
      (canvas) => canvas.drawLine(hip, rightFoot, hangmanPaint),
      (canvas) => canvas.drawLine(
          leftEye, leftEye.translate(eyeSize, eyeSize), hangmanPaint),
      (canvas) => canvas.drawLine(leftEye.translate(eyeSize, 0),
          leftEye.translate(0, eyeSize), hangmanPaint),
      (canvas) => canvas.drawLine(
          rightEye, rightEye.translate(eyeSize, eyeSize), hangmanPaint),
      (canvas) => canvas.drawLine(rightEye.translate(eyeSize, 0),
          rightEye.translate(0, eyeSize), hangmanPaint),
      (canvas) =>
          canvas.drawLine(mouth, mouth.translate(headSize, 0), hangmanPaint),
      (canvas) => canvas.drawArc(
          Rect.fromPoints(mouth.translate(headSize / 2, -mouthSize),
              mouth.translate(headSize - 2, mouthSize)),
          0,
          pi,
          false,
          hangmanPaint),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (guesses == 0) {
      return;
    } else if (!hasLost) {
      for (var i = 0; i < guesses && i < drawingSteps.length; i++) {
        drawingSteps[i].call(canvas);
      }
    } else {
      drawingSteps.forEach((element) {
        element.call(canvas);
      });
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return ((oldDelegate as HangmanPainter).guesses != guesses) ||
        ((oldDelegate as HangmanPainter).hasLost != hasLost);
  }
}
