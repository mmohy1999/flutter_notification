import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled/notification_type.dart';

import 'local_notification_service.dart';

class DialogWidget extends StatefulWidget {
   const DialogWidget({super.key, required this.notificationType});
   final NotificationType notificationType;
  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _idController.text = _generateUniqueId();
  }

   String _generateUniqueId() {
     return Random().nextInt(999999).toString().padLeft(6, '0'); // Generates a random 6-digit number
   }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.notificationType.name,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                const SizedBox(height: 16),
          
                TextFormField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ID is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _headerController,
                  maxLength: 18,
                  decoration: const InputDecoration(
                    labelText: 'Header',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Header is required';
                    }
                    if (value.length > 18) {
                      return 'Header must be 18 characters or less';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
          
                TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Body',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Body is required';
                    }
                    final wordCount = value.trim().split(RegExp(r'\s+')).length;
                    if (wordCount > 30) {
                      return 'Body must be 30 words or less';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if(widget.notificationType==NotificationType.scheduledNotifications)
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date & Time',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDateTime(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Date & Time is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {

                        switch(widget.notificationType){
                          case NotificationType.instantNotifications:
                            LocalNotificationService.showInstantNotification(id: int.parse(_idController.text),body: _bodyController.text,title: _headerController.text);
                          case NotificationType.scheduledNotifications:
                            LocalNotificationService.showScheduledNotification(id: int.parse(_idController.text),body: _bodyController.text,title: _headerController.text, dateTime: _dateTime);
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        _dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        _dateController.text = _dateTime.toString();
      }
    }
  }
}
