/*
A title page that has children for all pages with a title at the top
 */
/*
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';


/*
This dart file contains the primary template for authenticated pages
Includes standards like the NavBar that are used on all pages
 */
//TODO Figure out with AutoTabsRouter?
//@RoutePage()
class TitlePages extends StatefulWidget {
  final String title;

  const TitlePages({Key? key, required this.title}) : super(key: key);

  @override
  State<TitlePages> createState() => _TitlePagesState();

}

class _TitlePagesState extends State<TitlePages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text(widget.title),
              Expanded(
                  child: const AutoRouter()
              ),
            ],
          ),
      ),
    );
  }
}
*/