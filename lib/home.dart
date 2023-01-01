import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salon_admin/themes.dart';

import 'widgets/common_widgets.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

final _formKey = GlobalKey<FormState>();

  TextEditingController titleTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController imageTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController genderTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          drawer: MyDrawer(),
            appBar: AppBar(
                title: const Text('Add Service'),
                backgroundColor:MyThemes.darkblack,
                actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ]
        ),
        body: Form(
          key: _formKey,
          child: Container(
            color: MyThemes.darkblack,

            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children:  [
                          CustomTextField(
                                  id: "Title",
                                  hinttxt: "Enter your Title",
                                  icon: Icon(
                                    CupertinoIcons.padlock_solid,
                                    color: MyThemes.txtwhite,
                                  ),
                                  isObscure: true,
                                  controller: titleTextController,
                                ),
                                CustomTextField(
                                  id: "Price",
                                  hinttxt: "Enter your Price",
                                  icon: Icon(
                                    CupertinoIcons.padlock_solid,
                                    color: MyThemes.txtwhite,
                                  ),
                                  isObscure: true,
                                  controller: priceTextController,
                                ),CustomTextField(
                                  id: "Description",
                                  hinttxt: "Enter your Description",
                                  icon: Icon(
                                    CupertinoIcons.padlock_solid,
                                    color: MyThemes.txtwhite,
                                  ),
                                  isObscure: true,
                                  controller: descriptionTextController,
                                ),
                                CustomTextField(
                                  id: "Image",
                                  hinttxt: "Enter your Image",
                                  icon: Icon(
                                    CupertinoIcons.padlock_solid,
                                    color: MyThemes.txtwhite,
                                  ),
                                  isObscure: true,
                                  controller: imageTextController,
                                ),CustomTextField(
                                  id: "Gender",
                                  hinttxt: "Enter your Gender",
                                  icon: Icon(
                                    CupertinoIcons.padlock_solid,
                                    color: MyThemes.txtwhite,
                                  ),
                                  isObscure: true,
                                  controller: genderTextController,
                                ),
                               
                      ],
                    )),
                ),
              ],
            ),
          ),
        ),


      )
    );
  }
}
