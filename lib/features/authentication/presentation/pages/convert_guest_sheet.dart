// import 'package:flutter/material.dart';

// class ConvertGuestSheet extends StatefulWidget {
//   const ConvertGuestSheet({super.key});

//   @override
//   _ConvertGuestSheetState createState() => _ConvertGuestSheetState();
// }

// class _ConvertGuestSheetState extends State<ConvertGuestSheet> 
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _loginFormKey = GlobalKey<FormState>();
//   final _signupFormKey = GlobalKey<FormState>();
  
//   // Login Controllers
//   final _loginEmailController = TextEditingController();
//   final _loginPasswordController = TextEditingController();
  
//   // Signup Controllers
//   final _signupEmailController = TextEditingController();
//   final _signupPasswordController = TextEditingController();
//   final _signupConfirmPasswordController = TextEditingController();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _loginEmailController.dispose();
//     _loginPasswordController.dispose();
//     _signupEmailController.dispose();
//     _signupPasswordController.dispose();
//     _signupConfirmPasswordController.dispose();
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.85,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           // Handle
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 12),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
          
//           // Title
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Text(
//               'إنشاء حساب أو تسجيل الدخول',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
          
//           // Tab Bar
//           TabBar(
//             controller: _tabController,
//             tabs: [
//               Tab(text: 'تسجيل الدخول'),
//               Tab(text: 'إنشاء حساب'),
//             ],
//           ),
          
//           // Tab Views
//           Expanded(
//             child: BlocListener<UserCubit, BasicState<UserEntity>>(
//               listener: (context, state) {
//                 if (state.status == StateStatus.success && 
//                     state.data != null && 
//                     !state.data!.isGuest) {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('تم تحويل حسابك بنجاح!'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 } else if (state.status == StateStatus.error) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(state.failure?.toString() ?? 'حدث خطأ'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: BlocBuilder<UserCubit, BasicState<UserEntity>>(
//                 builder: (context, state) {
//                   final isLoading = state.status == StateStatus.loading;
                  
//                   return TabBarView(
//                     controller: _tabController,
//                     children: [
//                       // Login Tab
//                       _buildLoginTab(isLoading),
//                       // Signup Tab
//                       _buildSignupTab(isLoading),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoginTab(bool isLoading) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20),
//       child: Form(
//         key: _loginFormKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'سجل دخول بحسابك الموجود',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//             SizedBox(height: 20),
            
//             TextFormField(
//               controller: _loginEmailController,
//               enabled: !isLoading,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: 'البريد الإلكتروني',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.email),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'يرجى إدخال البريد الإلكتروني';
//                 }
//                 if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}).hasMatch(value)) {
//                   return 'يرجى إدخال بريد إلكتروني صحيح';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16),
            
//             TextFormField(
//               controller: _loginPasswordController,
//               enabled: !isLoading,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'كلمة المرور',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.lock),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'يرجى إدخال كلمة المرور';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 24),
            
//             ElevatedButton(
//               onPressed: isLoading ? null : _handleLogin,
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: isLoading
//                 ? CircularProgressIndicator(color: Colors.white)
//                 : Text('تسجيل الدخول'),
//             ),
            
//             SizedBox(height: 16),
            
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 'سيتم الاحتفاظ بجميع بياناتك الحالية (السلة، المفضلة، إلخ) عند تسجيل الدخول',
//                 style: TextStyle(
//                   color: Colors.blue.shade700,
//                   fontSize: 12,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSignupTab(bool isLoading) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20),
//       child: Form(
//         key: _signupFormKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'أنشئ حساب جديد',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//             SizedBox(height: 20),
            
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _firstNameController,
//                     enabled: !isLoading,
//                     decoration: InputDecoration(
//                       labelText: 'الاسم الأول',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.person),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'مطلوب';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _lastNameController,
//                     enabled: !isLoading,
//                     decoration: InputDecoration(
//                       labelText: 'الاسم الأخير',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'مطلوب';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
            
//             TextFormField(
//               controller: _signupEmailController,
//               enabled: !isLoading,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: 'البريد الإلكتروني',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.email),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'يرجى إدخال البريد الإلكتروني';
//                 }
//                 if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}).hasMatch(value)) {
//                   return 'يرجى إدخال بريد إلكتروني صحيح';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16),
            
//             TextFormField(
//               controller: _signupPasswordController,
//               enabled: !isLoading,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'كلمة المرور',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.lock),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'يرجى إدخال كلمة المرور';
//                 }
//                 if (value.length < 6) {
//                   return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16),
            
//             TextFormField(
//               controller: _signupConfirmPasswordController,
//               enabled: !isLoading,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'تأكيد كلمة المرور',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.lock_outline),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'يرجى تأكيد كلمة المرور';
//                 }
//                 if (value != _signupPasswordController.text) {
//                   return 'كلمة المرور غير متطابقة';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 24),
            
//             ElevatedButton(
//               onPressed: isLoading ? null : _handleSignup,
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: isLoading
//                 ? CircularProgressIndicator(color: Colors.white)
//                 : Text('إنشاء حساب'),
//             ),
            
//             SizedBox(height: 16),
            
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 'سيتم الاحتفاظ بجميع بياناتك الحالية (السلة، المفضلة، إلخ) عند إنشاء الحساب',
//                 style: TextStyle(
//                   color: Colors.green.shade700,
//                   fontSize: 12,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleLogin() {
//     if (_loginFormKey.currentState!.validate()) {
//       context.read<UserCubit>().convertGuestToUser(
//         email: _loginEmailController.text.trim(),
//         password: _loginPasswordController.text.trim(),
//         isNewAccount: false,
//       );
//     }
//   }

//   void _handleSignup() {
//     if (_signupFormKey.currentState!.validate()) {
//       context.read<UserCubit>().convertGuestToUser(
//         email: _signupEmailController.text.trim(),
//         password: _signupPasswordController.text.trim(),
//         firstName: _firstNameController.text.trim(),
//         lastName: _lastNameController.text.trim(),
//         isNewAccount: true,
//       );
//     }
//   }
// }