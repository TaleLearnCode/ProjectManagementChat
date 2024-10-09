# This PowerShell script confirms with the user that they want to destroy all demo resources,
# executes `terraform destroy` on specified Terraform folders, and deletes specific Terraform files 
# and folders along with the service_principal_credentials.txt file. It also ensures that the user's 
# original working directory is restored upon completion.

# Display header message with changed foreground color
$headerColor = "Cyan"
Write-Host "=========================================" -ForegroundColor $headerColor
Write-Host "         Cleeanup Demo Resources         " -ForegroundColor $headerColor
Write-Host "=========================================" -ForegroundColor $headerColor
Write-Host ""

# Prompt for the Event Name
$eventName = (Read-Host -Prompt 'Enter the Event Name').Trim() -replace '\s', ''
Write-Host ""

# Confirm with the user that they want to destroy all demo resources
$confirmation = Read-Host -Prompt "Are you sure you want to cleanup (destory) all demo resources? (yes/no)"
if ($confirmation -ne "yes") {
    Write-Host "Operation cancelled." -ForegroundColor "Red"
    exit
}

# Prompt to sign into Azure using the Azure CLI
az login
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Save the current location
$originalLocation = Get-Location

# Get the directory of the script
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Array of relative Terraform directories
$terraformDirs = @(
    "$scriptDir\..\infra\service-principal"#,
    #"$scriptDir\..\infra\config",
    #"$scriptDir\..\infra\app"
)

# Function to perform terraform destroy and delete files
function Remove-TerraformResources {
    param (
        [string]$directory
    )
    
    Set-Location -Path $directory
    
    # Perform terraform destroy, passing event name as variable if it's the service-principal directory
    if ($directory -match "service-principal") {
        terraform destroy -auto-approve -var "service_principal_name=PMC-$eventName"
    } else {
        terraform destroy -auto-approve
    }    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    
    # Delete specific Terraform files and folders
    Remove-Item -Recurse -Force .terraform, terraform.tfstate, terraform.tfstate.backup, .terraform.lock.hcl
}

# Loop through each directory and call the destroy function
foreach ($dir in $terraformDirs) {
    Remove-TerraformResources -directory $dir
}

# Return to the original location
Set-Location -Path $originalLocation

# Display completion message
Write-Host ""
Write-Host ""
Write-Host "Demo Resources Successfully Destroyed" -ForegroundColor Green