class Customer {
  final String id;
  final String name;
  final String? company;
  final String email;
  final String? phone;
  final String? address;
  final Map<String, dynamic>? customFields;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String assignedTo;
  final String status;

  Customer({
    required this.id,
    required this.name,
    this.company,
    required this.email,
    this.phone,
    this.address,
    this.customFields,
    required this.createdAt,
    required this.updatedAt,
    required this.assignedTo,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      company: json['company'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      customFields: json['customFields'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      assignedTo: json['assignedTo'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'email': email,
      'phone': phone,
      'address': address,
      'customFields': customFields,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'assignedTo': assignedTo,
      'status': status,
    };
  }
}
