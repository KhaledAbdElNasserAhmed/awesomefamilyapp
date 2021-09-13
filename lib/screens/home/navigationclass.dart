import 'package:flutter/material.dart';


class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Activites', Icons.flash_on, Colors.deepOrange),
  Destination('Sons', Icons.people, Colors.deepOrange),
  Destination('Gifts', Icons.card_giftcard, Colors.deepOrange),

];