
import 'package:contacts/contact_update.dart';
import 'package:contacts/data_base.dart';
import 'package:contacts/model.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<Home> {

  List<ContactModel> contactList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'My Contacts',
          style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
              fontSize: 35),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<ContactModel>>(
            future: DataBase.instance.getContact(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                contactList = snapshot.data!;
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemCount: contactList.length,
                    itemBuilder: (context, index) {
                      ContactModel contactModel = contactList[index];
                      return Container(
                          height: 300,
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ContactUpdate(contactModel)));
                                  },
                                  icon: CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                    NetworkImage(contactModel.image),
                                  ),
                                ),
                                Text(
                                  maxLines: 3,
                                  contactModel.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                                Text(
                                  maxLines: 2,
                                  contactModel.number.toString(),
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ));
                    });
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pink,
          shape: CircleBorder(),
          onPressed: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              barrierColor: Colors.white70,
              backgroundColor: Colors.white,
              builder: (context) => Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                            ),
                            TextFormField(
                              controller: nameController,
                              decoration:
                              InputDecoration(hintText: 'Contact Name'),
                              autofocus: true,
                            ),
                            TextFormField(
                              controller: numberController,
                              decoration:
                              InputDecoration(hintText: 'Contact Number'),
                            ),
                            TextFormField(
                              controller: urlController,
                              decoration: InputDecoration(
                                  hintText: 'Contact Image URL'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 200,
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await DataBase.instance.insert(ContactModel(
                                    image: urlController.text,
                                    name: nameController.text,
                                    number: int.parse(numberController.text),
                                  ));
                                  // Clear text controllers after adding a new contact
                                  nameController.clear();
                                  numberController.clear();
                                  urlController.clear();
                                  print(contactList);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text(
                                  'ADD',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ])),
                ),
              ),
            );
          }),
    );
  }
}
