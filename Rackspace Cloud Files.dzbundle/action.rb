# Dropzone Action Info
# Name: Rackspace Cloud Files
# Description: Uploads files to a Rackspace Cloud Files account container.\n\nYou will be prompted for the region and container on your first upload. Click the action to change the configured container.
# Handles: Files
# Creator: Alexandru Chirițescu
# URL: http://alexchiri.com
# OptionsNIB: UsernameAPIKey
# Events: Dragged, Clicked
# SkipConfig: No
# RunsSandboxed: No
# Version: 1.0
# MinDropzoneVersion: 3.0
# UniqueID: 1015

require 'lib/fog'
require 'rackspace'

def dragged
  rackspace = Rackspace.new

  $dz.determinate(false)
    
  $dz.begin("Connecting to Rackspace Cloud Files...")
  rackspace.configureClient()

  $dz.begin("Getting container...")

  remoteContainer = rackspace.getRemoteContainer()
  
  # If it doesn't exist, then error
  if(remoteContainer.nil?)
    $dz.error("Error", "Could not access or create the remote container")
  end

  urls ||= Array.new

  # Upload each file to the cloud files endpoint
  $items.each do |file|
    urls << rackspace.uploadFile(file, remoteContainer)
  end

  if urls.length == 1
    if urls[0].nil? or urls[0].to_s.strip.length == 0
      $dz.finish("No URL(s) were copied to clipboard, because CDN is disabled or no URL was returned!")
      $dz.url(false)
    else
      $dz.finish("URL is now in clipboard")
      $dz.text("#{urls[0]}")
    end
  elsif urls.length > 1
    mergedURLs = urls.join(" ")
    if mergedURLs.to_s.strip.length == 0
      $dz.finish("No URL(s) were copied to clipboard, because CDN is disabled or no URL was returned!")
      $dz.url(false)
    else
      $dz.finish("URLs are now in clipboard")
      $dz.text(mergedURLs)
    end
  end
    
end

def clicked
  rackspace = Rackspace.new

  $dz.determinate(false)

  rackspace.readRegion()
  rackspace.readContainerName()
  rackspace.readCDN()

  $dz.finish("Selected region and container name were saved!")

  $dz.url(false)
end