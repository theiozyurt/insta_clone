import 'package:flutter/material.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  void addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    try {
      // Kullanıcı verisini çekmeye çalış
      await _userProvider.refreshUser();

    } catch (err) {
      // HATA YAKALANDI! (User.fromSnap hata fırlattı)

      // 1. Snackbar göster
      if (context.mounted) { // Context hala geçerli mi kontrolü
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Kullanıcı bulunamadı, lütfen tekrar giriş yapın."),
            backgroundColor: Colors.red,
          ),
        );

        // 2. Login Ekranına Gönder (önceki sayfaları silerek)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(), // LoginScreen adın neyse onu yaz
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return widget.webScreenLayout;
          //webScreen
        }
        else {
          return widget.mobileScreenLayout;
        }
        //mobileScreen
      },
    );
  }
}
