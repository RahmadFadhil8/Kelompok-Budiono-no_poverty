plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.no_poverty"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.14206865"

    dependencies {
        constraints {
            implementation("androidx.activity:activity") {
                version { strictly("1.8.2") }
                because("force downgrade activity to support AGP 8.7.0 without upgrade")
            }
            implementation("androidx.activity:activity-ktx") {
                version { strictly("1.8.2") }
                because("force downgrade activity to support AGP 8.7.0 without upgrade")
            }
            implementation("androidx.activity:activity-compose") {
                version { strictly("1.8.2") }
                because("force downgrade activity to support AGP 8.7.0 without upgrade")
            }
            implementation("androidx.core:core") {
            version { strictly("1.12.0") }
        }
        implementation("androidx.core:core-ktx") {
            version { strictly("1.12.0") }
        }

        // Browser harus turun dari 1.9.0 → 1.7.0
        implementation("androidx.browser:browser") {
            version { strictly("1.7.0") }
        }
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.no_poverty"
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
