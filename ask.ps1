# Configuration file for storing the API key
$CONFIG_FILE = "$HOME\.openai_api_key"

# Default prompt to set the context
$DEFAULT_PROMPT = "You are a Windows Powershell expert. Answer the following question only with the right command and nothing else."

# Function to configure the API key
function Configure-ApiKey {
    Write-Host "Please enter your OpenAI API key:"
    $api_key = Read-Host -AsSecureString
    $encrypted_api_key = $api_key | ConvertFrom-SecureString -SecureString
    Set-Content -Path $CONFIG_FILE -Value $encrypted_api_key
    Write-Host "API key saved to $CONFIG_FILE"
}

# Function to load the API key from the config file
function Load-ApiKey {
    if (Test-Path $CONFIG_FILE) {
        $encrypted_api_key = Get-Content -Path $CONFIG_FILE
        $global:api_key = $encrypted_api_key | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText
    } else {
        Write-Host "API key not configured. Please run 'ask --configure' to set it up."
        exit 1
    }
}

# Function to send the prompt to OpenAI and get the response
function Send-Request {
    param (
        [string]$user_prompt
    )

    $prompt = "$DEFAULT_PROMPT $user_prompt"

    $response = Invoke-RestMethod -Method Post -Uri "https://api.openai.com/v1/chat/completions" `
        -Headers @{"Authorization"="Bearer $global:api_key"; "Content-Type"="application/json"} `
        -Body (@{
            "model" = "gpt-4-turbo"
            "messages" = @(
                @{
                    "role" = "system"
                    "content" = $DEFAULT_PROMPT
                },
                @{
                    "role" = "user"
                    "content" = $user_prompt
                }
            )
            "max_tokens" = 4000
            "temperature" = 0.2
        } | ConvertTo-Json)

    # Extract the content field from the JSON response
    try {
        $content = $response.choices[0].message.content
    } catch {
        Write-Host "Failed to parse the response."
        exit 1
    }

    # Remove the starting and ending code block markers (```bash and ```)
    $content = $content -replace '^```bash', '' -replace '```$', ''
    $command = $content -replace '^```powershell', '' -replace '```$', ''

    Write-Output $command
}

# Main logic
if ($args[0] -eq "--configure") {
    Configure-ApiKey
    exit 0
}

# Load the API key
Load-ApiKey

# Combine all arguments into a single user prompt string
$user_prompt = $args -join " "

# Send the request and print the response
Send-Request -user_prompt $user_prompt