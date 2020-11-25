import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class GridItem extends StatefulWidget {
  final Key key;
  final Item item;
  final ValueChanged<bool> isSelected;
  GridItem({this.item, this.isSelected, this.key});
  @override
  _GridItemState createState() => _GridItemState();
}
class _GridItemState extends State<GridItem> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          setState(() {
            isSelected = !isSelected;
            widget.isSelected(isSelected);
          });
        },
        child: Stack(
          children: <Widget>[
            Image.network(
              widget.item.imageUrl,
              color: Colors.black.withOpacity(isSelected ? 0.9 : 0),
              colorBlendMode: BlendMode.color,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                    child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                            : null));},
            ),
            isSelected ? Align(
              alignment: Alignment.bottomRight,
              child:
              Icon(
                Icons.check_circle,
                color: Colors.grey,
              ),
            )
                : Container(
            )
          ],
          fit: StackFit.expand,     )   ); }}
class Item{
  String imageUrl;
  String name;
  String gender;
  String age;
  String genre;
  String enjoy;
  String score;
  double point;
  Item(this.imageUrl, this.name,
      this.genre, this.age, this.gender,
      this.point, this.enjoy, this.score);}
