import 'package:flutter/material.dart';

class ElevButton extends StatelessWidget {
  final String title;

  const ElevButton({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child:
        ElevatedButton(                                            
          onPressed: () {},
          style: ElevatedButton.styleFrom(            
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            )
          ), 
          child: Text(title)
        )
    );
  }
}