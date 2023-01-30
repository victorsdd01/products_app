

import 'package:productos_app/src/ui/pages/pages.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
    required this.cardItems,
    this.cardWidth = 100,
    this.cardHeight = 100

  });

  final List<Widget> cardItems;
  final double cardWidth;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: cardWidth ,
      height: cardHeight,
      child: Card(
        color: Colors.blue,
        margin: const EdgeInsets.all(2.0),
        elevation: 2.0,
        borderOnForeground: false,
        child: Stack(
          children: cardItems
        ),
      ),
    );
  }
}