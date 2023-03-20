import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(),
          _HeaderIcon(),
          child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(Icons.person_pin, color: Colors.white, size: 100),
      ),
    );
  }
}

//? utiliza un stack para acomadar los circulos (Buble) atraves del Positioned()
class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //? utilza MediaQuery  para calcular el 40% de altura en base al screen del dispositivo
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _buildBoxDecoration(),
      child: Stack(children: [
        Positioned(
          top: 90,
          left: 30,
          child: _Bubble(),
        ),
        Positioned(
          top: 70,
          left: 50,
          child: _Bubble(),
        ),
        Positioned(
          top: 100,
          right: 10,
          child: _Bubble(),
        ),
        Positioned(
          bottom: -50,
          right: 59,
          child: _Bubble(),
        ),
      ]),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(63, 63, 156, 1),
          Color.fromRGBO(90, 70, 178, 1),
        ]),
      );
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}
