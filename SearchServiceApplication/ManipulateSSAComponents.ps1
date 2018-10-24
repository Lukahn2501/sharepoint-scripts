# Examples of topology manipulation
# USAGE: Run each at a time (because you need to be waiting for an SSA instance to boot)
# WARNING: Edit before use considering needs
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
# Cloning the active topology to manipulate it instead of the active one
$clone = New-SPEnterpriseSearchTopology -SearchApplication $ssa -Clone -SearchTopology $active
# Suspend the Search Service Application
$ssa | Suspend-SPEnterpriseSearchServiceApplication
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
    # Activating the new topology
    Set-SPEnterpriseSearchTopology -Identity $clone
# REMOVING COMPONENTS FROM HOST A
    # Get the components 
    Get-SPEnterpriseSearchComponent -SearchTopology $clone # Note the id of the component you want to remove
    # Remove the component with the right id
    Remove-SPEnterpriseSearchComponent -Identity <Search component id> -SearchTopology $clone
# Resume the search service application
$ssa | Resume-SPEnterpriseSearchServiceApplication