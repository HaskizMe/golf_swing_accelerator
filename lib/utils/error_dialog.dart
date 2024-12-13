import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Function to show the error dialog
void showErrorDialog({required BuildContext context, required String errorMessage, required String solution}) {

  if(Platform.isIOS || Platform.isMacOS){
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(errorMessage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(solution),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(errorMessage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(solution),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

// Function to show the error dialog
void showErrorDialogOptions({required BuildContext context, required String errorMessage, required String solution, required VoidCallback onTap}) {

  if(Platform.isIOS || Platform.isMacOS){
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(errorMessage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(solution),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Yes', style: TextStyle(color: Colors.red),),
              onPressed: () {
                onTap();
              },
            ),
            CupertinoDialogAction(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(errorMessage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(solution),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red
              ),
              child: const Text('Yes'),
              onPressed: () {
                onTap();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

// void showAlertDialog({required BuildContext context, required String title, required Widget content}) {
//
//   showDialog(
//   context: context,
//   builder: (context) => AlertDialog(
//     backgroundColor: Colors.white,
//     title: Text(title, style: TextStyle(color: Colors.black),),
//     content: content,
//     actions: [
//       TextButton(
//         style: TextButton.styleFrom(
//             overlayColor: Colors.black,
//             foregroundColor: Colors.black
//         ),
//         onPressed: () => Navigator.of(context).pop(),
//         child: const Text("Cancel"),
//       ),
//       TextButton(
//         style: TextButton.styleFrom(
//             overlayColor: Colors.black,
//             foregroundColor: Colors.black
//         ),
//         onPressed: () async {
//           Navigator.of(context).pop();
//           String? response = await AuthService.forgotPassword(email: _forgotPasswordEmail.text);
//           if(response != null){
//             if(!mounted) return;
//             _showError(response: response);
//           }
//           else {
//             setState(() async {
//               showSuccessMessage = true;
//               await Future.delayed(const Duration(seconds: 2));
//               showSuccessMessage = false;
//             });
//           }
//         },
//         child: const Text("Reset Password"),
//       ),
//     ],
//   ),
//   );
// }