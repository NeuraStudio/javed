# NeuraAster — Setup (Phase 2: real features, multi-file structure)

## Kya naya hai is version mein
- Poora code multi-file structure mein: `lib/config`, `lib/models`, `lib/services`,
  `lib/providers`, `lib/screens`, `lib/widgets`, `lib/theme`
- **Real chat history** — local device pe saved (shared_preferences), sidebar
  mein search + reopen + delete
- **Real Live Session** (voice mode) — asli speech-to-text sunta hai, backend
  ko bhejta hai, agar backend audio reply de to auto-play karta hai
- **Real attachments** — Camera / Photos / Files sab real pickers hain
- **Real "Think harder" toggle** — prompt mein reasoning hint jodta hai
- **Real Settings** — theme (light/dark/system), accent color, voice
  gender/language — sab locally saved
- **Real Profile** — actual local stats (kitne chats, kitne messages),
  backend URL, about
- Subscription/paywall waala kuch bhi nahi hai
- iOS hata diya gaya hai (sirf Android ke liye)

## Jo cheezein jaan-boojh kar nahi dali
Gemini app mein kuch options Google ke apne account/cloud infra se bandhe
hain — humare custom backend (`/api/chat`, `/api/clear`) se unka koi real
implementation possible nahi tha, isliye "sab kuchh real ho, kuchh fake na
ho" wali baat maan ke unhe chhod diya: Manage Google Account, Gemini Apps
activity, Import memory to Gemini, Switch to Google Assistant. Agar future
mein tumhara backend inke liye real endpoints de (jaise apna memory/account
system), to unko bhi real feature ki tarah jod sakte hain.

## GitHub Actions se APK banana
1. Naye files ko commit + push karo:
   ```
   git add -A
   git commit -m "Phase 2: real features, multi-file structure"
   git push
   ```
2. Actions tab pe build dekho, complete hone pe Artifacts se `neuraaster-apk`
   download karo.

## Permissions
App pehli baar camera/mic/photos use karte waqt khud permission maangega
(Android ka standard runtime permission dialog) — koi extra setup nahi
chahiye.

## Backend URL
`lib/config/api_config.dart` mein `ApiConfig.baseUrl` badal sakte ho.
