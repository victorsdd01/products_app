
// ignore_for_file: unused_element


import 'package:productos_app/src/ui/pages/pages.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({
    super.key,
    required this.colors,
  });

  final List<Color> colors;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: _gradient(colors)
          ),
          width: size.width,
          height: size.height * 0.40,
          child: Stack(
            children:  const [
               Positioned(
                top: 90,
                left: 30,
                child: _Bubble(
                  bubbleColor: Color.fromRGBO(255, 255, 255, 0.05),
                  bubbleHeight:80,
                  bubbleWidth: 80,
                ),
              ),
               Positioned(
                top: -10,
                left: 260 ,
                child: _Bubble(
                  bubbleColor: Color.fromRGBO(255, 255, 255, 0.05),
                  bubbleHeight:60,
                  bubbleWidth: 60,
                ),
              ),
               Positioned(
                top: 1,
                left: 80 ,
                child: _Bubble(
                  bubbleColor: Color.fromRGBO(255, 255, 255, 0.05),
                  bubbleHeight:40,
                  bubbleWidth: 40,
                ),
              ),
               Positioned(
                top: -40,
                left: -30 ,
                child: _Bubble(
                  bubbleColor: Color.fromRGBO(255, 255, 255, 0.05),
                  bubbleHeight:90,
                  bubbleWidth: 90,
                ),
              ),
               Positioned(
                top: 100,
                left: 200 ,
                child: _Bubble(
                  bubbleColor: Color.fromRGBO(255, 255, 255, 0.05),
                  bubbleHeight:100,
                  bubbleWidth: 100,
                ),
              ),

              _HeaderIcon(),

              
              
            ]
          ),
        ),
        // SizedBox(
        //   //color: Colors.grey.withOpacity(0.4),
        //   width: size.width,
        //   height: size.height * 0.60,
        // ),
        
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        child: const Icon(Icons.person_pin_circle_sharp, color: Colors.white, size: 100,),
      ),
    );
  }
}

LinearGradient _gradient(List<Color> colors){
  return LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: colors,
    
  );
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    super.key,
    this.bubbleWidth  = 60,
    this.bubbleHeight = 60,
    this.bubbleColor  = Colors.amber,
    
  });

  final double? bubbleWidth ;
  final double? bubbleHeight;
  final Color bubbleColor;

  

  @override
  Widget build(BuildContext context) {

    return Container(
      width: bubbleWidth,
      height: bubbleHeight,
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(100)
      ),
    );
  }
}