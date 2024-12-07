import 'package:flutter/material.dart';
import 'package:untitled/dialog_widget.dart';
import 'package:untitled/local_notification_service.dart';

import 'notification_type.dart';

class ListTitleWidget extends StatelessWidget {
  const ListTitleWidget({super.key,required this.title,this.color=Colors.white70, required this.onTap});
  final Color color;
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15), // Round corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.notifications),
        title:  Text(title),
      ),
    );
  }
}
