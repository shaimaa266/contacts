import 'package:contacts/data_base.dart';
import 'package:contacts/model.dart';
import 'package:flutter/material.dart';




class ContactUpdate extends StatefulWidget {
  ContactModel contactModel;
  ContactUpdate(this.contactModel, {super.key});
  @override
  _CourseUpdateState createState() => _CourseUpdateState();
}

TextEditingController updatedName = TextEditingController();
TextEditingController updatedNumber = TextEditingController();
TextEditingController updatedImage = TextEditingController();

class _CourseUpdateState extends State<ContactUpdate> {
  @override
  void initState() {
    super.initState();
    updatedName.text = widget.contactModel.name;
    updatedNumber.text = widget.contactModel.number.toString();
    updatedImage.text = widget.contactModel.image;
    // widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Details',
          style: TextStyle(
              color: Color(0xff0977cb),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const CircleAvatar(
              radius: 100,
            ),
            TextFormField(
              decoration: InputDecoration(label: Text(widget.contactModel.name)),
              controller: updatedName,
              autofocus: true,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  label: Text(widget.contactModel.number.toString())),
              controller: updatedNumber,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(label: Text(widget.contactModel.image)),
              controller: updatedImage,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: const Color(0xff0977cb),
              width: 400,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  print(widget.contactModel.toMap());
                  await DataBase.instance.update(ContactModel(
                      id: widget.contactModel.id,
                      image: updatedImage.text,
                      name: updatedName.text,
                      number: int.parse(updatedNumber.text)));
                  Navigator.pop(context);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0977cb),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 400,
              height: 55,
              color: Colors.white,
              child: TextButton(
                  child: Text(
                    'DELETE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xff0977cb)),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Delete Contact',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35),
                            ),
                            content: const Text(
                              'Are you sure you want to delete this Contact ?',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    if (contactId != null) {
                                      await DataBase.instance
                                          .delete(widget.contactModel.id);
                                    }

                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  )),
                            ],
                          );
                        });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

