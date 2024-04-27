import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:wallink_v1/controller/link_controller.dart';

class LinkCard extends StatefulWidget {
  final Link link;
  final Function(int) onDelete; // memanggil fungsi delete di subcategory card
  final Function(Link) onUpdate;
  final Function() onChanged; // memanggil fungsi edit di subcategory page

  const LinkCard(
      {super.key,
      required this.link,
      required this.onDelete,
      required this.onUpdate,
      required this.onChanged});

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

  void _markAsArchived(int id) async {
    await markAsArchived(id);
    setState(() {
      widget.onChanged.call();
    });
  }

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
                    // SizedBox(
                    //   child: IconButton(
                    //       icon: const Icon(
                    //         Icons.launch,
                    //         size: 12,
                    //       ),
                    //       onPressed: () {
                    //         _launchURL(widget.link.link as String);
                    //       }),
                    // )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _launchURL(widget.link.link as String);
                  },
                  child: Text(
                    widget.link.link as String,
                    style: GoogleFonts.lexend(
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          // favorit icon
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     IconButton(
          //       // icon copy
          //       icon: const Icon(
          //         Icons.copy,
          //         size: 17,
          //       ),
          //       onPressed: () {
          //         _copytoClipboard(widget.link.link as String);
          //       },
          //     ),
          //     // icon edit
          //     IconButton(
          //       icon: const Icon(
          //         Icons.edit,
          //         size: 17,
          //       ),
          //       onPressed: () {
          //         widget.onUpdate(widget.link);
          //       },
          //     ),
          //     // icon delete
          //     IconButton(
          //       icon: const Icon(
          //         Icons.delete,
          //         size: 17,
          //       ),
          //       onPressed: () {
          //         showDialog(
          //           context: context,
          //           builder: (context) => BackdropFilter(
          //             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          //             child: AlertDialog(
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(10.0),
          //                 side: BorderSide(
          //                   color: Colors.black,
          //                   width: 2.0,
          //                 ),
          //               ),
          //               title: Center(
          //                 child: Text(
          //                   'Warning!',
          //                   textAlign: TextAlign.center,
          //                   style: TextStyle(
          //                     fontFamily: 'sharp',
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.black,
          //                   ),
          //                 ),
          //               ),
          //               content: Text(
          //                 'Are you sure you want to delete this link? This action cannot be undone',
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   fontFamily: 'sharp',
          //                   fontWeight: FontWeight.bold,
          //                   color: Colors.black,
          //                 ),
          //               ),
          //               actions: <Widget>[
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     TextButton(
          //                       onPressed: () {
          //                         Navigator.of(context).pop();
          //                       },
          //                       child: Container(
          //                         decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.circular(5.0),
          //                           border: Border.all(
          //                             color: Colors.black,
          //                             width: 1.0,
          //                           ),
          //                         ),
          //                         padding: EdgeInsets.symmetric(
          //                           vertical: 8,
          //                           horizontal: 12,
          //                         ),
          //                         child: Text(
          //                           'Cancel',
          //                           style: TextStyle(
          //                             fontFamily: 'sharp',
          //                             fontWeight: FontWeight.bold,
          //                             color: Colors.black,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     SizedBox(width: 10), // Spasi antara tombol
          //                     TextButton(
          //                       onPressed: () {
          //                         Navigator.of(context).pop();
          //                         widget.onDelete(widget.link.id!);

          //                         ScaffoldMessenger.of(context).showSnackBar(
          //                           SnackBar(
          //                             content:
          //                                 Text('Link deleted successfully'),
          //                             backgroundColor: Colors.green,
          //                           ),
          //                         );
          //                       },
          //                       child: Container(
          //                         decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.circular(5.0),
          //                           color: Colors.red,
          //                         ),
          //                         padding: EdgeInsets.symmetric(
          //                           vertical: 8,
          //                           horizontal: 12,
          //                         ),
          //                         child: Text(
          //                           'Delete',
          //                           style: TextStyle(
          //                             fontFamily: 'sharp',
          //                             fontWeight: FontWeight.bold,
          //                             color: Colors.white,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //     // ICON FAVORITE
          //     IconButton(
          //       icon: Icon(
          //         widget.link.is_favorite ?? false
          //             ? Icons.favorite
          //             : Icons.favorite_border,
          //         size: 17,
          //         color: widget.link.is_favorite ?? false
          //             ? Colors.red
          //             : null, // Warna abu-abu jika is_favorite false
          //       ),
          //       onPressed: () async {
          //         if (widget.link.is_favorite ?? false) {
          //           await markAsUnFavorite(widget.link.id!);
          //         } else {
          //           await markAsFavorite(widget.link.id!);
          //         }
          //         setState(() {
          //           // Toggle nilai is_favorite saat tombol ditekan
          //           widget.link.is_favorite =
          //               !(widget.link.is_favorite ?? false);
          //         });
          //       },
          //     ),
          //     // icon archive
          //     IconButton(
          //       icon: Icon(Icons.archive),
          //       onPressed: () {
          //         setState(() {
          //           _markAsArchived(widget.link.id!);
          //         });
          //       },
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}
