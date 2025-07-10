# 🚛 LogiCA Mobile

> **Sistem Monitoring dan Manajemen Kendaraan Logistik**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 Tentang Aplikasi

LogiCA Mobile adalah aplikasi mobile yang dirancang untuk sistem monitoring dan manajemen kendaraan logistik. Aplikasi ini memastikan kendaraan menjalani maintenance rutin untuk menjaga keselamatan kerja dan memerlukan laporan transparan dari supir untuk memvalidasi data.

### 🎯 Tujuan Utama

- **Monitoring Kendaraan**: Melacak status dan kondisi kendaraan secara real-time
- **Maintenance Management**: Mengatur jadwal dan riwayat maintenance kendaraan
- **Driver Reporting**: Sistem pelaporan rutin dari supir untuk transparansi data
- **Safety Compliance**: Memastikan keselamatan kerja melalui maintenance berkala

## ✨ Fitur Utama

### 👨‍💼 Dashboard Supir
- Form pelaporan harian
- Dokumentasi foto kendaraan
- Status maintenance kendaraan
- Notifikasi maintenance

### 🔧 Dashboard Mekanik
- Daftar maintenance yang perlu dilakukan
- Status ongoing service
- Ready service management
- Pilih mekanik untuk tugas

### 📊 Monitoring & Reporting
- Laporan rutin dari supir
- Validasi data transparan
- Tracking maintenance history
- Real-time status updates

## 🛠️ Teknologi yang Digunakan

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **Platform**: Android & iOS
- **Architecture**: MVC Pattern
- **State Management**: Provider/Bloc
- **Backend**: REST API Integration

## 🚀 Cara Menjalankan Aplikasi

### Prerequisites
- Flutter SDK (3.0 atau lebih baru)
- Dart SDK
- Android Studio / VS Code
- Android SDK (untuk Android)
- Xcode (untuk iOS, macOS only)

### Installation

1. **Clone repository**
   ```bash
   git clone https://github.com/your-username/LogiCA-Mobile.git
   cd LogiCA-Mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build untuk Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📱 Screenshots

> *Screenshots akan ditambahkan di sini*

## 🏗️ Struktur Proyek

```
lib/
├── auth_token.dart          # Token authentication
├── login.dart              # Login screen
├── main.dart               # Main app entry
├── Model/                  # Data models
│   ├── main_model.dart
│   ├── maintenance_model.dart
│   └── vehicle_model.dart
├── notification/           # Notification services
├── pages_driver/          # Driver pages
│   ├── form.dart
│   ├── formfoto.dart
│   ├── maintenance.dart
│   └── supir_dashboard.dart
├── pages_mechanic/        # Mechanic pages
│   ├── dashboard_mekanik.dart
│   ├── list_maintainance.dart
│   ├── ongoing_mekanik.dart
│   ├── ongoing_service.dart
│   ├── pilih_mekanik.dart
│   ├── ready_mekanik.dart
│   └── ready_service.dart
└── services/              # API services
    └── auth_service.dart
```

## 🤝 Kontribusi

Kami menyambut kontribusi dari siapa saja! Berikut cara berkontribusi:

1. Fork repository ini
2. Buat branch fitur baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## 📄 Lisensi

Proyek ini dilisensikan di bawah Lisensi MIT - lihat file [LICENSE](LICENSE) untuk detail lebih lanjut.

## 📞 Kontak

- **Email**: [your-email@example.com]
- **Website**: [https://your-website.com]
- **LinkedIn**: [https://linkedin.com/in/your-profile]

---

<div align="center">
  <p>Dibuat dengan ❤️ untuk keselamatan kerja logistik</p>
  <p>🚛 LogiCA Mobile - Monitoring Kendaraan yang Lebih Baik</p>
</div>
