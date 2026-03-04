# MeshBridge
Node-red flow to bridge meshtastic and mesh core

# Dependencies:
The project requires Node-RED, Meshcore-CLI, Meshtastic-CLI and mosquitto.

These can be installed by running install.sh as explained in installation or manually using the sources below.

- Meshcore-CLI: www.github.com/meshcore-dev/meshcore-cli
- Meshtastic-CLI: https://meshtastic.org/docs/software/python/cli/
- Node-RED: www.nodered.org
- EQMX: https://docs.exmx.com/en/eqmx/latest/deploy/install-docker.html
# Installation
1. Ensure our system is up to date by running ``` sudo apt update && sudo apt upgrade -y && sudo apt install git -y ```
2. Clone the meshbridge repo by running ``` git clone https://github.com/NotAnExpert490/MeshBridge.git ```
3. Move to the meshbridge directory with ``` cd MeshBridge ```
4. Run the installer script with ``` ./install.sh ``` This will install all services and dependancies then reboot.
# Radio configuration
- As of right now the only major configuration to make is to set up mqtt on the meshtastic side node and point it at the broker.
- MC side currently connects via serial and mt connects via web, but serial for both will be the ultimate gold standard.
- For the stability of the mesh.. and everyone's sanity, both radios are set with a specific channel for meshbridge. This way MeshBridge can be muted or opted out from. It also prevents routing all mesh traffic through the bridge which would slow everyone down.

# Message routing
## MT ---> MC
When the MC node recieves a message it's forewarded to mqtt. Node-RED sees the packet on mqtt and formats it. Node red then calls meshcore-cli to send the message to the mc node. It also locks out bluetooth to mc ---> mt while sending

## MC ---> MT
Every 21 seconds node-RED calls meshcore-cli to check for messages. If any are found they are formatted and sent to the mt node via meshtastic cli.

# Special routing and commands
## Interacting with bots
By default the flow adds the messaging nodes name on node id in the case of mt -> mc. This can be a problem when trying to interact with bots such as bbs's that expect exact inputs. Thats why as of 0.0.2 the #! function is used to pass a literal command without any other text attached. For example, if the bot expects a command like bbslist it can be bridged as #!bbslist. If there are additional moddifiers to a command put them in quotes. Example, bbsread #1 can be sent as #!bbsread "#1" or bbspost @user #message can be sent as #!bbspost "@user #message". This feature is currently only supported on mc -> mt.

## Other commands
- $ping: Pings the meshbridge to get a proof of life response.
- $help: Lists commands that the bridge accepts.
- $bbshelp: Lists specific help for interacting with bridged bbs's and bots.
- $bridgestat: Lists runtime statistics for the bridge.

# Potential issues with this approach
- Since each cli command requires a handshake with the node it takes a couple seconds to send a message. This can lead to slow bridging.
- There is currently no error handling on the cli side, this will be addressed in the future.
- Many single points of failure and a fairly complex system.

# Advantages
- It works... sort of. (Eventually I want to write something more robust in python) 

# Operational findings
- While it's easy to see if the message hit the mesh, it is very dificult to ensure it got bridged. This makes 2 way conversations in spotty coverage very difficult.
- With some practice and patience it is possible to continue a conversation while passing through dead zones by switching the mesh used to upload.
- More detailed metrics will be needed to figure out issues and improve performance.
- There were initally concerns about rate limiting exceeding buffer limits. Through practice this has been found not to be an issue. By setting the read request frequency 1 second longer than the write lockout the que clears it's self pretty quickly.
- It is still unclear what overall effect bridging has on the utilization of either mesh. Current rate limiting is set at 3 messages / minute. More testing and research will be needed to determine if it causes issues, but it doesn't seem to have any obvious effects on mesh performance.

# ChangeLog
- 2/20/26 -0.0.1: Added anylitics for number of messages bridged as well as number of errors. Fixed bug where numbers wouldn't foreward from mt -> mc
- 2/22/26 -0.0.2: Added #! commands on mc2mt, added $ping, added $bridgestat, added $help, added $bbshelp, added sendmt.sh to aid in sending #! commands, added mcsend.sh (not used yet).
- 2/24/26 -0.0.3: Fixed bug! Sometimes on mcsend the bluetooth will fail to connect but still return 0, because of this it would fail to bridge but still report a success. Added a module to read the direct output of mcsend to look for errors. Also added routines for repeated failures that will attempt node reboot. If problem presists it will attempt rpi reboot.
- 2/27/26 -0.0.4: Tweaked reboot handler to be less panicky on the mesh, Moved pi reboot to recovery.sh to check for a previous reboot and cancel infinite boot loops before they get out of hand. Also added monitor to check for messages on mt to detect mqtt and wifi issues.
- 2/28/26 -0.0.5: Started working on portable version which doesnt rely on hard coded values for things like usb paths, instead using setup scripts and config files. Also started working on installer script.
- 3/3/26  -0.1.0: Installer script seems to work. All mentions of /home/clockwork/ replaced with ~/ and paths hardened in general. Still has bugs and install.sh still cant set usb paths automatically. Created serialfix.sh to inject hardcoded values for now. Also created rebootnodes.sh to replace power cycling via the aiov2 board with a reboot request sent to the nodes.
