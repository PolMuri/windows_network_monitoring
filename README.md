# windows_network_monitoring
This script provides a useful overview for monitoring and analyzing network activity and detecting potential anomalies in the incoming and outgoing connections of the computer. Gets all established TCP connections, showing the local and remote IP address, port, and associated domain name

## Network Monitoring Script
This PowerShell script logs and monitors detailed network information on a Windows computer, including active connections, open ports, and network data usage. Logs are automatically saved in daily log files located in the C:\logs folder.

## Main Functions
-Get-ConnectionDetails: Retrieves all established TCP connections, displaying the local and remote IP addresses, ports, and associated domain names (when available).
-Get-OpenPorts: Lists all active ports in LISTENING or ESTABLISHED state, including HTTP and HTTPS connections.
-Get-NetworkDataStatistics: Gathers network usage data (received and sent bytes) for each network adapter.

## Log Format
The Log-NetworkInfo function creates a new daily log containing the date, active connections (with domain names if available), open ports, and network statistics. The log includes sections delineated for each category:

-Active Connections: Information on connections with remote IP addresses, ports, and domain names (if available).
-Open Ports: A list of ports with LISTENING or ESTABLISHED connections.
-Network Statistics: Received and sent bytes for each adapter.

## Instructions
-Log Location: Logs are saved in C:\logs in files formatted as NetworkMonitor_yyyyMMdd.log.
-Scheduling: It can be scheduled to run automatically every 24 hours using the Windows Task Scheduler.

