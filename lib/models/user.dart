import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String id;
  final String name;
  final String username;
  final String email;
  final Timestamp registrationDate;

  Usuario({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.registrationDate,
  });

  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Usuario(
      id: doc.id,
      name: data['name'],
      username: data['username'],
      email: data['email'],
      registrationDate: data['registration_date'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'username': username,
      
      'email': email,
      'registration_date': registrationDate,
    };
  }
}
