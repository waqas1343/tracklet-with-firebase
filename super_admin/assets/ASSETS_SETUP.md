# Assets Setup Guide

## 📁 Required Asset Structure

Create these folders in the `assets/` directory:

```
assets/
├── lottie/
│   ├── empty_state.json
│   └── loading.json
└── images/
    └── default_avatar.png
```

## 🎬 Lottie Files

### Where to Download
Visit [LottieFiles.com](https://lottiefiles.com/) to download free animations.

### Recommended Animations

1. **Empty State** (`empty_state.json`)
   - Search: "empty state" or "no data"
   - Example: https://lottiefiles.com/animations/empty
   - Use for: Empty user lists, no search results

2. **Loading** (`loading.json`)
   - Search: "loading" or "spinner"
   - Example: https://lottiefiles.com/animations/loading
   - Use for: Initial data loading

### How to Add
1. Download `.json` file from LottieFiles
2. Place in `assets/lottie/` folder
3. Ensure filename matches exactly as listed above
4. Run `flutter pub get` to register assets

## 🖼️ Images

### Default Avatar
- Size: 150x150px recommended
- Format: PNG with transparency
- Fallback for users without profile pictures

### Where to Get
- [UI Faces](https://uifaces.co/)
- [Pravatar](https://pravatar.cc/)
- Create your own placeholder

## ✅ Verification

After adding assets, verify with:
```bash
flutter pub get
flutter run
```

Assets should load without errors.

## 🔧 Troubleshooting

### Assets Not Found
1. Check file paths match exactly (case-sensitive)
2. Ensure `pubspec.yaml` includes assets section
3. Run `flutter clean && flutter pub get`

### Lottie Not Animating
1. Verify JSON file is valid
2. Check file size (< 1MB recommended)
3. Try a different animation

## 📝 Optional: Custom Assets

You can add more assets by:
1. Creating new folders in `assets/`
2. Adding to `pubspec.yaml`:
   ```yaml
   assets:
     - assets/lottie/
     - assets/images/
     - assets/your_folder/  # Add here
   ```

## 🎨 Icons

Material Icons are included by default. No additional setup needed.

For custom icons:
- Add SVG files to `assets/icons/`
- Use `flutter_svg` package
- Update `pubspec.yaml`

---

**Note**: App will work without Lottie files (they're optional). Default Material icons will be used as fallback.

