import 'package:flutter/material.dart';
import '../app/theme.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Credits"),
        backgroundColor: AppTheme.darkBrown,
        leading: BackButton(color: AppTheme.textPrimary),
      ),
      body: AppTheme.backgroundContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(),
              const SizedBox(height: 24),

              // Development Team
              _buildSectionTitle("Development Team"),
              _buildCreditCard(
                icon: Icons.code,
                title: "Lead Developer",
                subtitle: "Your Name Here",
                description:
                    "Project architecture, gameplay mechanics, and core systems",
              ),
              _buildCreditCard(
                icon: Icons.palette,
                title: "UI/UX Design",
                subtitle: "Design Team",
                description: "Interface design and user experience",
              ),

              const SizedBox(height: 24),

              // Technologies Used
              _buildSectionTitle("Built With"),
              _buildTechnologyCard(
                icon: Icons.flutter_dash,
                name: "Flutter",
                description: "Cross-platform UI framework",
              ),
              _buildTechnologyCard(
                icon: Icons.code_rounded,
                name: "Dart",
                description: "Programming language",
              ),

              const SizedBox(height: 24),

              // Special Thanks
              _buildSectionTitle("Special Thanks"),
              _buildCreditCard(
                icon: Icons.favorite,
                title: "Community",
                subtitle: "Flutter & Dart Community",
                description: "For amazing tools, packages, and support",
              ),

              const SizedBox(height: 32),

              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.diamond, size: 80, color: AppTheme.amberAccent),
          const SizedBox(height: 16),
          const Text(
            "CodeMiner",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Version 1.0.0",
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCreditCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Card(
      color: AppTheme.accentBrown,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.amberAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.amberAccent, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.amberAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnologyCard({
    required IconData icon,
    required String name,
    required String description,
  }) {
    return Card(
      color: AppTheme.accentBrown,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.amberAccent.withOpacity(0.2),
          child: Icon(icon, color: AppTheme.amberAccent),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          const Divider(color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(
            "© 2025 CodeMiner",
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            "Made with ❤️ using Flutter",
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
