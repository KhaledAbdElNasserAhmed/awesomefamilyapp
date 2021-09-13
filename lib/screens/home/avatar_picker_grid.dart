import 'package:flutter/material.dart';

class AvatarPicker extends StatefulWidget {
  final Function setAvatar;
  AvatarPicker(this.setAvatar);
  @override
  _AvatarPickerState createState() => _AvatarPickerState(setAvatar: setAvatar);
}

class _AvatarPickerState extends State<AvatarPicker> {
  _AvatarPickerState({this.setAvatar});
  final Function setAvatar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children:
        List.generate(8, (index) {
          return InkWell(
            onTap: (){
              this.setAvatar("avatar_$index.png");
              Navigator.pop(context);
            },
            child: Card(
              child: Image.asset("assets/avatars/avatar_$index.png"),
            ),
          );

        })

      ),
    );
  }
}
