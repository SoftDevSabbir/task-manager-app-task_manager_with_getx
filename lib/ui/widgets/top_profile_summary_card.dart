import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/style/style.dart';
import 'package:task_manager_app/ui/controller/auth_controller.dart';
import 'package:task_manager_app/ui/screens/login_screen.dart';
import 'package:task_manager_app/ui/screens/update_profile_screen.dart';

class TopProfileSummeryCard extends StatefulWidget {
  final bool onTapStatus;

  const TopProfileSummeryCard({
    super.key,
    this.onTapStatus = true,
  });

  @override
  State<TopProfileSummeryCard> createState() => _TopProfileSummeryCardState();
}

class _TopProfileSummeryCardState extends State<TopProfileSummeryCard> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (auth) {
      String imageFormat = auth.user?.photo ?? '';
      if (imageFormat.startsWith('data:image')) {
        imageFormat =
            imageFormat.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
      }
      Uint8List imageInBytes = const Base64Decoder().convert(imageFormat);
      return ListTile(
        onTap: () {
          if (widget.onTapStatus == true) {
            Get.to(const UpdateProfileScreen());
          }
        },
        leading: Visibility(
          visible: imageInBytes.isNotEmpty,
          replacement: const CircleAvatar(
            backgroundColor: Colors.lightGreen,
            child: Icon(Icons.account_circle_outlined),
          ),
          child: CircleAvatar(
            backgroundImage: Image.memory(
              imageInBytes,
              fit: BoxFit.cover,
            ).image,
            backgroundColor: Colors.lightGreen,
          ),
        ),
        title: Text(
          userFullName(auth),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          auth.user?.email ?? '',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: IconButton(
          onPressed: () async {
            await AuthController.clearUserAuthState();
            Get.offAll(const LoginScreen());
          },
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
        tileColor: PrimaryColor.color,
      );
    });
  }

  String userFullName(AuthController auth) {
    return '${auth.user?.firstName ?? ''} ${auth.user?.lastName ?? ''}';
  }
}