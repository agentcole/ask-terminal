# ask

`ask` is a command-line tool that interacts with OpenAI's GPT-3.5-turbo model to provide UNIX, Mac terminal and Powershell commands based on user prompts. This tool is designed to be easily configurable and accessible from anywhere in your terminal.

## Features

- Sends custom prompts to OpenAI and retrieves terminal commands.
- Configurable API key storage.
- Falls back to using `awk` for JSON parsing if `jq` fails or is not available.
- Debugging information included to help identify issues.

## Prerequisites

### Linux/Mac
- `curl`: Command-line tool for transferring data with URLs.
- `jq` (optional): Command-line JSON processor. Install using Homebrew:

  ```sh
  brew install jq
  ```
### Windows
- Powershell 7 is the minimum required version


## Installation

1. **Clone the repository:**

   ```sh
   git clone https://github.com/yourusername/ask.git
   cd ask
   ```

2. **Make the script executable:**

   ```sh
   chmod +x ask
   ```

3. **Move the script to a directory in your PATH:**

   ```sh
   sudo mv ask /usr/local/bin/ask
   ```

4. **Ensure the directory is in your PATH:**

   Add the following line to your `~/.zshrc` (or `~/.bashrc` for bash users):

   ```sh
   export PATH=$HOME/bin:$PATH
   ```

   Reload your profile configuration:

   ```sh
   source ~/.zshrc
   ```

## Configuration

Before using `ask`, you need to configure your OpenAI API key.

1. Run the configure command:

   ```sh
   ask --configure
   ```

2. Enter your OpenAI API key when prompted. The API key will be saved in `~/.openai_config`.

## Usage

To use the `ask` tool, simply provide a prompt describing what you want to achieve. For example:

   ```sh
   ask \"I want to move all my git changes in the current branch to main\"
   ```

### Example Output

   ```sh
   git checkout main && git merge --strategy=ours <branch-name>
   ```

## Debugging

The script includes debugging information that can help identify issues during the execution. It prints out the raw JSON response from the API, the extracted content, and the final cleaned command.

## Fallback Mechanism

If `jq` fails or is not installed, the script falls back to using `awk` for JSON parsing.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.

## License

This project is licensed under the MIT License.
