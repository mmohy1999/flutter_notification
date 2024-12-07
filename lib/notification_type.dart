enum NotificationType {
  instantNotifications,
  scheduledNotifications,
}

extension NotificationTypeExtension on NotificationType {
  String get name {
    switch (this) {
      case NotificationType.instantNotifications:
        return "Instant Notifications";
      case NotificationType.scheduledNotifications:
        return "Scheduled Notifications";
    }
  }
}