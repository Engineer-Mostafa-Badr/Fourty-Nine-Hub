// import 'package:local_auth/local_auth.dart';

// class LocalAuth {
//   Future<bool> checkBiometrics() async {
//     try {
//       final LocalAuthentication auth = LocalAuthentication();

//       bool authenticated = await auth.authenticate(
//         localizedReason:
//             'Scan your fingerprint (or face or whatever) to authenticate',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//       return authenticated;
//     } catch (e) {
//       return true;
//     }
//   }
// }
