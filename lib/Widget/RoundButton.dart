import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;

  const RoundButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            //color:Color(0x2AC9A4FF),
              color: Colors.purple,

              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: loading
                ? CircularProgressIndicator(strokeWidth: 3, color: Colors.white)
                : Text(title,
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ));
  }
}