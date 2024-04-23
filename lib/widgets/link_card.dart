import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:wallink_v1/controller/link_controller.dart';

class LinkCard extends StatefulWidget {
  final Link link;
  final Function(int) onDelete; // memanggil fungsi delete di subcategory card
  final Function(Link) onUpdate; // memanggil fungsi edit di subcategory page

  const LinkCard(
      {super.key,
      required this.link,
      required this.onDelete,
      required this.onUpdate});

  @override
  State<LinkCard> createState() => _LinkCardState();
}

// fungsi launch url
class _LinkCardState extends State<LinkCard> {
  Future<void> _launchURL(String url) async {
    // jika tidak ada https / http
    if (!url.startsWith("https://") && !url.startsWith("http://")) {
      url = "https://$url";
    }

    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "can't launch url";
    }
  }

  // fungsi copy
  Future<void> _copytoClipboard(String url) async {
    Clipboard.setData(ClipboardData(text: url));
  }

  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  double _scrollMax = 0.0;
  Timer? _timer;
  final int _delaySeconds = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollMax = _scrollController.position.maxScrollExtent;
      // _startScrolling();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollPosition < _scrollMax) {
        _scrollPosition += 1.0;
        _scrollController.animateTo(_scrollPosition,
            duration: const Duration(milliseconds: 50), curve: Curves.linear);
      } else {
        _scrollPosition = 0.0;
        _scrollController.jumpTo(_scrollPosition);
        _timer?.cancel();
        Future.delayed(
          Duration(seconds: _delaySeconds),
          () {
            _startScrolling();
          },
        );
      }
    });
  }

  // MAIN WIDGET ==================================================
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          // LINK DAN LAUNCH LINK
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    // nama link
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.link.nameLink as String,
                          style: GoogleFonts.lexend(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    // launch button
                    SizedBox(
                      child: IconButton(
                          icon: const Icon(
                            Icons.launch,
                            size: 12,
                          ),
                          onPressed: () {
                            _launchURL(widget.link.link as String);
                          }),
                    )
                  ],
                ),
                Text(
                  widget.link.link as String,
                  style: GoogleFonts.lexend(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          // ICON UNTUK CRUD
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                // icon copy
                icon: const Icon(
                  Icons.copy,
                  size: 17,
                ),
                onPressed: () {
                  _copytoClipboard(widget.link.link as String);
                },
              ),
              IconButton(
                // icon edit
                icon: const Icon(
                  Icons.edit,
                  size: 17,
                ),
                onPressed: () {
                  widget.onUpdate(widget.link);
                },
              ),
              IconButton(
                // icon delete
                icon: const Icon(
                  Icons.delete,
                  size: 17,
                ),
                onPressed: () {
                  widget.onDelete(widget.link.id!);
                },
              ),
              //
              //
              //  ICON FAVORITE
              //
              //
              IconButton(
                icon: Icon(
                  widget.link.is_favorite ?? false
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 17,
                  color: widget.link.is_favorite ?? false
                      ? Colors.red
                      : null, // Warna abu-abu jika is_favorite false
                ),
                onPressed: () async {
                  if (widget.link.is_favorite ?? false) {
                    await markAsUnFavorite(widget.link.id!);
                  } else {
                    await markAsFavorite(widget.link.id!);
                  }
                  setState(() {
                    // Toggle nilai is_favorite saat tombol ditekan
                    widget.link.is_favorite =
                        !(widget.link.is_favorite ?? false);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
