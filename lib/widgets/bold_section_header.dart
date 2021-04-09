import 'package:flutter/material.dart';

class BoldSectionHeader extends StatelessWidget {
  final String headerLabel;
  BoldSectionHeader(this.headerLabel);
  final TextStyle _headerTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(width: 10),
          Text(
            headerLabel,
            style: _headerTextStyle,
          )
        ],
      ),
    );
  }
}