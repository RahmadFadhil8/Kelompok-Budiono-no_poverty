plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.no_poverty"
    compileSdk = flutter.compileSdkVersion
<<<<<<< HEAD
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
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    }
=======
    ndkVersion = "27.0.12077973"
>>>>>>> d4fed5c020b9bac104d68a3d3628d8241769e5a3

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
<<<<<<< HEAD
        // TODO: Specify your own unique Application ID[](https://developer.android.com/studio/build/application-id.html).
=======
>>>>>>> d4fed5c020b9bac104d68a3d3628d8241769e5a3
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