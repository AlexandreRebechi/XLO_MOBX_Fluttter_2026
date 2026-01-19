import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/screens/messages/messages_screen.dart';
import 'package:xlo_mobx/stores/chat_room_store.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    if (ad.status == AdStatus.PENDING) {
      return Container();
    }
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 26),
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              color: Colors.orange,
            ),

            child: Row(
              children: <Widget>[
                if (!ad.hidePhone!)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final phone = ad.user!.phone!.replaceAll(
                          RegExp('[^0-9]'),
                          '',
                        );
                        launchUrl(Uri.parse('tel:$phone'));
                      },
                      child: Container(
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.black45),
                          ),
                        ),
                        child: Text(
                          'Ligar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      GetIt.I<ChatRoomStore>().setAd(ad);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => MessageScreen()));
                    },
                    child: Container(
                      height: 25,
                      alignment: Alignment.center,
                      child: Text(
                        'Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(249, 249, 249, 1),
              border: Border(top: BorderSide(color: Colors.grey[400]!)),
            ),
            height: 38,
            alignment: Alignment.center,
            child: Text(
              '${ad.user!.name!} (anunciante)',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}
