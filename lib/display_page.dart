import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatelessWidget {
  final File imageFile;
  final dynamic output; // Adjust type if you know the structure
  final String mappingsHtml;
  final List<Map<String, dynamic>> crabData;

  const DisplayPage({
    Key? key,
    required this.imageFile,
    required this.output,
    required this.mappingsHtml,
    required this.crabData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        backgroundColor: Colors.orange[900],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImageContainer(),
              const SizedBox(height: 20),
              _buildClassificationOutput(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Container for displaying the image
  Widget _buildImageContainer() {
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      height: 300, // Fixed height for the image container
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        color: Colors.orange,
        strokeWidth: 3,
        dashPattern: const [15, 15],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12), // Match border radius
          child: Center(
            child: Transform.scale(
              scale: 1.5, // Adjust scale as needed
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Container for displaying the classification output
  Widget _buildClassificationOutput(
      {EdgeInsetsGeometry margin = const EdgeInsets.all(20)}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Classification Results:',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          _buildOutputText(margin: margin), // Pass margin to the method
        ],
      ),
    );
  }

  // Method to display output in a specific order and align left
  Widget _buildOutputText(
      {EdgeInsetsGeometry margin = const EdgeInsets.all(20)}) {
    List<Widget> outputTextWidgets = [];

    // Display basic classification details
    outputTextWidgets.add(
      Text(
        'Species:          ${output['Species'] ?? 'N/A'}',
        style: const TextStyle(fontSize: 24, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
    outputTextWidgets.add(const SizedBox(height: 4));

    outputTextWidgets.add(
      Text(
        'Confidence:   ${(output['Confidence'] ?? 0).toStringAsFixed(2)}%',
        style: const TextStyle(fontSize: 24, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
    outputTextWidgets.add(const SizedBox(height: 4));

    outputTextWidgets.add(
      Text(
        'Color:              ${output['Color'] ?? 'N/A'}',
        style: const TextStyle(fontSize: 24, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );
    outputTextWidgets.add(const SizedBox(height: 4));

    outputTextWidgets.add(
      Text(
        'Shape:             ${output['Shape'] ?? 'N/A'}',
        style: const TextStyle(fontSize: 24, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
    );

    // Display additional information based on species identified
    String species = output['Species'] ?? '';
    if (species == 'Kurusan') {
      outputTextWidgets.add(const SizedBox(height: 30));
      outputTextWidgets.add(const Text(
        'English Name: Christian Crab or Crucifix Crab\n'
        'Local Name: Kurusan\n'
        'Scientific Name: Charybdis fereiata\n'
        'Ecology: Inhabit sandy-muddy substrates; occur at depths from 30 to 60 m.',
        style: TextStyle(fontSize: 24, color: Colors.black87),
      ));
    } else if (species == 'Alimango') {
      outputTextWidgets.add(const SizedBox(height: 30));
      outputTextWidgets.add(const Text(
        'English Name: Orange Mud Crab\n'
        'Local Name: Alimango\n'
        'Scientific Name: Scylla olivacea\n'
        'Ecology: Inhabit mangroves; benthic carnivore, feed mainly on molluscs.',
        style: TextStyle(fontSize: 24, color: Colors.black87),
      ));
    } else if (species == 'Kumong') {
      outputTextWidgets.add(const SizedBox(height: 30));
      outputTextWidgets.add(const Text(
        'English Name: Stone Crab\n'
        'Local Name: Kumong\n'
        'Scientific Name: Menippe rumphii\n'
        'Ecology: Can be found in 1⁄2–3 ft (15–90 cm) deep holes near dock pilings in water 1–5 ft (30–150 cm) deep.',
        style: TextStyle(fontSize: 24, color: Colors.black87),
      ));
    } else if (species == 'Kalintugas') {
      outputTextWidgets.add(const SizedBox(height: 30));
      outputTextWidgets.add(const Text(
        'English Name: Ridged Swimming Crab\n'
        'Local Name: Kalintugas\n'
        'Scientific NameE: Charybdis variegata\n'
        'Ecology: Occurs at depths from intertidal to 50 m. Inhabits rocky areas, sandy-rocky areas, corals reefs and areas near coral reefs.',
        style: TextStyle(fontSize: 24, color: Colors.black87),
      ));
    } else if (species == 'Dawat (Adult)' || species == 'Dawat (Juvenile)') {
      outputTextWidgets.add(const SizedBox(height: 30));
      outputTextWidgets.add(const Text(
        'English Name: Crenate Swimming Crab\n'
        'Local Name: Dawat\n'
        'Scientific NameE: Thalamita crenata\n'
        'Ecology: Inhabit shallow non-reef areas with soft substrates.',
        style: TextStyle(fontSize: 24, color: Colors.black87),
      ));
    } else if (species == 'Kasag (Female)' || species == 'Kasag (Male)') {
      outputTextWidgets.add(const SizedBox(height: 30));
      outputTextWidgets.add(const Text(
        'English Name: Blue Swimming Crab\n'
        'Local Name: Kasag\n'
        'Scientific Name: Portunus pelagicus\n'
        'Ecology: Immediate subtidal to a depth of 40m.',
        style: TextStyle(fontSize: 24, color: Colors.black87),
      ));
    }

    // Wrap everything inside a single container with an orange border and custom padding
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0), // Adjusted padding for more space inside
      margin: margin, // Custom margin
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.orange, width: 2), // Orange border color and width
        borderRadius:
            BorderRadius.circular(16), // More rounded corners for a softer look
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.0), // Light shadow color
            spreadRadius: 2, // Spread the shadow a bit for more effect
            blurRadius: 5, // Softens the shadow
            offset: Offset(0, 2), // Shadow's position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: outputTextWidgets,
      ),
    );
  }
}
