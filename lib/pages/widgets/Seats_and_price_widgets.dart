import 'package:flutter/material.dart';

class SeatsAndPriceRowWidget extends StatefulWidget {
  final TextEditingController priceController;
  final int availableSeats;

  SeatsAndPriceRowWidget({
    required this.priceController,
    required this.availableSeats,
  });

  @override
  _SeatsAndPriceRowWidgetState createState() => _SeatsAndPriceRowWidgetState();
}

class _SeatsAndPriceRowWidgetState extends State<SeatsAndPriceRowWidget> {
  int? _availableSeats;

  @override
  void initState() {
    super.initState();
    _availableSeats = widget.availableSeats;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/icons/seats.png',
          width: 44,
          height: 44,
          color: Colors.white,
        ),
        SizedBox(width: 16.0),
        DropdownButton<int>(
          value: _availableSeats,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _availableSeats = value;
              });
            }
          },
          items: List.generate(
            3,
                (index) => DropdownMenuItem(
              value: index + 1,
              child: Container(
                color: Colors.black,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.0), // Add spacing between seats and price
        Expanded(
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            controller: widget.priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: ImageIcon(
                AssetImage('assets/icons/rands.png'),
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
