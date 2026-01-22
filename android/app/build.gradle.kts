plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.no_poverty"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.no_poverty"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // REQUIRED by flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    constraints {
        implementation("androidx.activity:activity") {
            version { strictly("1.9.0") }
        }
        implementation("androidx.activity:activity-ktx") {
            version { strictly("1.9.0") }
        }

        implementation("androidx.activity:activity-compose") {
            version { strictly("1.8.2") }
        }
        implementation("androidx.core:core") {
            version { strictly("1.13.1") }
        }
        implementation("androidx.core:core-ktx") {
            version { strictly("1.13.1") }
        }

        implementation("androidx.browser:browser") {
            version { strictly("1.7.0") }
        }
    }
}

flutter {
    source = "../.."
}