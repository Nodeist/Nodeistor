# Grafana Monitor for the Cosmos Ecosystem
## Prerequisites
### Install `exporter` on your node server if Node is installed.

```shell
wget -O NodeistorExporter.sh https://raw.githubusercontent.com/Nodeist/Nodeistor/main/NodeistorExporter && chmod +x NodeistorExporter.sh && ./NodeistorExporter.sh
```

During the installation, you will be asked for some information, including:

| KEY           | VALUE                                                        |
| ------------- | ------------------------------------------------------------ |
| **bond_denom**| Denom Value. For example, `uosmo` for osmosis                |
| **bench_prefix**| Bench Prefix Value. For example, `osmo` for osmosis. You can obtain this value from your wallet address. **osmo**1r5g0kes6jutsydez9qw2tx6vuc8scpxn5qtyle |
| **adresport** | Address Port. Default is 9090. Check in app.toml           |
| **ladrport**  | Laddr Port. Default is 26657. Check in config.toml.        |

Make sure the following ports are open on your server:
- `9100` (node-exporter)
- `9300` (cosmos-exporter)

## Grafana Monitor Installation

We recommend installing the Grafana monitor on a separate server to be able to track and analyze your validator correctly. This way, you can monitor the data even if your node goes down, your server crashes, etc. The system requirements for the monitor are not very demanding. A system with the following specifications is sufficient:

### System Requirements

Ubuntu 20.04 / 1 VCPU / 2 GB RAM / 20 GB SSD

### Monitor Installation

You can complete the monitor installation on your new server by running the following code:

```shell
wget -O NodeistMonitor.sh https://raw.githubusercontent.com/Nodeist/Nodeistor/main/NodeistMonitor && chmod +x NodeistMonitor.sh && ./NodeistMonitor.sh
```

### Adding Validator to Prometheus Configuration

You can use the following code multiple times for different networks. This means you can view statistics for multiple validators on the same monitor. To do this, modify the code below for each network you want to add.

```shell
$HOME/Nodeistor/ag_ekle.sh VALIDATOR_IP WALLET_ADDRESS VALOPER_ADDRESS PROJECT_NAME
```

For example:

```shell
$HOME/Nodeistor/ag_ekle.sh 1.2.3.4 osmovaloper1s9rtstp8amx9vgsekhf3rk4rdr7qvg8dlxuy8v osmo1s9rtstp8amx9vgsekhf3rk4rdr7qvg8d6jg3tl osmosis
```

### Start Docker

Start the monitor deployment.

```shell
cd $HOME/Nodeistor && docker compose up -d
```

Ports used:
- `9090` (prometheus)
- `9999` (grafana)

## Settings

### Grafana Configuration

1. Open your web browser and go to `your_server_ip_address:9999` to access the Grafana interface.

![image](https://i.hizliresim.com/q5v1rxg.png)

2. Your username and password are both `admin`. After the first login, you will be prompted to change your password.

3. Import Nodeistor.

   3.1. Click on the `+` icon in the left menu and select `Import` from the pop-up window.

   ![image](https://i.hizliresim.com/g76skvm.png)

   3.2. Enter the grafana.com dashboard ID `16580`. Then click `Load`.

   ![image](https://i.hizliresim.com/2c4ely8.png)

   3.3. Choose Prometheus as the data source and click on Import.

   ![image](https://i.hizliresim.com/achuede.png)

4. Configure the Explorer

   Normally, the "Most Missed Blocks" panel is tailored to the nodes.guru explorer. If you want to add a network that is not in the nodes.guru explorer, you need to make adjustments in the "Most Missed Blocks" tab.

   > This step is only applicable to the "Most Missed Blocks" tab and is not mandatory.

   Click on the tab title and then click on "edit."

   ![image](https://i.hizliresim.com/7g70srb.png)

   4.1. **Overrides** tab.

   ![image](https://i.hizliresim.com/abdah90.png)

   4.2. Click on the "edit" button in the "datalink" section.

   ![image](https://i.hizliresim.com/gpqoyah.png)

   4.3. Update the Explorer address and click "Save."

   ![image](https://i.hizliresim.com/b1st4xn.png)

   4.4. Finally, click the "Save" button in the upper right corner and then click "Apply" to apply the changes.

5. Congratulations! You have successfully installed and configured Nodeistor.

## Dashboard Contents

The Grafana dashboard is divided into four sections:

- **Validator Health** - main statistics for validator health, connected peers, and missed blocks
- **Chain Health** - summary statistics for chain health and a list of the top validators with missing blocks
- **Validator Statistics** - information about the validator, such as ranking, bonded tokens, commission, delegations, and rewards
- **Hardware Health** - system hardware measurements, including CPU, RAM, and network usage

## Resetting Statistics

```shell
cd $HOME/Nodeistor
docker compose down
docker volume prune -f
```

## Reference List

Resources used in this project:

- Grafana Validator Statistics [Cosmos Validator by freak12techno](https://grafana.com/grafana/dashboards/14914)
- Grafana Hardware Health [AgoricTools by Chainode](https://github.com/Chainode/AgoricTools)
- Stack of monitoring tools, Docker configuration [node_tooling by Xiphiar](https://github.com/Xiphiar/node_tooling/)
- And all pieces put together by [Kristaps](https://github.com/kj89)
```

