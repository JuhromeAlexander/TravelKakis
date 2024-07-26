class Expense {

  final String expenseName;
  final String expenseDesc;
  final String expenseCost;
  final String userName;
  final String budgetName;
  final String categoryName;
  final String expenseType;
  final String expenseDate;

  Expense({
    required this.expenseName,
    required this.expenseDesc,
    required this.expenseCost,
    required this.userName,
    required this.budgetName,
    required this.categoryName,
    required this.expenseType,
    required this.expenseDate
  });

  String getExpenseName() {
    return expenseName;
  }

  String getExpenseDesc() {
    return expenseDesc;
  }

  String getExpenseCost() {
    return expenseCost;
  }

  String getCategoryName() {
    return categoryName;
  }

  String getExpenseType() {
    return expenseType;
  }

  String getExpenseDate() {
    return expenseDate;
  }

  String getUserName() {
    return userName;
  }
}