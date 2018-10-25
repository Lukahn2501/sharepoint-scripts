# Examples of topology manipulation
# USAGE: Run each at a time (because you need to be waiting for an SSA instance to boot)
# WARNING: Edit before use considering needs
#          For index creating, you need to be on the server where you want to create the index
# Applies to : SharePoint 2013

# Starting the instances
$hostA = Get-SPEnterpriseSearchServiceInstance -Identity "Base Server Name"
$hostB = Get-SPEnterpriseSearchServiceInstance -Identity "Target Server Name"
Start-SPEnterpriseSearchServiceInstance -Identity $hostA
Start-SPEnterpriseSearchServiceInstance -Identity $hostB 
# Waiting for start and checking state
Get-SPEnterpriseSearchServiceInstance -Identity $hostA
Get-SPEnterpriseSearchServiceInstance -Identity $hostB
# Retrieving and printing active topology
$ssa = Get-SPEnterpriseSearchServiceApplication
$active = Get-SPEnterpriseSearchTopology -Active -SearchApplication $ssa 
$active
# Viewing every component in active topology
Get-SPEnterpriseSearchComponent -SearchTopology $active
# Suspend the Search Service Application
    # General Case
    $ssa | Suspend-SPEnterpriseSearchServiceApplication
    # For EVERY TOPOLOGY CHANGE
    $ssa.PauseForIndexRepartitioning()
# Cloning the active topology to manipulate it instead of the active one
$clone = New-SPEnterpriseSearchTopology -SearchApplication $ssa -Clone -SearchTopology $active
# ADDING COMPONENTS TO HOST B
    # Adding components to host B
    New-SPEnterpriseSearchAdminComponent -SearchTopology $clone -SearchServiceInstance $hostB
    New-SPEnterpriseSearchAnalyticsProcessingComponent -SearchTopology $clone -SearchServiceInstance $hostB
    New-SPEnterpriseSearchContentProcessingComponent -SearchTopology $clone -SearchServiceInstance $hostB
    New-SPEnterpriseSearchCrawlComponent -SearchTopology $clone -SearchServiceInstance $hostB
    New-SPEnterpriseSearchQueryProcessingComponent -SearchTopology $clone -SearchServiceInstance $hostB
    # Replicate Index
    New-SPEnterpriseSearchIndexComponent -SearchTopology $clone -SearchServiceInstance $hostB -IndexPartition 0
    # New Index Partition
    New-SPEnterpriseSearchIndexComponent -SearchTopology $clone -SearchServiceInstance $hostB -IndexPartition 1
    # Verifying the cloned topology
    Get-SPEnterpriseSearchComponent -SearchTopology $clone
# REMOVING COMPONENTS FROM HOST A
    # Get the components 
    Get-SPEnterpriseSearchComponent -SearchTopology $clone # Note the id of the component you want to remove
    # Remove the component with the right id
    Remove-SPEnterpriseSearchComponent -Identity <Search component id> -SearchTopology $clone
# Activating the new topology
Set-SPEnterpriseSearchTopology -Identity $clone
# Resume the search service application
$ssa | Resume-SPEnterpriseSearchServiceApplication
