import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: Text(
          "PE",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        "Office Elements",
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF061D23),
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "Here you store your office Elements",
        style: TextStyle(
          fontSize: 12,
          color: Color(0xFF576760),
        ),
      ),
      trailing: SvgPicture.asset(
        Assets.images.arrowRight,
      ),
    );
  }
}
