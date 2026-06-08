class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String date;
  final String time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.time,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'date': date,
    'time': time,
    'isRead': isRead,
  };

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json['id'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    date: json['date'] as String,
    time: json['time'] as String,
    isRead: json['isRead'] as bool? ?? false,
  );
}
