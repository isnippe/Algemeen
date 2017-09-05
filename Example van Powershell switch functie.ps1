Function Get-AllPackages{

    Import-Module $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386","\bin\configurationmanager.psd1")
    $SiteCode = Get-PSDrive -PSProvider CMSite
    CD "$($SiteCode):"

    $PackageIDList = Import-Csv "C:\Temp\Scripts\OSD\PackageID.csv"

    foreach ($PackageItem in $PackageIDList){
        $PackageID = $PackageItem.PackageID
        $Packages = Get-CMDeploymentPackage -DistributionPointName "GDISW4016.beheer.papilionem.nl" | where {$_.PackageID -match $PackageID} | Select-Object PackageID, Name, ObjectTypeID 
    
        $PackageID = $Packages.PackageID
        $PackageName = $Packages.Name
        $ObjectTypeID = $Packages.ObjectTypeID
    
        New-Object psobject -Property @{
            PackageID = $PackageID
            Name = $PackageName
            ObjectType = switch ($ObjectTypeID){
                2{"Package"} 
                14{"Operating System Image"}
                18{"ImagePackage"}
                19{"Boot Image"}
                23{"Driver Package"}
                24{"Software Update Package"}
                31{"Application"}
            }
        }
    
    }
} 
