import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(labelText: 'Search for a user'),
          onFieldSubmitted: (String a) {
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['photoUrl'],
                        ),
                      ),
                      title: Text(
                        (snapshot.data! as dynamic).docs[index]['username'],
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(future: FirebaseFirestore.instance.collection('posts').get(), builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            return GridView.custom(
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 3, // Yan yana kaç birim olacağı
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                repeatPattern: QuiltedGridRepeatPattern.inverted, // Deseni ters çevirerek tekrar eder (görsel zenginlik için)
                pattern: const [
                  QuiltedGridTile(2, 2), // 1. Eleman: 2x2 (Büyük)
                  QuiltedGridTile(1, 1), // 2. Eleman: 1x1
                  QuiltedGridTile(1, 1), // 3. Eleman: 1x1
                  QuiltedGridTile(1, 1), // 4. Eleman: 1x1
                  QuiltedGridTile(1, 1), // 5. Eleman: 1x1
                  QuiltedGridTile(1, 1), // 6. Eleman: 1x1
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) => Image.network(
                  (snapshot.data! as dynamic).docs[index]['postUrl'],
                  fit: BoxFit.cover,
                ),
                childCount: (snapshot.data! as dynamic).docs.length,
              ),
            );
      })
    );
  }
}
