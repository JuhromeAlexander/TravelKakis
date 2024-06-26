import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class Budgets {

  final String budgetTitle;
  final String budgetStartDate;
  final String budgetEndDate;
  final int totalBudget;
  final int budgetSpent;
  final int budgetRemaining;
  final int budgetCardIndicatorValue;
  final Color budgetStatusColor;
  final List expensesList;
  final List categoryList;

  Budgets({
    required this.budgetTitle,
    required this.budgetStartDate,
    required this.budgetEndDate,
    required this.totalBudget,
    required this.budgetSpent,
    required this.budgetRemaining,
    required this.budgetCardIndicatorValue,
    required this.budgetStatusColor,
    required this.expensesList,
    required this.categoryList
  });

  Color getBudgetStatusColor() {
    return budgetStatusColor;
  }

  String getBudgetTitle() {
    return budgetTitle;
  }

  String getBudgetStartDate() {
    return budgetStartDate;
  }

  String getBudgetEndDate() {
    return budgetEndDate;
  }

  int getBudgetSpent() {
    return budgetSpent;
  }

  int getBudgetRemaining() {
    return budgetRemaining;
  }

  int getBudgetCardIndicatorValue() {
    return budgetCardIndicatorValue;
  }

  List getCategoryList() {
    return categoryList;
  }

  List getExpensesList() {
    return expensesList;
  }

}