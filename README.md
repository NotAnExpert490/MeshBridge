# MeshBridge
Node red flow to bridge meshtastic and mesh core

# Dependencies:
The project requires Node-RED, Meshcore-CLI, Meshtastic-CLI and an mqtt broker (Current testing is using eqmx, but may switch to mosquitto later).

- Meshcore-CLI: github.com/meshcore-dev/meshcore-cli
- Meshtastic-CLI: https://meshtastic.org/docs/software/python/cli/
- Node-RED: nodered.org
- EQMX: https://docs.exmx.com/en/eqmx/latest/deploy/install-docker.html

# Radio configuration
As of right now the only major configuration to make is to set up mqtt on the meshtastic side node and point it at the broker. Currently the Root topic is 89523/public, however this will change in later updates, so keep an eye out.

# Message routing
## MT ---> MC
When the MC node recieves a message it's forewarded to mqtt. Node-RED sees the packet on mqtt and formats it. Node red then calls meshcore-cli to send the message to the mc node. It also locks out bluetooth to mc ---> mt while sending

## MC ---> MT
Every 20 seconds node-RED calls meshcore-cli to check for messages. If any are found they are formatted and sent to the mt node via meshtastic cli.

# Potential issues with this approach
- Since each cli command requires a handshake with the node it takes a couple seconds to send a message. It may be possible for the rate limit que to fill during heavy use.
- There is currently no error handling on the cli side, this will be addressed in the future.
- Many single points of failure and a fairly complex system.

# Advantages
- It works... sort of. (Eventually I want to write something more robust in python) 

