<div dir="rtl" align="center">

# 🪟 RTL Fixer

**هر متنی رو انتخاب کن، ⌥R بزن — پنجره‌ی شیشه‌ای شناور، همون متن رو با چینش درست راست‌به‌چپ نشونت میده.**

برای همه‌ی اون جاهایی که فارسی و انگلیسی قاطی میشن و چینش متن اذیت می‌کنه.

[![macOS](https://img.shields.io/badge/macOS-26%2B-black?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-6-orange?logo=swift&logoColor=white)](https://www.swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Liquid Glass](https://img.shields.io/badge/UI-Liquid%20Glass-8e7cf5)](README.fa.md)

[English](README.md) | **فارسی**

</div>

---

<div dir="rtl">

## ✨ امکانات

- 🖥️ **پنجره‌ی شناور با تم Liquid Glass** (API واقعی macOS 26)
- ⌨️ میانبر سراسری **⌥R** — کار می‌کنه هر جا که باشی
- 🖱️ **آیکون Dock** — کلیک روش همون کار میانبر رو می‌کنه (باز/بسته)
- 📖 متن انتخابی با Accessibility API خونده میشه، **بدون دست‌زدن به کلیپ‌بوردت**
- 📋 اگه اپلیکیشن متن انتخابی رو گزارش نده (مثل مرورگرها)، خودکار با شبیه‌سازی ⌘C فال‌بک می‌کنه
- 🔍 **حالت بزرگ‌نمایی** — با یه کلیک پنجره تقریباً تمام‌صفحه میشه؛ برای متن‌های طولانی عالیه
- 🖥️ پنجره **روی اپ‌های فول‌اسکرین** هم نمایش داده میشه
- 📝 متن داخل پنجره قابل انتخاب و کپیه؛ بستن با `Esc` یا کلیک بیرون از پنجره

## 🚀 نصب

### پیش‌نیاز

- macOS 26 (Tahoe) یا جدیدتر
- Xcode یا فقط Command Line Tools برای بیلد:
  ```bash
  xcode-select --install
  ```

### بیلد و اجرا

```bash
git clone https://github.com/<username>/rtl-fixer.git
cd rtl-fixer
./build.sh
open "build/RTL Fixer.app"
```

یا اپ رو ببر توی `/Applications` که آیکون Dock پایدار بمونه:

```bash
cp -R "build/RTL Fixer.app" /Applications/
open -a "RTL Fixer"
```

### دسترسی Accessibility (فقط بار اول)

دفعه‌ی اول مک درخواست می‌کنه:

> **تنظیمات سیستم ← حریم خصوصی و امنیت ← دسترسی‌پذیری ← «RTL Fixer» رو فعال کن**

### آیکون Dock همیشه‌گی

1. اپ رو اجرا کن
2. روی آیکونش توی Dock راست‌کلیک کن ← **Options ← Keep in Dock**

## 🕹️ استفاده

1. هر جا متنی انتخاب کن (سایت، تلگرام، PDF، هر جا!)
2. **⌥R** بزن (یا روی آیکون Dock کلیک کن)
3. پنجره‌ی شیشه‌ای کنار ماوس باز میشه و متن رو **راست‌به‌چین و مرتب** نشون میده
4. دکمه‌ی 🔍 پنجره رو بزرگ می‌کنه، دکمه‌ی 📋 متن رو کپی می‌کنه
5. بستن با `Esc` یا کلیک بیرون پنجره

## 🛠️ عیب‌یابی

**سوییچ Accessibility روشنه ولی باز میگه دسترسی بده؟**
این بعد از rebuild اتفاق میفته چون امضای ad-hoc عوض میشه. اجراش کن:

```bash
./fix-permission.sh
```

و بعد سوییچ رو دوباره روشن کن.

## 🧱 نحوه‌ی کارکرد

| بخش | توضیح |
|---|---|
| `SelectionReader` | اول `kAXSelectedTextAttribute` اپ فوکوس‌شده رو می‌خونه؛ اگه خالی بود ⌘C شبیه‌سازی می‌کنه |
| `HotKeyManager` | میانبر سراسری با Carbon `RegisterEventHotKey` |
| `FloatingPanel` | `NSPanel` بدون قاب و non-activating با `.fullScreenAuxiliary` |
| `FloatingContentView` | SwiftUI با `layoutDirection(.rightToLeft)` و `glassEffect` |

## 📄 لایسنس

MIT — آزادانه استفاده کن، تغییر بده، منتشر کن. [LICENSE](LICENSE)

</div>
