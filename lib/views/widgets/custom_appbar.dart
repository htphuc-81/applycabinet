import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cabinett/locator.dart';
import 'package:flutter_cabinett/services/db_manager.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int page;
  final double prefSize;
  final String title;
  final bool hasBack;

  const CustomAppBar(
      {Key key,
      this.page = 0,
      this.prefSize = 100,
      this.title = "Cabinet",
      this.hasBack = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbManager = locator<DBManager>();
    return Visibility(
      visible: ((this.page != 2) && (this.page != 3)) ? true : false,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            hasBack
                ? InkWell(
                    child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(Icons.arrow_back)),
                    onTap: () => Navigator.of(context).pop(),
                  )
                : SizedBox(),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Container(
                child: Text(
                  "$title",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Container(
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(prefSize);
}
