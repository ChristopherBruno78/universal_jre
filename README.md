Bash script that creates a universal binary, from the Azul Zulu JRE, for macOS ARM (Apple Silicon) and Intel architectures

Intended for distribution as a private JRE with applications; the resulting package is a JRE only.

For convenience, zulu-19 ARM and Intel JREs are included in the repository. You can replace these folders with any ARM and Intel JRE in the respective locations.

Requires lipo to be installed (comes with Apple Developer tools).

To run, from the command line:

    sh create.sh
