# MMLS-Downloader
Simple tool to download and update your mmls lecture notes, tutorials and assignments.

###Features
- Organizes lecture notes, tutorials, and assignments into relevant folders


### To Run
#### Gem Version ( Mac OS X and Linux only )
1. Have Ruby installed
2. run ` gem install mmls-downloader ` in your terminal
3. Once installed, run ` mmls update ` , first run will ask for your login credentials and download path
4. to refresh your files with the latest on mmls, just run ` mmls update ` again
5. run ` mmls set_path [ path ] ` to change download path
  - some defaults have been provided for Mac OS X
    - documents
    - icloud
    - downloads
    
    e.g ` mmls set_path documents `
    

#### Script Version
- Binary Release(Windows only)
  - Windows users, just download the attached binary under releases.
- Compile From Source
  1. Install Ruby
    - Windows 
      - http://rubyinstaller.org/ ( Nokogiri does not support Ruby 2.2.0 at time or writing so get 2.0.0   instead)
    - Linux/MacOSX 
      - Anyway you which, but i recommend RVM https://rvm.io/rvm/install
  2. run ` bundle install `
  3. run ` ruby mmls_downloader.rb `
  
[<img src="https://cloud.githubusercontent.com/assets/7908951/10385129/646fac8a-6e77-11e5-80cc-cd52798853d3.png" width=355 height=240>](Example)
[<img src="https://cloud.githubusercontent.com/assets/7908951/10385130/6470c084-6e77-11e5-8a87-92d3737f3c52.png" width=323 height=240>](Example)
