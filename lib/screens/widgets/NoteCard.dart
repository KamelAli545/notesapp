import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/noteModel.dart';
const _cardColors = [
  Color(0xFFFFE8A3),
  Color(0xFFCFEBDD),
  Color(0xFFD9E4FF),
  Color(0xFFFFD9D2),
  Color(0xFFE6DAF7),
];
class Notecard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final isSelected ;

  const Notecard({super.key,
    required this.onTap,
    required this.onLongPress,
    required this.note,
    this.isSelected=false,
  });

  @override
  Widget build(BuildContext context) {
    final color= _cardColors[(note.id??0)%_cardColors.length];
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: isSelected?
                Border.all(color: Color(0xFF1B2333),width: 2.5):null,
          ),
          child: Stack(
            children: [ Padding(padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.title,
                  maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF1B2333),
                    ),
                  ),
                  Text(note.description,
                  maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: Color(0xff3B4457)
                    ),

                  )
                ],

              ),

            ),
        ]
          ),
        ),
      ),
    );
  }
}
