# MeshBridge
Node-red flow to bridge meshtastic and mesh core

# Dependencies:
The project requires Node-RED, Meshcore-CLI, Meshtastic-CLI and an mqtt broker (Current testing is using eqmx, but may switch to mosquitto later).

- Meshcore-CLI: www.github.com/meshcore-dev/meshcore-cli
- Meshtastic-CLI: https://meshtastic.org/docs/software/python/cli/
- Node-RED: www.nodered.org
- EQMX: https://docs.exmx.com/en/eqmx/latest/deploy/install-docker.html

# Radio configuration
- As of right now the only major configuration to make is to set up mqtt on the meshtastic side node and point it at the broker.
- MC side currently connects via ble and mt connects via web, but serial will be the ultimate gold standard.
- For the stability of the mesh.. and everyone's sanity, both radios are set with a specific channel for meshbridge. This way MeshBridge can be muted or opted out from. It also prevents routing all mesh traffic through the bridge which would slow everyone down.
# Message routing
## MT ---> MC
When the MC node recieves a message it's forewarded to mqtt. Node-RED sees the packet on mqtt and formats it. Node red then calls meshcore-cli to send the message to the mc node. It also locks out bluetooth to mc ---> mt while sending

## MC ---> MT
Every 20 seconds node-RED calls meshcore-cli to check for messages. If any are found they are formatted and sent to the mt node via meshtastic cli.
# Special routing and commands
## Interacting with bots
By default the flow adds the messaging nodes name on node id in the case of mt -> mc. This can be a problem when trying to interact with bots such as bbs's that expect exact inputs. Thats why as of 0.0.2 the #! function is used to pass a literal command without any other text attached. For example, if the bot expects a command like bbslist it can be bridged as #!bbslist. If there are additional moddifiers to a command put them in quotes. Example, bbsread #1 can be sent as #!bbsread "#1" or bbspost @user #message can be sent as #!bbspost "@user #message". This feature is currently only supported on mc -> mt.
## Other commands
- $ping: Pings the meshbridge to get a proof of life response.
- $help: Lists commands that the bridge accepts.
- $bbshelp: Lists specific help for interacting with bridged bbs's and bots.
- $bridgestat: Lists runtime statistics for the bridge.
# Potential issues with this approach
- Since each cli command requires a handshake with the node it takes a couple seconds to send a message. It may be possible for the rate limit que to fill during heavy use.
- There is currently no error handling on the cli side, this will be addressed in the future.
- Many single points of failure and a fairly complex system.

# Advantages
- It works... sort of. (Eventually I want to write something more robust in python) 

# Operational findings
- While it's easy to see if the message hit the mesh, it is very dificult to ensure it got bridged. This makes 2 way conversations in spotty coverage very difficult.
- With some practice and patience it is possible to continue a conversation while passing through dead zones by switching the mesh used to upload.
# ChangeLog
- 2/20/26: Added anylitics for number of messages bridged as well as number of errors. Fixed bug where numbers wouldn't foreward from mt -> mc
- 2/22/26: Added #! commands on mc2mt, added $ping, added $bridgestat, added $help, added $bbshelp, added sendmt.sh to aid in sending #! commands, added mcsend.sh (not used yet).
