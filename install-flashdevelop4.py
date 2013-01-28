__author__ = 'John Vrbanac <john.vrbanac@linux.com>'

# WARNING: USE AT YOUR OWN RISK!
# Tested on: Ubuntu 12.10 and wine-1.4.1
# Note: I've only got it to install FlashDevelop 4, but i'm still getting plugin errors.
#       I'll need to look into this further.

import os
import subprocess
import errno
import shutil

home_folder = os.path.expanduser("~")
prefix_folder = os.path.join(home_folder,".fd4")
os_dependencies = ["wine", "winetricks", "wget"]
win_dependencies = ["fontsmooth=rgb", "corefonts", "dotnet20sp1"]

def has_dependency(program_name):
    process = subprocess.Popen(["which", program_name], stdout=subprocess.PIPE)

    for line in process.stdout:
        if line.find(program_name) >= 0:
            return True
    return False


#TODO: Clean up
def check_for_dependencies():
    print("Checking for application dependencies...\n-------------------------------------------------")
    for dep in os_dependencies:
        result = has_dependency(dep)
        if result == False:
            print("Error! Please install package that contains " + dep)
            return result
        else:
            print(dep + "\t\t\t- Exists")

    return True

def download_file(url, output, print_name):
    print("Downloading " + print_name)
    if not os.path.exists(output):
        subprocess.call(["wget", url, "-O", output])

def create_prefix(path):
    print("Creating Wine Prefix...")
    os.environ["WINEARCH"] = "win32"
    os.environ["WINEPREFIX"] = os.path.abspath(path)
    subprocess.call(["wine", "wineboot"])

# Must call create_prefix first
def install_winetricks_dependencies():
    for dep in win_dependencies:
        subprocess.call(["winetricks", dep])

# Must call create_prefix first
def install_exe(path_to_exe):
    if os.path.exists(path_to_exe):
        subprocess.call(["wine", path_to_exe])

result = check_for_dependencies()
if result == False:
    exit(errno.ENOPKG)

# TODO: Add a warning about this removing anything in the ~/.fd folder
# Remove old prefix if exists
if os.path.isdir(prefix_folder):
    shutil.rmtree(prefix_folder)

# Prep dirs
dotnet_dl_dir = os.path.join(home_folder, ".cache/winetricks/dotnet20")
if not os.path.isdir(dotnet_dl_dir):
    os.makedirs(dotnet_dl_dir)

# Build a new wine prefix
create_prefix(prefix_folder)

# Time to get serious and download and install this stuff.
download_file("http://software-files-a.cnet.com/s/software/10/72/60/27/dotnetfx.exe?lop=link&ptype=3001&ontid=10250&siteId=4&edId=3&spi=73edf22481cb5c1cd7510d8868dd13ea&pid=10726027&psid=10726028&token=1359389825_85c0e7c1501fef2b1cefdcce3fe1d62d&fileName=dotnetfx.exe", os.path.join(dotnet_dl_dir, "dotnetfx.exe"), "Microsoft .NET 2.0")
download_file("http://javadl.sun.com/webapps/download/AutoDL?BundleId=71310", "/tmp/jre.exe", "Windows Java 32bit")
download_file("http://www.flashdevelop.org/downloads/releases/FlashDevelop-4.2.4-RTM.exe", "/tmp/fd4_setup.exe", "FlashDevelop 4")
download_file("http://download.macromedia.com/pub/flashplayer/updaters/11/flashplayer_11_ax_debug.exe", "/tmp/flash11_ax.exe", "Adobe Flash 11")

install_winetricks_dependencies()

install_exe("/tmp/jre.exe")
install_exe("/tmp/flash11_ax.exe")
install_exe("/tmp/fd4_setup.exe")
