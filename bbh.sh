#!/bin/bash

# Function to display help
display_help() {
        echo "Usage: $0 [option...] {URL} {WORDLIST}" >&2
        echo
        echo "   -h, --help          Display this help message"
        echo "   URL                 Target URL"
        echo "   WORDLIST            Path to wordlist"
        echo
        exit 1
}

# Parse command-line options
while (( "$#" )); do
    case "$1" in
        -h|--help)
            display_help
            ;;
        --) # end argument parsing
            shift
            break
            ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2
            exit 1
            ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
    esac
done

# Set positional arguments in their proper place
eval set -- "$PARAMS"

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
        echo "Error: Incorrect number of arguments" >&2
        display_help
fi

# Set the target URL and wordlist path from command-line arguments
# Set the target URL and wordlist path from command-line arguments
TARGET_URL=$1
WORDLIST_PATH=$2



# Create a new directory with the name of the target URL
OUTPUT_DIR=$(echo $TARGET_URL | sed 's/https\?:\/\///' | sed 's/[\/:]/_/g')
mkdir -p $OUTPUT_DIR
#nmap enum 
nmap -sCV -p 80, 443, 8080 $TARGET_URL > $OUTPUT_DIR/nmap.txt

# Use ffuf for fuzzing
echo "Running ffuf..."
ffuf -w $WORDLIST_PATH -u $TARGET_URL/FUZZ > $OUTPUT_DIR/ffuf.txt

# Use gobuster for directory busting
echo "Running gobuster..."
gobuster dir -u $TARGET_URL -w $WORDLIST_PATH > $OUTPUT_DIR/gobuster.txt

# Use dirbuster (note: dirbuster is a GUI tool, here is a CLI alternative)
echo "Running dirb..."
dirb $TARGET_URL $WORDLIST_PATH > $OUTPUT_DIR/dirb.txt

# Use amass for subdomain enumeration
echo "Running amass..."
amass enum -d $TARGET_URL > $OUTPUT_DIR/amass.txt

# nuclei scan 
nuclei -u $TARGET_URL > $OUTPUT_DIR/nuclei.txt