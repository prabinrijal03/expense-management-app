class ExpenseEntity {
  final String id;
  final String userId;
  final String receiptUrl;
  final String title;
  final String description;
  final String status;
  final DateTime timestamp;
  final double amount;

  ExpenseEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.userId,
    required this.receiptUrl,
    required this.timestamp,
    required this.status,
    required this.description,
  });
}
