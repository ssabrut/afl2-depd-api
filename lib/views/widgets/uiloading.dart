part of 'widgets.dart';

class UILoading {
  static Container loading() {
    return Container(
      alignment: Alignment.center,
      width: 30,
      height: 30,
      color: Colors.white,
      child: const SpinKitFadingCircle(
        size: 30,
        color: Color(0xFFFF5555),
      ),
    );
  }
}
