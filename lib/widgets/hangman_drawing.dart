import 'dart:math';

import 'package:flutter/material.dart';

class HangmanDrawing extends StatelessWidget {
  final double progress;
  const HangmanDrawing({Key key, this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(200, 200),
        painter: HangmanPainter(200, progress),
      ),
    );
  }
}

class HangmanPainter extends CustomPainter {
  bool needsPainting = true;
  Paint hangmanPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;

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

  final double progress;

  List<Function(Canvas canvas)> drawingSteps;

  HangmanPainter(double width, this.progress) {
    double unit = width / 6;
    double center = width / 2;
    headSize = unit;
    eyeSize = headSize / 3;
    mouthSize = headSize / 3;

    head = Offset(center, headSize);
    neck = Offset(center, 2 * headSize);
    shoulder = Offset(center, unit * 2.5);
    hip = Offset(center, unit * 4.5);
    leftHand = Offset(1.4 * unit, 3.5 * unit);
    rightHand = Offset(4.6 * unit, 3.5 * unit);
    leftFoot = Offset(1.7 * unit, width);
    rightFoot = Offset(4.3 * unit, width);
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
    if (progress == 0) {
      return;
    }
    drawingSteps.forEach((element) {
      if ((drawingSteps.indexOf(element) / drawingSteps.length) <= progress) {
        element.call(canvas);
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as HangmanPainter).progress != progress;
  }
}
