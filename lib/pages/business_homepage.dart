import 'package:flutter/material.dart';

class BusinessHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Business Name',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: 20),

            // Business Information
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.blue),
              title: Text(
                '123 Main Street, City',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text(
                'contact@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),

            // Services Showcase
            Text(
              'Our Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            // Add service/product items here (e.g., ListTile, Card, etc.)

            // Customer Testimonials
            Text(
              'Customer Testimonials',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            // Add customer testimonials here

            // Call to Action (CTA)
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the CTA action (e.g., contact form, reservation, etc.)
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Contact Us',
                style: TextStyle(fontSize: 18),
              ),
            ),

            // About Us
            Text(
              'About Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text('We are a business dedicated to...'),

            // Contact Information
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            // Display contact details (phone, email, etc.)

            // Map Integration (optional)
            // Add a map widget here if needed

            // Footer
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '© 2023 Business Name',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
