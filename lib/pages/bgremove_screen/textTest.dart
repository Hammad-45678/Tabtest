import 'package:flutter/material.dart';

class ImageTextEditor extends StatefulWidget {
  const ImageTextEditor({super.key});

  @override
  _ImageTextEditorState createState() => _ImageTextEditorState();
}

class _ImageTextEditorState extends State<ImageTextEditor> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<TextItem> _textItems = [];
  bool _isAddingText = false;
  final Offset _textPosition = const Offset(50.0, 50.0);
  final double _textScale = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          // Display the image
          Image.asset(
            'assets/images/bg1.webp', // Replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Display text items
          for (var item in _textItems)
            Positioned(
              left: item.position.dx,
              top: item.position.dy,
              child: Transform.scale(
                scale: item.scale,
                child: DraggableText(
                  text: item.text,
                  onPositionChanged: (offset) {
                    setState(() {
                      item.position = offset;
                    });
                  },
                  onScaleChanged: (scale) {
                    setState(() {
                      item.scale = scale;
                    });
                  },
                ),
              ),
            ),
          // Display a text input field for user input
          if (_isAddingText)
            Positioned(
              bottom: 160,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Enter text here',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // Clear the input field and hide it
                      setState(() {
                        _textEditingController.clear();
                        _isAddingText = false;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Add the text to the list
                      setState(() {
                        _textItems.add(TextItem(
                          text: _textEditingController.text,
                          position: _textPosition,
                          scale: _textScale,
                        ));
                        // Clear the input field and hide it
                        _textEditingController.clear();
                        _isAddingText = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          // Display button to add text
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Show the text input field when the button is tapped
                setState(() {
                  _isAddingText = true;
                });
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    ));
  }
}

class DraggableText extends StatefulWidget {
  final String text;
  final Function(Offset) onPositionChanged;
  final Function(double) onScaleChanged;

  const DraggableText({super.key, 
    required this.text,
    required this.onPositionChanged,
    required this.onScaleChanged,
  });

  @override
  _DraggableTextState createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  Offset _position = const Offset(0.0, 0.0);
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) {
        setState(() {
          _position += details.focalPoint - details.localFocalPoint;
          _scale = details.scale;
        });
        widget.onPositionChanged(_position);
        widget.onScaleChanged(_scale);
      },
      child: Transform.translate(
        offset: _position,
        child: Transform.scale(
          scale: _scale,
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class TextItem {
  String text;
  Offset position;
  double scale;

  TextItem({
    required this.text,
    required this.position,
    required this.scale,
  });
}
