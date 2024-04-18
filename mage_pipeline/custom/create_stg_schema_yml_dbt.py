import ruamel.yaml
import os
from pathlib import Path
from os import path
from mage_ai.io.config import ConfigFileLoader
import os
from mage_ai.settings.repo import get_repo_path

@custom
def load_profile(*args, **kwargs):
    
    #Fecth config
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'
    config_loader = ConfigFileLoader(config_path, config_profile)

    local_dbt = get_repo_path() + '/dbt/models/staging/'
    local_dbt_path = Path(local_dbt)
    
    print('Writing  /dbt/models/staging/schema.yml...')
    
    yaml = ruamel.yaml.YAML()
    yaml.preserve_quotes = True
    yaml.explicit_start = True

    google_project_id = os.environ['GOOGLE_PROJECT_ID']
    yml = yaml.load(f"""
    version: 2

    sources:
      - name: staging
        database: {google_project_id}
        schema: traffic_counting
        tables:
          - name: traffic_counting_data_raw
    """
    )
    with open(local_dbt + '/schema.yml', 'w') as file:
        yaml.dump(yml, file)