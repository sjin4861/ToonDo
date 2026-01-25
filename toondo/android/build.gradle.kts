import com.android.build.api.dsl.ApplicationExtension
import com.android.build.api.dsl.LibraryExtension
import com.android.build.api.variant.AndroidComponentsExtension
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Align Java/Kotlin compilation targets across all Android subprojects.
// This prevents build failures when plugins compile with mixed targets (1.8 vs 17).
subprojects {
    plugins.withId("com.android.application") {
        // Use androidComponents.finalizeDsl to avoid "sourceCompatibility has been finalized" errors.
        extensions.configure<AndroidComponentsExtension<*, *, *>>("androidComponents") {
            finalizeDsl { ext ->
                val android = ext as ApplicationExtension
                android.compileOptions.sourceCompatibility = JavaVersion.VERSION_17
                android.compileOptions.targetCompatibility = JavaVersion.VERSION_17
            }
        }
    }

    plugins.withId("com.android.library") {
        // Use androidComponents.finalizeDsl to avoid "sourceCompatibility has been finalized" errors.
        extensions.configure<AndroidComponentsExtension<*, *, *>>("androidComponents") {
            finalizeDsl { ext ->
                val android = ext as LibraryExtension
                android.compileOptions.sourceCompatibility = JavaVersion.VERSION_17
                android.compileOptions.targetCompatibility = JavaVersion.VERSION_17
            }
        }
    }

    tasks.withType<KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = JavaVersion.VERSION_17.toString()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
