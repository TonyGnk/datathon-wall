import 'package:datathon_wall/clock.dart';
import 'package:datathon_wall/firebase.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class CustomLayout extends StatelessWidget {
  const CustomLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
          child: HeaderRow(),
        ),
        const SizedBox(height: 24),
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            color: Colors.black12,
            child: Center(child: const TeamsList()),
          ),
        ),
        const SizedBox(height: 24),
        const Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            child: FooterRow(),
          ),
        ),
        const Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
            child: Footer2Row(),
          ),
        ),
      ],
    );
  }
}

class HeaderRow extends StatelessWidget {
  const HeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/logo-trans.png', height: 50.0),
        const Spacer(),
        // const DigitalClock(),
        const SizedBox(width: 24 / 2),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            WindowManager.instance.close();
          },
        ),
      ],
    );
  }
}

class FooterRow extends StatelessWidget {
  const FooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/raise-trans.png', height: 70.0),
        Image.asset('assets/eellak-tans.png', height: 70.0),
        Image.asset('assets/digiGov-trans.png', height: 70.0),
        Image.asset('assets/ai4-trans.png', height: 70.0),
      ],
    );
  }
}

class Footer2Row extends StatelessWidget {
  const Footer2Row({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/lancom-trans.png', height: 70.0),
        Image.asset('assets/OkThess-trans.png', height: 60.0),
        Image.asset('assets/sevenloft-trans.png', height: 74.0),
        Image.asset('assets/houtos-trans.png', height: 90.0),
        Image.asset('assets/foititiko-trans.png', height: 70.0),
      ],
    );
  }
}
