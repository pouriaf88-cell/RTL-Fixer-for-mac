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
- 🔤 با فونت **وزیرمتن** نمایش داده میشه (داخل اپ باندل شده، بدون هیچ تنظیم اضافه)

## 📦 دانلود نسخه‌ی آماده

فایل **`RTL-Fixer-1.1.0.zip`** رو از صفحه‌ی [Releases](../../releases) بگیر، از حالت فشرده دربیار و اپ رو ببر توی `/Applications`.

چون اپ نوتاریزی نشده، ممکنه مک بار اول بلاکش کنه. یکی از این دوتا کار رو بکن:

- توی ترمینال بزن: `xattr -cr "RTL Fixer.app"`
- یا روی اپ راست‌کلیک کن ← **Open** (دو بار) توی پنجره‌ی هشدار

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
این مشکل حل شده! قبلاً چون امضای ad-hoc با هر بیلد عوض میشد مک دسترسی رو باطل می‌کرد. الان اپ با یه **گواهی امضای ثابت** (`RTL Fixer Developer`) امضا میشه و دسترسی با بیلد مجدد هم باقی می‌مونه. اگه به هر دلیلی دوباره پیش اومد:

```bash
./fix-permission.sh
```

**اگه خودت از سورس بیلد می‌کنی:** اگه این گواهی توی کیچینت نباشه، بیلد به‌صورت ad-hoc امضا میشه و هر rebuild دسترسی Accessibility رو باطل می‌کنه (محدودیت خود مک). برای حلش با گواهی ثابت خودت امضا کن.

## 📦 ساخت نسخه‌ی انتشار

برای ساخت فایل zip قابل انتشار:

```bash
./make-release.sh
```

خروجی: `release/RTL-Fixer-<version>.zip` (+ فایل SHA256) آماده‌ی آپلود توی GitHub Releases.

## 🧱 نحوه‌ی کارکرد

| بخش | توضیح |
|---|---|
| `SelectionReader` | اول `kAXSelectedTextAttribute` اپ فوکوس‌شده رو می‌خونه؛ اگه خالی بود ⌘C شبیه‌سازی می‌کنه |
| `HotKeyManager` | میانبر سراسری با Carbon `RegisterEventHotKey` |
| `FloatingPanel` | `NSPanel` بدون قاب و non-activating با `.fullScreenAuxiliary` |
| `FloatingContentView` | SwiftUI با `layoutDirection(.rightToLeft)` و `glassEffect` |

## 📄 لایسنس

MIT — آزادانه استفاده کن، تغییر بده، منتشر کن. [LICENSE](LICENSE)

فونت [وزیرمتن](https://github.com/rastikerdar/vazirmatn) © ساخته‌ی پروژه‌ی Vazirmatn و تحت لایسنس [SIL Open Font License 1.1](https://openfontlicense.org) منتشر شده.

</div>
