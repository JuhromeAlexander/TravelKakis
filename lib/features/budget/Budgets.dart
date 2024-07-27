
class Budgets {
  final String? budgetTitle;
  final String? budgetStartDate;
  final String? budgetEndDate;
  final num? totalBudget;
  final num? budgetSpent;
  final num? budgetRemaining;
  final num? budgetCardIndicatorValue;
  final String? budgetStatusColor;
  final List? expensesList;
  final List? categoryList;
  final List? budgetList;
  final String? userName;

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
    this.budgetList,
    this.userName
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

  num? getTotalBudget() {
    return totalBudget;
  }

  num? getBudgetSpent() {
    return budgetSpent;
  }

  num? getBudgetRemaining() {
    return budgetRemaining;
  }

  num? getBudgetCardIndicatorValue() {
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

  String? getUserName() {
    return userName;
  }

}