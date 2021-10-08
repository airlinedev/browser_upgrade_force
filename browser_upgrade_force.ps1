# edge
# only continue if msedge is running
if (get-process '[m]sedge') {
    
    # only continue if new_msedge exists
    if (test-path 'C:\Program Files (x86)\Microsoft\Edge\Application\new_msedge.exe') {
        
        # get version of msedge running
        $msedge_version = (get-process msedge | where-object { $_.path -eq 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' } | select fileversion | get-unique).fileversion
        
        if (test-path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}') {
            # omaha updater creates a key named opv if a newer version is pending. opv stores the current version
            $opv = (get-itemproperty -path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}').opv
            if ($opv) {
                # get latest version as determined by the updater stored in pv
                $pv = (get-itemproperty -path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}').pv
                if ($pv) {
                    # make sure opv does not equal pv and current version of msedge process equals opv
                    if ($opv -ne $pv -and $opv -eq $msedge_version) {
                        # kill msedge and it will complete the pending update next time it starts
                        (get-process msedge | where-object { $_.path -eq 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' } | select id).id |  %{ stop-process -id $_ }
                    }
                }
            }
        }
    }
}

# chrome
# only continue if chrome is running
if (get-process '[c]hrome') {
    
    # only continue if new_chrome exists
    if (test-path 'C:\Program Files (x86)\Google\Chrome\Application\new_chrome.exe') {
        
        # get version of chrome running
        $chrome_version = (get-process chrome | where-object { $_.path -eq 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe' } | select fileversion | get-unique).fileversion
        
        if (test-path 'HKLM:\SOFTWARE\WOW6432Node\Google\Update\Clients\{8A69D345-D564-463c-AFF1-A69D9E530F96}') {
            # omaha updater creates a key named opv if a newer version is pending. opv stores the current version
            $opv = (get-itemproperty -path 'HKLM:\SOFTWARE\WOW6432Node\Google\Update\Clients\{8A69D345-D564-463c-AFF1-A69D9E530F96}').opv
            if ($opv) {
                # get latest version as determined by the updater stored in pv
                $pv = (get-itemproperty -path 'HKLM:\SOFTWARE\WOW6432Node\Google\Update\Clients\{8A69D345-D564-463c-AFF1-A69D9E530F96}').pv
                if ($pv) {
                    # make sure opv does not equal pv and current version of chrome process equals opv
                    if ($opv -ne $pv -and $opv -eq $chrome_version) {
                        # kill chrome and it will complete the pending update next time it starts
                        (get-process chrome | where-object { $_.path -eq 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe' } | select id).id |  %{ stop-process -id $_ }
                    }
                }
            }
        }
    }
}
