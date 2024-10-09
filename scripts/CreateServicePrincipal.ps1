# This PowerShell script signs into Azure using the Azure CLI, initializes, validates, 
# and applies a Terraform configuration located in the \infra\service-principal folder. 
# It prompts the user for the Service Principal Name and supplies that value to the 
# Terraform apply command. The script also ensures that the user's original working 
# directory is restored after the script completes.

# Display header message
$headerColor = "Cyan"
Write-Host "=========================================" -ForegroundColor $headerColor
Write-Host "         Starting Terraform Script         " -ForegroundColor $headerColor
Write-Host "=========================================" -ForegroundColor $headerColor
Write-Host ""

# Prompt for the Event Name
$eventName = (Read-Host -Prompt 'Enter the Event Name').Trim() -replace '\s', ''

# Save the current location
$originalLocation = Get-Location

# Set the location to where the script is located
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location -Path $scriptDir

# Prompt to sign into Azure using the Azure CLI
az login
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Change to the directory containing the Terraform configuration
Set-Location -Path '..\infra\service-principal'

# Initialize Terraform
terraform init
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Validate the configuration
terraform validate
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Apply the configuration with the service principal name
terraform apply -var "service_principal_name=PMC-$eventName"
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Open the service_principal_credentials.txt file in Visual Studio Code
code .\service_principal_credentials.txt

# Return to the original location
Set-Location -Path $originalLocation

# Display completion message
Write-Host "========================================="
Write-Host "       Terraform Script Completed       "
Write-Host "========================================="
