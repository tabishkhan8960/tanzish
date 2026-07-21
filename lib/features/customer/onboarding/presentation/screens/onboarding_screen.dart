import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';

const onboardingSeenKey = 'onboarding_seen';

class OnboardingSlide {
  const OnboardingSlide(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

const _slides = [
  OnboardingSlide(Icons.checkroom_rounded, 'Choose Products', 'Browse thousands of products across every category, curated just for you.'),
  OnboardingSlide(Icons.payment_rounded, 'Make Payment', 'Pay securely with your preferred method — cards, wallets, and more.'),
  OnboardingSlide(Icons.local_shipping_rounded, 'Get Your Order', 'Track your order in real time, right up to your doorstep.'),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingSeenKey, true);
    if (mounted) context.go('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(onPressed: _finish, child: const Text('Skip')),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final slide = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 220,
                          width: 220,
                          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
                          child: Icon(slide.icon, size: 96, color: AppColors.primary),
                        ),
                        const SizedBox(height: 40),
                        Text(slide.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: i == _index ? 20 : 6,
                  decoration: BoxDecoration(
                    color: i == _index ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_index > 0)
                    TextButton(
                      onPressed: () => _controller.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                      child: const Text('Prev'),
                    )
                  else
                    const SizedBox(width: 64),
                  const Spacer(),
                  SizedBox(
                    width: isLast ? 160 : 100,
                    child: PrimaryButton(
                      label: isLast ? 'Get Started' : 'Next',
                      onPressed: isLast
                          ? _finish
                          : () => _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
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
}
