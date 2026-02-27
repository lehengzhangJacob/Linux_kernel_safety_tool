/*
 * Linux Kernel Safety Analyzer - All-in-one Executable
 *
 * Integrates: install, uninstall, analyze, test, database, clean
 * All functionality in a single binary.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <sys/stat.h>
#include <libgen.h>
#include <limits.h>

/* ── Get the directory where this executable lives ── */
static char *get_app_dir(void) {
    static char dir[PATH_MAX];
    ssize_t len = readlink("/proc/self/exe", dir, sizeof(dir) - 1);
    if (len == -1) {
        /* fallback to current directory */
        getcwd(dir, sizeof(dir));
        return dir;
    }
    dir[len] = '\0';
    /* strip the executable name, keep directory */
    char *slash = strrchr(dir, '/');
    if (slash) *slash = '\0';
    return dir;
}

/* ── Run a command in the app directory ── */
static int run_cmd(const char *fmt, ...) {
    char cmd[4096];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(cmd, sizeof(cmd), fmt, ap);
    va_end(ap);
    return system(cmd);
}

/* ── INSTALL ── */
static int do_install(const char *app_dir) {
    printf("==================================================\n");
    printf("  Linux Kernel Safety Analyzer - Installer\n");
    printf("==================================================\n\n");

    /* Step 1: System dependencies */
    printf("[1/4] Installing system dependencies (requires sudo)...\n");
    int ret = run_cmd(
        "sudo apt update && "
        "sudo apt install -y build-essential gcc-13 g++-13 gcc-13-plugin-dev "
        "libncurses-dev bison flex libssl-dev libelf-dev bc dwarves rsync cpio "
        "python3 wget tar"
    );
    if (ret != 0) {
        printf("Warning: Some system packages may have failed to install.\n");
    }

    /* Step 2: Setup JDK & Neo4j */
    printf("\n[2/4] Setting up JDK and Neo4j...\n");
    run_cmd("cd '%s' && bash setup_tools.sh", app_dir);

    /* Step 3: Compile GCC Plugin */
    printf("\n[3/4] Compiling GCC Plugin...\n");
    run_cmd("cd '%s' && make -C src/plugin clean && make -C src/plugin", app_dir);

    /* Step 4: Verify */
    printf("\n[4/4] Verifying installation...\n");
    struct stat st;
    char plugin_path[PATH_MAX];
    snprintf(plugin_path, sizeof(plugin_path), "%s/src/plugin/analyzer_plugin.so", app_dir);
    if (stat(plugin_path, &st) == 0) {
        printf("  ✓ GCC Plugin compiled successfully (%ld bytes)\n", (long)st.st_size);
    } else {
        printf("  ✗ GCC Plugin compilation FAILED\n");
        return 1;
    }

    printf("\n==================================================\n");
    printf("  Installation Complete!\n");
    printf("==================================================\n");
    printf("\n");
    printf("  Next steps:\n");
    printf("    ./kernel_analyzer test          Test the toolchain\n");
    printf("    ./kernel_analyzer analyze        Run full kernel analysis\n");
    printf("    ./kernel_analyzer start-db       Start Neo4j database\n");
    printf("    ./kernel_analyzer --help         Show all commands\n");
    return 0;
}

/* ── UNINSTALL ── */
static int do_uninstall(const char *app_dir) {
    printf("==================================================\n");
    printf("  Linux Kernel Safety Analyzer - Uninstaller\n");
    printf("==================================================\n\n");

    printf("This will remove:\n");
    printf("  - Compiled plugin (analyzer_plugin.so)\n");
    printf("  - Build artifacts (build_analysis_*)\n");
    printf("  - Analysis data and logs\n");
    printf("  - Neo4j database data\n");
    printf("  - JDK and Neo4j tools\n");
    printf("  - The kernel_analyzer executable itself\n");
    printf("\n  System packages (gcc, etc.) will NOT be removed.\n\n");

    printf("Are you sure? (y/N) ");
    fflush(stdout);
    char c = getchar();
    if (c != 'y' && c != 'Y') {
        printf("\nCancelled.\n");
        return 0;
    }
    printf("\n");

    /* Stop Neo4j */
    printf("[1/5] Stopping Neo4j...\n");
    run_cmd("cd '%s' && export JAVA_HOME='%s/tools/jdk-17.0.2' && "
            "export PATH=$JAVA_HOME/bin:$PATH && "
            "'%s/tools/neo4j-community-4.4.34/bin/neo4j' stop 2>/dev/null || true",
            app_dir, app_dir, app_dir);

    /* Remove plugin */
    printf("[2/5] Removing compiled plugin...\n");
    run_cmd("cd '%s' && make -C src/plugin clean 2>/dev/null || true", app_dir);

    /* Remove build artifacts & logs */
    printf("[3/5] Removing build artifacts and logs...\n");
    run_cmd("cd '%s' && rm -rf build_analysis_* "
            "analysis_*.log ast_*.log race_warnings_*.txt "
            "analysis_*_display.log ast_*_display.log "
            "race_warnings_*_display.txt", app_dir);

    /* Remove analysis data & Neo4j data */
    printf("[4/5] Removing analysis data...\n");
    run_cmd("cd '%s' && rm -rf analysis_data/linux-* neo4j_data_linux-*", app_dir);

    /* Remove tools */
    printf("[5/5] Removing tools (JDK & Neo4j)...\n");
    run_cmd("cd '%s' && rm -rf tools/jdk-* tools/neo4j-community-4.4.34", app_dir);

    /* Remove self */
    printf("\nRemoving kernel_analyzer executable...\n");
    run_cmd("rm -f '%s/kernel_analyzer'", app_dir);

    printf("\n==================================================\n");
    printf("  Uninstallation Complete.\n");
    printf("  Source code is preserved in src/\n");
    printf("  To reinstall: gcc src/main.c -o kernel_analyzer && ./kernel_analyzer install\n");
    printf("==================================================\n");
    return 0;
}

/* ── ANALYZE ── */
static int do_analyze(const char *app_dir, const char *kernel) {
    printf("[*] Running full analysis on %s...\n", kernel);
    printf("    This will: compile kernel with plugin → extract warnings → generate Neo4j data → start database\n\n");
    return run_cmd("cd '%s' && bash full_run.sh %s", app_dir, kernel);
}

/* ── TEST ── */
static int do_test(const char *app_dir) {
    printf("[*] Running toolchain test...\n\n");
    return run_cmd("cd '%s' && bash test_toolchain.sh", app_dir);
}

/* ── START DB ── */
static int do_start_db(const char *app_dir) {
    printf("[*] Starting Neo4j database...\n");
    printf("    Web interface: http://localhost:7474\n\n");
    return run_cmd("cd '%s' && export JAVA_HOME='%s/tools/jdk-17.0.2' && "
                   "export PATH=$JAVA_HOME/bin:$PATH && "
                   "'%s/tools/neo4j-community-4.4.34/bin/neo4j' start",
                   app_dir, app_dir, app_dir);
}

/* ── STOP DB ── */
static int do_stop_db(const char *app_dir) {
    printf("[*] Stopping Neo4j database...\n");
    return run_cmd("cd '%s' && export JAVA_HOME='%s/tools/jdk-17.0.2' && "
                   "export PATH=$JAVA_HOME/bin:$PATH && "
                   "'%s/tools/neo4j-community-4.4.34/bin/neo4j' stop",
                   app_dir, app_dir, app_dir);
}

/* ── CLEAN ── */
static int do_clean(const char *app_dir) {
    printf("[*] Cleaning build artifacts...\n");
    run_cmd("cd '%s' && export JAVA_HOME='%s/tools/jdk-17.0.2' && "
            "export PATH=$JAVA_HOME/bin:$PATH && "
            "'%s/tools/neo4j-community-4.4.34/bin/neo4j' stop 2>/dev/null || true",
            app_dir, app_dir, app_dir);
    run_cmd("cd '%s' && rm -rf build_analysis_*", app_dir);
    printf("  Build artifacts removed.\n");
    return 0;
}

/* ── STATUS ── */
static int do_status(const char *app_dir) {
    struct stat st;
    char path[PATH_MAX];

    printf("==================================================\n");
    printf("  Linux Kernel Safety Analyzer - Status\n");
    printf("==================================================\n\n");

    /* Plugin */
    snprintf(path, sizeof(path), "%s/src/plugin/analyzer_plugin.so", app_dir);
    printf("  GCC Plugin:       %s\n", stat(path, &st) == 0 ? "✓ Compiled" : "✗ Not compiled");

    /* JDK */
    snprintf(path, sizeof(path), "%s/tools/jdk-17.0.2", app_dir);
    printf("  JDK 17:           %s\n", stat(path, &st) == 0 ? "✓ Installed" : "✗ Not found");

    /* Neo4j */
    snprintf(path, sizeof(path), "%s/tools/neo4j-community-4.4.34", app_dir);
    printf("  Neo4j 4.4:        %s\n", stat(path, &st) == 0 ? "✓ Installed" : "✗ Not found");

    /* Kernel source */
    snprintf(path, sizeof(path), "%s/linux-6.6.1", app_dir);
    printf("  Kernel 6.6.1 src: %s\n", stat(path, &st) == 0 ? "✓ Available" : "✗ Not found");

    /* Build dir */
    snprintf(path, sizeof(path), "%s/build_analysis_linux-6.6.1", app_dir);
    printf("  Build artifacts:  %s\n", stat(path, &st) == 0 ? "✓ Exists (has been analyzed)" : "– Not yet analyzed");

    /* Analysis results */
    snprintf(path, sizeof(path), "%s/race_warnings_linux-6.6.1.txt", app_dir);
    printf("  Race warnings:    %s\n", stat(path, &st) == 0 ? "✓ Generated" : "– Not yet generated");

    /* Neo4j data */
    snprintf(path, sizeof(path), "%s/neo4j_data_linux-6.6.1/nodes.csv", app_dir);
    printf("  Neo4j data:       %s\n", stat(path, &st) == 0 ? "✓ Generated" : "– Not yet generated");

    printf("\n");
    return 0;
}

/* ── HELP ── */
static void print_help(void) {
    printf("==================================================\n");
    printf("  Linux Kernel Safety Analyzer v1.0\n");
    printf("==================================================\n\n");
    printf("Usage: kernel_analyzer <command> [options]\n\n");
    printf("Commands:\n");
    printf("  install            Install all dependencies and compile tools\n");
    printf("  uninstall          Remove tool, data, and dependencies\n");
    printf("  analyze [kernel]   Run full analysis (default: linux-6.6.1)\n");
    printf("  test               Test the toolchain with a sample file\n");
    printf("  start-db           Start Neo4j graph database\n");
    printf("  stop-db            Stop Neo4j graph database\n");
    printf("  clean              Remove build artifacts\n");
    printf("  status             Show installation and analysis status\n");
    printf("  --help, -h         Show this help message\n");
    printf("\nTypical workflow:\n");
    printf("  1. ./kernel_analyzer install       # First-time setup\n");
    printf("  2. ./kernel_analyzer test           # Verify everything works\n");
    printf("  3. ./kernel_analyzer analyze        # Analyze Linux kernel (~3 min)\n");
    printf("  4. Open http://localhost:7474       # View results in Neo4j\n");
    printf("  5. ./kernel_analyzer stop-db        # Stop database when done\n");
}

/* ── MAIN ── */
int main(int argc, char *argv[]) {
    if (argc < 2) {
        print_help();
        return 1;
    }

    char *app_dir = get_app_dir();
    const char *cmd = argv[1];

    if (strcmp(cmd, "install") == 0) {
        return do_install(app_dir);
    }
    else if (strcmp(cmd, "uninstall") == 0) {
        return do_uninstall(app_dir);
    }
    else if (strcmp(cmd, "analyze") == 0) {
        const char *kernel = (argc > 2) ? argv[2] : "linux-6.6.1";
        return do_analyze(app_dir, kernel);
    }
    else if (strcmp(cmd, "test") == 0) {
        return do_test(app_dir);
    }
    else if (strcmp(cmd, "start-db") == 0) {
        return do_start_db(app_dir);
    }
    else if (strcmp(cmd, "stop-db") == 0) {
        return do_stop_db(app_dir);
    }
    else if (strcmp(cmd, "clean") == 0) {
        return do_clean(app_dir);
    }
    else if (strcmp(cmd, "status") == 0) {
        return do_status(app_dir);
    }
    else if (strcmp(cmd, "--help") == 0 || strcmp(cmd, "-h") == 0) {
        print_help();
        return 0;
    }
    else {
        printf("Unknown command: %s\n\n", cmd);
        print_help();
        return 1;
    }
}
