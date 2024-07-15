
class Budgets {
  final String? budgetTitle;
  final String? budgetStartDate;
  final String? budgetEndDate;
  final int? totalBudget;
  final int? budgetSpent;
  final int? budgetRemaining;
  final double? budgetCardIndicatorValue;
  final String? budgetStatusColor;
  final List? expensesList;
  final List? categoryList;
  final List? budgetList;

  Budgets({
    this.budgetTitle,
    this.budgetStartDate,
    this.budgetEndDate,
    this.totalBudget,
    this.budgetSpent,
    this.budgetRemaining,
    this.budgetCardIndicatorValue,
    this.budgetStatusColor,
    this.expensesList,
    this.categoryList,
    this.budgetList
  });

  String? getBudgetStatusColor() {
    return budgetStatusColor;
  }

  String? getBudgetTitle() {
    return budgetTitle;
  }

  String? getBudgetStartDate() {
    return budgetStartDate;
  }

  String? getBudgetEndDate() {
    return budgetEndDate;
  }

  int? getTotalBudget() {
    return totalBudget;
  }

  int? getBudgetSpent() {
    return budgetSpent;
  }

  int? getBudgetRemaining() {
    return budgetRemaining;
  }

  double? getBudgetCardIndicatorValue() {
    return budgetCardIndicatorValue;
  }

  List? getCategoryList() {
    return categoryList;
  }

  List? getExpensesList() {
    return expensesList;
  }

  List? getBudgetsList() {
    return budgetList;
  }

}