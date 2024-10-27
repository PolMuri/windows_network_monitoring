# Ruta on guardarem el fitxer de registre
$logFilePath = "C:\logs\NetworkMonitor_$(Get-Date -Format 'yyyyMMdd').log"

# Crea la carpeta de logs si no existeix ja
$logDir = [System.IO.Path]::GetDirectoryName($logFilePath)
if (!(Test-Path -Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir
}

# Funció per obtenir connexions actives i si és possible obtenir el nom de domini
function Get-ConnectionDetails {
    # Obté les connexions TCP actives
    $connections = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }
    
    # Array per desar les estadístiques de cada connexió
    $connectionDetails = @()
    # Aquest procés pot fer que l'execució de l'script trigui una mica
    foreach ($connection in $connections) {
        # Obtenim el nom de domini fent una resolució DNS de l’adreça IP remota
        try {
            $domainName = [System.Net.Dns]::GetHostEntry($connection.RemoteAddress).HostName
        } catch {
            $domainName = "Not available"  # Si no hi ha nom de domini
        }

        # Creem un objecte amb les dades de la connexió
        $connectionInfo = [PSCustomObject]@{
            "Local Address" = "$($connection.LocalAddress):$($connection.LocalPort)"
            "Remote Address" = "$($connection.RemoteAddress):$($connection.RemotePort)"
            "Domain Name"   = $domainName
            "State"         = $connection.State
        }

        # Afegim la informació al nostre array
        $connectionDetails += $connectionInfo
    }

    # Retornem l'array amb les estadístiques de connexió detallades
    return $connectionDetails
}

# Funció per obtenir els ports oberts
function Get-OpenPorts {
    netstat -an | Select-String "LISTENING|ESTABLISHED"
}

# Funció per obtenir les estadístiques de dades de xarxa
function Get-NetworkDataStatistics {
    Get-NetAdapterStatistics | Select-Object -Property Name, ReceivedBytes, SentBytes
}

# Registre de la informació en el fitxer
function Log-NetworkInfo {
    # Obtenim la data i hora actuals
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Obtenim les connexions actives amb nom de domini
    $connections = Get-ConnectionDetails | Out-String

    # Obtenim els ports oberts
    $openPorts = Get-OpenPorts | Out-String

    # Obtenim les estadístiques de dades de xarxa
    $dataStats = Get-NetworkDataStatistics | Out-String

    # Escrivim la informació al fitxer de registre
    Add-Content -Path $logFilePath -Value "------------------------"
    Add-Content -Path $logFilePath -Value "Date: $timestamp"
    Add-Content -Path $logFilePath -Value "Active conections (With domain name if available):"
    Add-Content -Path $logFilePath -Value $connections
    Add-Content -Path $logFilePath -Value "Open ports:"
    Add-Content -Path $logFilePath -Value $openPorts
    Add-Content -Path $logFilePath -Value "Network aata statistics:"
    Add-Content -Path $logFilePath -Value $dataStats
    Add-Content -Path $logFilePath -Value "------------------------`n"
}

# Executa el registre
Log-NetworkInfo
