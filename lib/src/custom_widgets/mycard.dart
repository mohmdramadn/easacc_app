import 'package:flutter/material.dart';

class MyCard extends StatefulWidget {
  String cardName;
  Widget cardImage;
  Color cardColor;


  MyCard({@required this.cardName, this.cardImage,this.cardColor});

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
           Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(

                child: widget.cardImage,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.cardName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
