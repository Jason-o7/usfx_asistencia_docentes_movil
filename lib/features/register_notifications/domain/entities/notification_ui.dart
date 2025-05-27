import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NotificationUi extends Equatable {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String timeAgo;
  final String content;
  final String subject;
  final DateTime registerTime;

  const NotificationUi({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.timeAgo,
    required this.content,
    required this.subject,
    required this.registerTime,
  });

  @override
  List<Object?> get props => [
    title,
    icon,
    iconColor,
    timeAgo,
    content,
    subject,
    registerTime,
  ];
}
