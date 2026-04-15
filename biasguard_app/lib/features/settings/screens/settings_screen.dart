import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/locale_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final appLocale = ref.watch(localeProvider);
    final isHindi = ref.watch(localeProvider.notifier).isHindi;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isHindi ? 'सिस्टम सेटिंग्स' : 'System Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Text(isHindi ? 'दिखावट और भाषा' : 'Appearance & Language', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          
          _buildSwitchTile(
            context, 
            isHindi ? 'डार्क मोड' : 'Dark Mode', 
            isHindi ? 'Sentinel Obsidian डार्क थीम लागू करें' : 'Enable high-contrast dark theme (Sentinel Obsidian).', 
            themeMode == ThemeMode.dark,
            (val) => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          const Divider(),
          
          _buildDropdownTile(
            context, 
            isHindi ? 'भाषा' : 'Application Language', 
            isHindi ? 'अपनी पसंदीदा इंटरफ़ेस भाषा चुनें' : 'Select your preferred interface language.', 
            appLocale == AppLocale.en ? 'English' : 'Hindi', 
            ['English', 'Hindi'],
            (val) => ref.read(localeProvider.notifier).toggleLocale(),
          ),
          const SizedBox(height: 48),

          Text(isHindi ? 'वरीयताएँ' : 'Preferences', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          _buildSwitchTile(context, isHindi ? 'सख्त समानता मोड' : 'Strict Parity Mode', isHindi ? 'स्वचालित रूप से उच्चतम बाधाएं लागू करें' : 'Enforce highest constraints automatically.', true, (v) {}),
          const Divider(),
          
          const SizedBox(height: 48),

          Text(isHindi ? 'कानूनी और गोपनीयता' : 'Legal & Privacy', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          ListTile(
            title: Text(isHindi ? 'गोपनीयता नीति' : 'Privacy Policy'),
            subtitle: Text(isHindi ? 'हम आपके डेटा को कैसे सुरक्षित रखते हैं' : 'How we protect your data integrity.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/privacy'),
          ),
          const Divider(),
          ListTile(
            title: Text(isHindi ? 'सेवा की शर्तें' : 'Terms of Service'),
            subtitle: Text(isHindi ? 'उपयोग की शर्तें और कानूनी विवरण' : 'Usage conditions and legal boundaries.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/terms'),
          ),
          
          const SizedBox(height: 64),
          Center(
            child: Text(
              'BiasGuard v1.0.0+1\nGoogle Solution Challenge 2026',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildDropdownTile(BuildContext context, String title, String subtitle, String current, List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: Cross => CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          DropdownButton<String>(
            value: current,
            dropdownColor: AppColors.surfaceContainerHigh,
            underline: const SizedBox(),
            onChanged: onChanged,
            items: options.map((opt) => DropdownMenuItem(
              value: opt,
              child: Text(opt, style: Theme.of(context).textTheme.bodyLarge),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
