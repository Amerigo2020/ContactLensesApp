# Play Store Assets - LensGuard

This directory contains all visual assets required for Google Play Store submission.

## Directory Structure

```
play_store/
├── icons/
│   ├── ic_launcher_512.png          # High-res icon (512x512)
│   └── ic_notification.png          # Notification icon (white silhouette)
├── screenshots/
│   ├── phone/
│   │   ├── 01_splash_screen.png     # Splash/Login screen
│   │   ├── 02_dashboard.png         # Main dashboard with wear tracking
│   │   ├── 03_reminders.png         # Reminder settings
│   │   ├── 04_price_tracking.png    # Price tracking/alerts
│   │   └── 05_profile.png           # User profile
│   ├── tablet_7inch/ (optional)
│   └── tablet_10inch/ (optional)
├── feature_graphic/
│   └── feature_graphic_1024x500.png # Feature banner
└── README.md                        # This file
```

## Asset Requirements

### 1. App Icon (ic_launcher_512.png)
- **Size**: 512x512 pixels
- **Format**: 32-bit PNG with alpha channel
- **File size**: Max 1024 KB
- **Design**: LensGuard logo with blue gradient
- **Note**: Used in Play Store listing and as high-res icon

### 2. Notification Icon (ic_notification.png)
- **Size**: Various sizes (hdpi to xxxhdpi)
- **Color**: White (#FFFFFF) silhouette
- **Background**: Transparent
- **Format**: PNG
- **Design**: Simple contact lens or eye icon
- **Location in project**: `android/app/src/main/res/drawable/ic_notification.png`

### 3. Feature Graphic (feature_graphic_1024x500.png)
- **Size**: 1024 x 500 pixels
- **Format**: JPG or 24-bit PNG (no alpha)
- **File size**: Max 1024 KB
- **Design**: LensGuard branding with app screenshot or key features
- **Text**: "LensGuard - Your Smart Contact Lens Assistant"

### 4. Phone Screenshots
- **Quantity**: Minimum 2, maximum 8 (recommended: 4-5)
- **Size**: 
  - Min dimension: 320px
  - Max dimension: 3840px
  - Recommended: 1080 x 1920 (portrait) or 1920 x 1080 (landscape)
- **Format**: JPG or 24-bit PNG
- **Aspect ratio**: 16:9 or 9:16

**Required Screenshots**:
1. **Splash/Login Screen**
   - Shows LensGuard branding and sign-in options
   - Clean, professional first impression

2. **Dashboard with Wear Tracking**
   - Main feature: "Day 4 of 14" lens tracking
   - Visual progress indicator
   - "Start New Pair" button

3. **Reminder Settings**
   - Daily notification times
   - Toggles for insertion/removal reminders
   - Clean settings UI

4. **Price Tracking**
   - Price alerts card
   - Multiple retailers shown
   - Best price highlighted

5. **User Profile** (optional)
   - Prescription details
   - Account settings
   - Data privacy options

### 5. Tablet Screenshots (Optional but Recommended)
- **7-inch tablet**: 1024 x 600 or 1920 x 1200
- **10-inch tablet**: 1920 x 1200 or 2560 x 1600
- Minimum 1 screenshot per tablet size

## Creating Screenshots

### Using Android Emulator

```bash
# 1. Start emulator with desired screen size
flutter emulators --launch Pixel_5_API_34

# 2. Run app in release mode
flutter run --release

# 3. Capture screenshots using Android Studio
# Tools > Take Screenshot
# Or use ADB:
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png screenshot_01.png
```

### Using Physical Device

```bash
# Press Power + Volume Down simultaneously
# Or use ADB as shown above
```

### Best Practices for Screenshots

1. **Use realistic data**: Don't use "Lorem Ipsum" or placeholder text
2. **Show key features**: Each screenshot should highlight one main feature
3. **Clean UI**: Remove debug info, ensure good lighting for photos
4. **Consistent theme**: Use same color scheme across all screenshots
5. **Add captions** (optional): Short text overlay explaining the feature
6. **Localize**: Create screenshots in all supported languages

## Localization

If supporting multiple languages, create separate screenshot sets for each:

```
screenshots/
├── en-US/
│   ├── 01_splash_screen.png
│   └── ...
├── de-DE/
│   ├── 01_splash_screen.png
│   └── ...
└── fr-FR/
    ├── 01_splash_screen.png
    └── ...
```

## Upload Checklist

Before uploading to Play Console:

- [ ] High-res icon (512x512) ready
- [ ] Feature graphic (1024x500) ready
- [ ] Minimum 2 phone screenshots ready
- [ ] Screenshots show real, functional app (not mockups)
- [ ] All images meet size requirements
- [ ] File sizes under limits (1024 KB per file)
- [ ] No placeholder or debug text visible
- [ ] No copyright violations (e.g., stock photos without license)
- [ ] Consistent branding across all assets

## Tools & Resources

### Design Tools
- **Figma**: For creating mockups and assets
- **Adobe Photoshop**: For image editing
- **Canva**: For quick graphic creation
- **Sketch**: For UI design (Mac only)

### Screenshot Tools
- **Android Studio Device Manager**: Built-in screenshot tool
- **Fastlane Screengrab**: Automated screenshot capture
- **DaVinci Apps**: Screenshot editing and framing

### Optimization Tools
- **TinyPNG**: Compress PNG files
- **ImageOptim**: Reduce file sizes (Mac)
- **Squoosh**: Web-based image optimizer

## Common Mistakes to Avoid

❌ **Don't**:
- Use blurry or pixelated images
- Show debug information or error states
- Include copyrighted content without permission
- Use outdated screenshots after UI changes
- Forget to update screenshots when adding new features

✅ **Do**:
- Use high-quality, crisp images
- Show the app in its best state
- Update regularly with app updates
- Test on multiple screen sizes
- Get feedback before uploading

## Examples

### Good Screenshot Examples:
- Clear, high-resolution image (1080p+)
- Shows main feature prominently
- Realistic user data
- Clean, professional UI
- Good contrast and readability

### Bad Screenshot Examples:
- Blurry or low-resolution
- Empty states or placeholder text
- Debug info visible
- Poor lighting or color balance
- Text too small to read

## Asset Versions

Track your asset versions here:

| Asset | Version | Date | Changes |
|-------|---------|------|---------|
| App Icon | 1.0 | 2024-12-10 | Initial design |
| Feature Graphic | 1.0 | 2024-12-10 | Initial design |
| Screenshots | 1.0 | 2024-12-10 | App v1.0 screens |

## Contact

For design feedback or asset questions:
- **Designer**: [Your Name]
- **Email**: design@lensguard.app

---

**Last Updated**: December 10, 2024  
**App Version**: 1.0.0
