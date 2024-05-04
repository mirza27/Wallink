import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallink_v1/dialog/delete_confirmation.dart';
import 'package:wallink_v1/form/edit_link_form.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:wallink_v1/controller/link_controller.dart';

class LinkCard extends StatefulWidget {
  final Link link;

  final Function() onChanged; // memanggil fungsi edit di subcategory page

  const LinkCard({super.key, required this.link, required this.onChanged});

  @override
  State<LinkCard> createState() => _LinkCardState();
}

// fungsi launch url
class _LinkCardState extends State<LinkCard> {
  bool _isColored = false;

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      _isColored = true; // Ubah _isColored menjadi true
    });

    // Tunggu sampai animasi selesai
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isColored = false; // Kembalikan _isColored ke false
    });
  }

  // delete link
  Future<void> _deleteLink(int linkId) async {
    await deleteLink(linkId);
    await widget.onChanged.call();
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

  void _markAsUnArchived(int id) async {
    await markAsUnArchived(id);
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
    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          // delete link
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) => DeleteConfirmationDialog(
                  title: 'Warning!',
                  message:
                      'Are you sure you want to delete this link? This action cannot be undone',
                  onDeleteConfirmed: () {
                    _deleteLink(widget.link.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              );
            },
            icon: Icons.delete,
            backgroundColor: const Color.fromARGB(255, 255, 201, 201),
            foregroundColor: const Color.fromARGB(255, 229, 72, 77),
          ),
          // edit link
          SlidableAction(
            onPressed: (context) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                        backgroundColor: const Color.fromRGBO(249, 249, 251, 1),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(30, 31, 36, 1),
                            width: 1.5,
                          ),
                        ),
                        content: EditLinkForm(
                          link: widget.link,
                          onUpdate: widget.onChanged,
                        ),
                        insetPadding: const EdgeInsets.all(10),
                      ));
            },
            backgroundColor: const Color.fromARGB(255, 255, 253, 201),
            foregroundColor: const Color.fromARGB(255, 220, 211, 5),
            icon: Icons.edit,
          ),
          // archive link
          SlidableAction(
            onPressed: (context) {
              if (widget.link.is_archive ?? false) {
                _markAsArchived(widget.link.id!);
              } else {
                _markAsUnArchived(widget.link.id!);
              }
              setState(() {
                widget.link.is_archive = !(widget.link.is_archive ?? false);
              });
            },
            foregroundColor: const Color.fromARGB(255, 5, 105, 220),
            backgroundColor: const Color.fromARGB(255, 201, 226, 255),
            icon: Icons.archive,
          ),
        ],
      ),
      child: GestureDetector(
        onLongPress: () {
          _copytoClipboard(widget.link.link as String);
        },
        onTap: () {
          _launchURL(widget.link.link as String);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _isColored ? Colors.grey.withOpacity(0.2) : null,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
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
                                style: const TextStyle(
                                  fontFamily: 'sharp',
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.link.link as String,
                        style: const TextStyle(
                          fontFamily: 'sharp',
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                // favorit icon
                IconButton(
                  padding: const EdgeInsets.only(left: 5),
                  alignment: Alignment.centerRight,
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
          ),
        ),
      ),
    );
  }
}
