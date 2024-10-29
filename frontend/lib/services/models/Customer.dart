import './Locations.dart';

class Bags {
  final int? weight;
  final int? number;

  Bags({required this.weight, required this.number});

  factory Bags.fromJson(Map<String, dynamic> json) {
    return Bags(
      weight: json['weight'],
      number: json['number'],
    );
  }

  // Method to convert a Company object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'number': number,
    };
  }
}

class Containers {
  final int? capacity;
  final int? number;

  Containers({required this.capacity, required this.number});

  factory Containers.fromJson(Map<String, dynamic> json) {
    return Containers(
      capacity: json['capacity'],
      number: json['number'],
    );
  }

  // Method to convert a Company object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'capacity': capacity,
      'number': number,
    };
  }
}

class Customer {
  final int? id;
  final String name;
  final String phone;
  final Wilaya state;
  final String zone;
  final List<Bags>? bags;
  final List<Containers>? containers;
  final int daysGone;
  final int oliveType;
  final bool isPrinted;
  bool isActive;
  String? cancelReason;

  Customer({
    this.id,
    required this.name,
    required this.phone,
    required this.state,
    required this.zone,
    this.containers,
    this.bags,
    required this.daysGone,
    required this.oliveType,
    this.isPrinted = false,
    this.isActive = true,
    this.cancelReason = '',
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    final bagsList = json['bags'] as List?;
    List<Bags>? bags = bagsList?.map((i) => Bags.fromJson(i)).toList();
    final containersList = json['containers'] as List?;
    List<Containers>? containers =
        containersList?.map((i) => Containers.fromJson(i)).toList();
    final Map<String, dynamic> zone = json['zone'];
    return Customer(
      id: json['id'],
      name: json['full_name'],
      phone: json['phone'],
      state: Wilaya.fromJson(json['state']),
      zone: zone['zone'],
      bags: bags,
      containers: containers,
      oliveType: json['olive_type'],
      daysGone: json['days_gone'],
      isPrinted: json['is_printed'],
      isActive: json['is_active'],
      cancelReason: json['cancel_reason'],
    );
  }

  // Method to convert a Company object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'phone': phone,
      'state': state.id,
      'zone': zone,
      'bags': bags?.map((bag) => bag.toJson()).toList(),
      'containers': containers?.map((container) => container.toJson()).toList(),
      'olive_type': oliveType,
      'days_gone': daysGone,
      'is_printed': isPrinted,
      'cancel_reason': cancelReason,
      'is_active': isActive
    };
  }
}
