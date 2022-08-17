import json
import logging
import pwd
import utils


from pathlib import Path
from installer import Installer

if __name__ == "__main__":

    # Configure logging
    logging.basicConfig(
        filename=utils.INSTALLER_DIR/"installer.log",
        format="%(funcName)s - %(levelname)s - %(message)s",
        filemode="w",
        level=logging.INFO,
    )

    try:
        config_file_path = utils.INSTALLER_DIR/"installer.json"
        config_file = open(config_file_path, "r")
        config = json.load(config_file)
        config_file.close()
        logging.info("Configuration file loaded.")
    except Exception as e:
        logging.error("Failed to import installer configuration file")
        print("Failed. Check logs to debug")
        exit()

    Installer.run(config=config)

