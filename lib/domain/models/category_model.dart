import 'package:flutter/cupertino.dart';
import 'package:trakli/presentation/utils/enums.dart';

class CategoryModel {
  final String name;
  final String? description;
  final TransactionType type;
  final IconData icon;

  const CategoryModel({
    required this.name,
    this.description,
    required this.type,
    required this.icon,
  });
}
