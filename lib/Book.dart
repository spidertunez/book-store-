import 'package:flutter/material.dart';
import 'sqld.dart';

class Book extends StatefulWidget {
  const Book({super.key});
  static const String route = '/book';

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  final Sqldb sqldb = Sqldb();

  Future<List<Map>> readData() async {
    return await sqldb.readData("SELECT * FROM book");
  }

  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          "Available Books",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 35,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<Map>>(
        future: readData(),
        builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
         if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Books Available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                final bookData = snapshot.data![i];
                return Container(
                  width: 300,
                  height: 180,
                  child: Card( color: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "${bookData['image']}",
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${bookData['title']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Author: ${bookData['author']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.blue, size: 30,),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Book',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    content: Text('Are you sure you want to delete this book?',style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                                    actions: [
                                      TextButton(
                                        child: Text('No',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Yes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red),),
                                        onPressed: () async {
                                          await sqldb.deleteData(
                                            'DELETE FROM book WHERE id = ?',
                                            [bookData['id']],
                                          );
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formState,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: authorController,
                        decoration: InputDecoration(
                          labelText: 'Author',
                          labelStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: imageController,
                        decoration: InputDecoration(
                          labelText: 'image URL',
                          labelStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                            await sqldb.insertData(
                              'INSERT INTO book (title, author, image) VALUES (?, ?, ?)',
                              [titleController.text, authorController.text, imageController.text],
                            );
                            Navigator.of(context).pop();
                            setState(() {});

                        },
                        child: Text('Save', style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 23
                        ),),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          minimumSize: Size(390, 40),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.white, size: 30,),
      ),
    );
  }
}
