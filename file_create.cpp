#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>

using namespace std;

int main(int argc, char* argv[]) {
    if (argc != 3) {
        cerr << "Usage: ./generate_input output-file.txt n" << endl;
        return 1;
    }

    string outputFile = argv[1];
    int n = stoi(argv[2]);

    ofstream outFile(outputFile);
    if (!outFile) {
        cerr << "Error opening file!" << endl;
        return 1;
    }

    srand(time(0)); // Seed for random number generation
    for (int i = 0; i < n; ++i) {
        outFile << rand() % 100000<< "\n"; // Generates random numbers between 0 and 99999
    }

    outFile.close();
    cout << "Random input file generated: " << outputFile << endl;
    return 0;
}


// g++ -o generate_input file_create.cpp
// ./generate_input input.txt 10000
