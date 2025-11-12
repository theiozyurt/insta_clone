plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

    // 1. YENİ EKLENEN SATIR:
    // Google Services plugin'ini bu 'app' modülünde uygula
    id("com.google.gms.google-services")
}

android {
    namespace = "com.ozyurt.insta_clone"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ozyurt.insta_clone"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// 2. YENİ EKLENEN BLOK:
// Aradığın 'dependencies' bloğu burası.
// Kotlin Script'te söz dizimi (syntax) farklıdır, (' yerine " kullanılır
// ve 'implementation' bir fonksiyondur, bu yüzden () kullanılır).
dependencies {
    // Firebase Sürüm Yönetimi (BOM - Bill of Materials)
    // Bu, tüm Firebase kütüphanelerinin birbiriyle uyumlu sürümlerini otomatik seçer.
    implementation(platform("com.google.firebase:firebase-bom:33.1.1"))

    // iOS'te eklediğin paketlerin (veya ihtiyaç duyduklarının) Android karşılıkları:
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-storage")

    // Google Analytics (Firebase için önerilir)
    implementation("com.google.firebase:firebase-analytics")
}