// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';

// // Widget pour afficher une liste d'avatars et de noms
// class ContactListCard extends StatelessWidget {
//   final List<Contact> contacts;
//   final String title;
//   final Color avatarColor;

//   const ContactListCard({
//     Key? key,
//     required this.contacts,
//     required this.title,
//     this.avatarColor = Colors.blue, // Couleur par défaut pour l'avatar
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 100,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: contacts.length,
//             itemBuilder: (context, index) {
//               final contact = contacts[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: avatarColor,
//                       child: Text(
//                         contact.initials() ?? '',
//                         style: const TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       contact.displayName ?? '',
//                       style: const TextStyle(fontSize: 12),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
