import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final Widget leading;
  const LoginButton(this.text,
      {Key key,
        @required this.onPressed,
        this.color = Colors.white,
        @required this.leading})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.1),
                    blurRadius: 4.0,
                    spreadRadius: 0.1,
                    offset: Offset(0.5, 0.8))
              ]),
          margin: EdgeInsets.all(0.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    widget.leading,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                              color: widget.color == Colors.white
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: 24.0,
                      height: 24.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
