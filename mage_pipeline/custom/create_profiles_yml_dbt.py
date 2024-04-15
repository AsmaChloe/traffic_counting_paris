import ruamel.yaml
import os
from pathlib import Path
from os import path
from mage_ai.io.config import ConfigFileLoader

from mage_ai.settings.repo import get_repo_path

@custom
def load_profile(*args, **kwargs):
    
    #Fecth config
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'
    config_loader = ConfigFileLoader(config_path, config_profile)

    local_dbt = get_repo_path() + '/dbt/traffic-couting-paris'
    local_dbt_path = Path(local_dbt)
    
    print('Writing demo profile...')
    
    yaml = ruamel.yaml.YAML()
    yaml.preserve_quotes = True
    yaml.explicit_start = True

    yml = yaml.load(f"""
    default:
        target: dev
        outputs:
            dev:
                type: bigquery
                method: service-account
                project: de-traffic-couting-paris
                dataset: traffic_counting
                threads: 4 # Must be a value of 1 or greater
                keyfile: "./../../secret/{{{{env_var('GOOGLE_SERVICE_ACC_KEY_NAME')}}}}"
    """
    )
# keyfile: {{ variables('GOOGLE_SERVICE_ACC_KEY_FILEPATH') }}
    with open(local_dbt + '/profiles.yml', 'w') as file:
        yaml.dump(yml, file)