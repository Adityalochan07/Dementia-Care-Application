class EmergencyContact {
  String name;
  String phone;

  EmergencyContact({required this.name, required this.phone});

  Map<String, dynamic> toJson() =>
    {'name': name, 'phone': phone};

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
    EmergencyContact(name: json['name'], phone: json['phone']);
}
