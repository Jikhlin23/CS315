#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <cmath>
#include <string>
#include <queue>
#include <stdexcept>


// Class to implement external merge sort with disk I/O simulation
class ExternalMergeSort {
private:
    std::string filename;     // Name of the input file
    long long n;              // Total number of keys to sort
    int k;                    // Size of each key in bytes
    int b;                    // Disk block size in bytes
    int m;                    // Available memory size in blocks
    int keys_per_block;       // Number of keys that fit in one block (b/k)
    long long memory_keys;    // Total keys that fit in memory (m*b/k)

    // Counters for simulating disk I/O
    long long total_seeks = 0;     // Total number of disk seeks
    long long total_transfers = 0; // Total number of block transfers

    // Counter for generating unique temporary file names
    int temp_file_count = 0;

    // Simulate reading num_blocks from disk
    void simulateDiskRead(int num_blocks) {
        total_seeks++;          // One seek to position the disk head
        total_transfers += num_blocks; // Transfer specified number of blocks
    }

    // Simulate writing num_blocks to disk
    void simulateDiskWrite(int num_blocks) {
        total_seeks++;          // One seek to position the disk head
        total_transfers += num_blocks; // Transfer specified number of blocks
    }

    // Generate a unique temporary filename for sorted runs
    std::string getTempFilename() {
        return "temp_run_" + std::to_string(temp_file_count++) + ".txt";
    }

public:
    // Constructor to initialize the sorter with input parameters
    ExternalMergeSort(std::string fname, long long num_keys, int key_size,
                     int block_size, int mem_blocks)
        : filename(fname), n(num_keys), k(key_size), b(block_size), m(mem_blocks) {
        if (b < k) { // Validate block size is at least key size
            throw std::invalid_argument("Block size (b) must be >= key size (k)");
        }
        keys_per_block = b / k;         // Calculate keys per block
        memory_keys = static_cast<long long>(m) * b / k; // Calculate total keys in memory
    }

    // Create initial sorted runs from the input file
    int initialRuns() {
        std::cout << "\nInitial Sorted Run Phase:\n";

        std::ifstream input(filename); // Open input file
        if (!input.is_open()) {
            throw std::runtime_error("Cannot open input file: " + filename);
        }

        int runs = std::ceil(static_cast<double>(n) / memory_keys); // Number of runs needed
        int blocks_per_run = std::ceil(static_cast<double>(memory_keys) / keys_per_block); // Blocks per run
        int seeks = 0;         // Seeks for this phase
        int transfers = 0;     // Transfers for this phase
        long long keys_processed = 0; // Track total keys processed

        std::vector<int> buffer; // Buffer to hold keys in memory
        buffer.reserve(memory_keys); // Pre-allocate memory for efficiency

        for (int i = 0; i < runs; i++) { // Process each run
            long long keys_to_process = std::min(memory_keys, n - keys_processed); // Keys for this run
            int blocks_to_process = std::ceil(static_cast<double>(keys_to_process) / keys_per_block); // Blocks needed

            buffer.clear(); // Clear buffer for new run
            for (long long j = 0; j < keys_to_process && keys_processed < n; j++) { // Read keys
                int key;
                if (input >> key) {
                    buffer.push_back(key);
                    keys_processed++;
                } else {
                    break; // Stop if input ends prematurely
                }
            }
            simulateDiskRead(blocks_to_process); // Simulate reading blocks
            seeks++;
            transfers += blocks_to_process;

            std::sort(buffer.begin(), buffer.end()); // Sort keys in memory

            std::string temp_file = getTempFilename(); // Get name for temp file
            std::ofstream output(temp_file); // Open temp file for writing
            if (!output.is_open()) {
                throw std::runtime_error("Cannot open temporary file: " + temp_file);
            }
            for (int key : buffer) { // Write sorted keys to file
                output << key << "\n";
            }
            output.close();
            simulateDiskWrite(blocks_to_process); // Simulate writing blocks
            seeks++;
            transfers += blocks_to_process;
        }
        input.close(); // Close input file

        // Output phase results
        std::cout << "Created " << runs << " initial sorted runs\n";
        std::cout << "Run size: " << memory_keys << " keys (" << blocks_per_run << " blocks)\n";
        std::cout << "Cost: " << seeks << " seeks, " << transfers << " transfers\n";

        return runs; // Return number of runs created
    }

    // Perform one merge pass to reduce the number of runs
    int mergePass(int pass_num, int num_runs) {
        std::cout << "\nMerge Pass " << pass_num << ":\n";

        int merge_degree = m - 1; // Number of runs to merge at once (m-1 way merge)
        int num_merges = std::ceil(static_cast<double>(num_runs) / merge_degree); // Number of merge operations
        int new_runs = num_merges; // Number of resulting runs

        int seeks = 0;     // Seeks for this pass
        int transfers = 0; // Transfers for this pass
        int current_run = 0; // Index of first run to merge

        for (int merge = 0; merge < num_merges; merge++) { // Perform each merge
            int runs_to_merge = std::min(merge_degree, num_runs - (merge * merge_degree)); // Runs in this merge
            int run_size_blocks = std::ceil(static_cast<double>(memory_keys) / keys_per_block); // Blocks per run

            std::vector<std::ifstream> inputs; // Vector of input file streams
            using PQType = std::pair<int, int>; // Priority queue type: {key, file_index}
            // Min-heap for merging smallest keys first
            std::priority_queue<PQType, std::vector<PQType>, std::greater<PQType>> pq;

            for (int i = 0; i < runs_to_merge; i++) { // Open input runs
                std::string fname = "temp_run_" + std::to_string(current_run + i) + ".txt";
                inputs.emplace_back(fname); // Open file
                if (!inputs[i].is_open()) {
                    throw std::runtime_error("Cannot open temp file: " + fname);
                }
                int key;
                if (inputs[i] >> key) { // Read first key from each run
                    pq.push({key, i});
                }
            }
            current_run += runs_to_merge; // Update starting run index

            int total_input_blocks = run_size_blocks * runs_to_merge; // Total blocks to read
            simulateDiskRead(total_input_blocks); // Simulate reading all blocks
            seeks++;
            transfers += total_input_blocks;

            std::string temp_file = getTempFilename(); // New temp file for merged run
            std::ofstream output(temp_file); // Open output file
            if (!output.is_open()) {
                throw std::runtime_error("Cannot open temporary file: " + temp_file);
            }
            while (!pq.empty()) { // Merge keys using priority queue
                auto [key, file_idx] = pq.top(); // Get smallest key
                pq.pop();
                output << key << "\n"; // Write to output
                int next_key;
                if (inputs[file_idx] >> next_key) { // Read next key from same file
                    pq.push({next_key, file_idx});
                }
            }

            int output_blocks = run_size_blocks * runs_to_merge; // Total blocks to write
            simulateDiskWrite(output_blocks); // Simulate writing merged run
            seeks++;
            transfers += output_blocks;

            for (auto& in : inputs) { // Close all input files
                in.close();
            }
            output.close(); // Close output file

            std::cout << "Merge " << merge + 1 << ": Merged " << runs_to_merge
                     << " runs into 1\n"; // Report merge details
        }

        std::cout << "Cost: " << seeks << " seeks, " << transfers << " transfers\n"; // Report pass cost
        return new_runs; // Return number of new runs
    }

    // Execute the full external merge sort process
    void externalMergeSort() {
        int num_runs = initialRuns(); // Create initial runs
        int merge_passes = 0; // Count of merge passes

        while (num_runs > 1) { // Merge until one run remains
            num_runs = mergePass(merge_passes + 1, num_runs);
            merge_passes++;
        }

        std::string final_run = "temp_run_" + std::to_string(temp_file_count - 1) + ".txt"; // Final run file
        if (std::rename(final_run.c_str(), "output.txt") != 0) { // Rename to output.txt
            throw std::runtime_error("Failed to rename final run to output.txt");
        }

        // Output final results
        std::cout << "\nTotal Number of Merge Passes: " << merge_passes << "\n";
        std::cout << "Total Disk Seeks: " << total_seeks << "\n";
        std::cout << "Total Disk Transfers: " << total_transfers << "\n";
        std::cout << "Sorted list written to output.txt\n";
    }
};

// Program entry point
int main(int argc, char* argv[]) {
    if (argc != 6) { // Check for correct number of arguments
        std::cerr << "Usage: " << argv[0]
                  << " input-file n k b m\n";
        return 1;
    }

    try {
        // Parse command-line arguments
        std::string filename = argv[1];
        long long n = std::atoll(argv[2]); // Total keys
        int k = std::atoi(argv[3]);        // Key size
        int b = std::atoi(argv[4]);        // Block size
        int m = std::atoi(argv[5]);        // Memory blocks

        ExternalMergeSort sorter(filename, n, k, b, m); // Create sorter object
        sorter.externalMergeSort(); // Run the sort
    } catch (const std::exception& e) { // Handle exceptions
        std::cerr << "Error: " << e.what() << "\n";
        return 1;
    }

    return 0; // Successful execution
}
