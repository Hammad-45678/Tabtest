// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:share/share.dart';

// class ShareApp {
//   String shareText = 'Your shared text goes here';
//   void showShareBottomSheet(String label) {
//     switch (label) {
//       case 'WhatsApp':
//         shareOnWhatsApp();
        
//         break;
//       case 'Telegram':
//         shareOnTelegram();
//         break;
//       case 'Bluetooth':
//         shareOnBluetooth();
//         break;
//       case 'Google':
//         shareOnGoogle();
//         break;
//       case 'Nearby':
//         shareOnNearby();
//         break;
//       case 'Instagram':
//         shareOnInstagram();
//         break;
//       case 'Twitter':
//         shareOnTwitter();
//         break;
//       default:
//       // Handle default case or do nothing
//     }
//   }

//   Widget buildShareButton(String label, String image) {
//     return SizedBox(
//       height: 70,
//       width: 50,
//       child: Column(
//         children: [
//           InkWell(
//             onTap: () => showShareBottomSheet(label),
//             child: Image.asset(
//               image,
//               width: 48,
//               height: 48,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 8,
//               fontWeight: FontWeight.w400,
//               height: 0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildCopylink() {
//     return ListTile(
//       leading: Image.asset('assets/images/link.webp'),
//       title: const Text(
//         'Copy Link',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 10,
//           fontWeight: FontWeight.w600,
//           height: 0,
//         ),
//       ),
//       subtitle: const Opacity(
//         opacity: 0.70,
//         child: Text(
//           'https://rb.gy/skgu89',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 10,
//             fontWeight: FontWeight.w400,
//             height: 0,
//           ),
//         ),
//       ),
//       trailing: Image.asset(
//         'assets/images/copy.webp',
//         width: 20,
//         height: 20,
//       ),
//
//   }

//   void shareOnWhatsApp() {
//     Share.share(shareText, subject: 'Shared from Flutter on WhatsApp');
//   }

//   void shareOnTelegram() {
//     Share.share(shareText, subject: 'Shared from Flutter on Telegram');
//   }

//   void shareOnBluetooth() {
//     // Implement Bluetooth sharing logic
//     Share.share(shareText, subject: 'Shared from Flutter on Bluetooth');
//   }

//   void shareOnGoogle() {
//     // Implement Google sharing logic
//     Share.share(shareText, subject: 'Shared from Flutter on Google');
//   }

//   void shareOnNearby() {
//     // Implement Nearby sharing logic
//     Share.share(shareText, subject: 'Shared from Flutter on Nearby');
//   }

//   void shareOnInstagram() {
//     // Implement Instagram sharing logic
//     Share.share(shareText, subject: 'Shared from Flutter on Instagram');
//   }

//   void shareOnTwitter() {
//     // Implement Twitter sharing logic
//     Share.share(shareText, subject: 'Shared from Flutter on Twitter');
//   }

//   void copyLinkToClipboard(BuildContext context) {
//     // Implement copy to clipboard logic
//     Clipboard.setData(const ClipboardData(text: 'Your copied link goes here'));
//     ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Link copied to clipboard')));
//   }
// }

