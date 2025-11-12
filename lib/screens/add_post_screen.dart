import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false; // <-- DÜZELTME: Yükleme durumu eklendi

  void postImage(
      String uid,
      String username,
      String profileImage,
      ) async {
    setState(() {
      _isLoading = true; // <-- DÜZELTME: Yükleme başlatıldı
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        uid,
        _file!,
        username,
        profileImage,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false; // <-- DÜZELTME: Yükleme bitti
          _file = null; // <-- DÜZELTME: Başarı sonrası ekranı temizle
          _descriptionController.clear();
        });
        showSnackBar(
          'Posted!',
          context,
        );
      } else {
        setState(() {
          _isLoading = false; // <-- DÜZELTME: Yükleme bitti (hata durumu)
        });
        showSnackBar(
          res,
          context,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // <-- DÜZELTME: Yükleme bitti (catch durumu)
      });
      showSnackBar(
        e.toString(),
        context,
      );
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a Photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    // <-- DÜZELTME: Kullanıcı null ise çökmemesi için kontrol
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return _file == null
        ? Scaffold( // <-- DÜZELTME: Scaffold eklendi
      appBar: AppBar(
        title: const Text('Create a Post'),
        backgroundColor: mobileBackgroundColor,
      ),
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.upload, size: 50),
          onPressed: () => _selectImage(context),
        ),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          // <-- DÜZELTME: Mantık düzeltildi (İptal Et)
          onPressed: clearImage,
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            // <-- DÜZELTME: Mantık düzeltildi (Gönder)
            // Yükleme sırasında butonu pasif yap
            onPressed: _isLoading
                ? null
                : () => postImage(
              user.uid,
              user.username,
              user.photoUrl,
            ),
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // <-- DÜZELTME: Yükleme göstergesi eklendi
          _isLoading
              ? const LinearProgressIndicator()
              : const Padding(padding: EdgeInsets.zero),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                const SizedBox(width: 12),
                // <-- DÜZELTME: Layout düzeltildi
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption...',
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
                // <-- DÜZELTME: Layout düzeltildi
                SizedBox(
                  height: 45,
                  width: 45,
                  child: AspectRatio(
                    aspectRatio: 1, // Kare yapmak daha iyi
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(_file!),
                          fit: BoxFit.cover, // fill yerine cover
                          alignment: FractionalOffset.topCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}